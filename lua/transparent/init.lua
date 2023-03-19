local M = {}

local config = require("transparent.config")
local cache = require("transparent.cache")

if vim.g.transparent_enabled == nil then
    cache.read()
end

local function clear_group(group)
    if not vim.tbl_contains(config.exclude_groups, group) then
        pcall(vim.cmd, string.format("hi %s ctermbg=NONE guibg=NONE", group))
    end
end

local function clear()
    if vim.g.transparent_enabled ~= true then
        return
    end

    -- groups
    for _, group in ipairs(config.groups) do
        M.clear_group(group)
    end

    -- extra_groups
    if type(config.extra_groups) == "string" then
        if config.extra_groups == "all" then
            local hls = vim.split(vim.api.nvim_exec("highlight", true), "\n")
            for _, hl in ipairs(hls) do
                clear_group(vim.split(hl, " ")[1])
            end
        else
            clear_group(config.extra_groups)
        end
    else
        for _, group in ipairs(config.extra_groups) do
            clear_group(group)
        end
    end
end

function M.clear()
    if vim.g.transparent_enabled ~= true then
        return
    end
    --- ? some plugins calculate colors from basic highlights
    --- : clear immediately
    -- local start = vim.loop.hrtime()
    clear()
    -- print((vim.loop.hrtime() - start) / 1e6, 'ms')
    --- ? some plugins use autocommands to redefine highlights
    --- : clear again after a while
    vim.defer_fn(clear, 500)
    --- again
    vim.defer_fn(clear, 1000)
    --- yes, clear 4 times!!!
    vim.defer_fn(clear, 5000)
end

function M.toggle(opt)
    if opt == nil then
        vim.g.transparent_enabled = not vim.g.transparent_enabled
    else
        vim.g.transparent_enabled = opt
    end
    cache.write()
    -- A standard theme plugin should support the "colorscheme" command and set the g:colors_name
    if vim.g.colors_name then
        vim.cmd("colorscheme " .. vim.g.colors_name)
    else
        clear()
    end
end

M.setup = config.set
M.clear_group = clear_group

-- Avoid strange issues caused by lazy loading.
-- The main issue is the order of defining transparency options for theme plugins and this plugin.
vim.defer_fn(function()
    M.toggle(vim.g.transparent_enabled)
end, 500)

return M
