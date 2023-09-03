local M = {}

local config = require("transparent.config")
local cache = require("transparent.cache")

if vim.g.transparent_enabled == nil then
    cache.read()
end

-- used for getcompletion to get highlight groups
local group_prefix_list = {}

---@param group string|string[]
local function clear_group(group)
    -- local start = vim.loop.hrtime()

    local groups = type(group) == "string" and { group } or group
    for _, v in ipairs(groups) do
        if not vim.tbl_contains(config.exclude_groups, v) then
            local ok, prev_attrs = pcall(vim.api.nvim_get_hl_by_name, v, true)
            if ok and (prev_attrs.background or prev_attrs.bg or prev_attrs.ctermbg) then
                local attrs = vim.tbl_extend("force", prev_attrs, { bg = "NONE", ctermbg = "NONE" })
                attrs[true] = nil
                vim.api.nvim_set_hl(0, v, attrs)
            end
        end
    end

    -- print((vim.loop.hrtime() - start) / 1e6, "ms")
end

local function clear()
    -- local start = vim.loop.hrtime()

    if vim.g.transparent_enabled ~= true then
        return
    end

    clear_group(config.groups)
    clear_group(config.extra_groups)
    clear_group(type(vim.g.transparent_groups) == "table" and vim.g.transparent_groups or {})
    for _, prefix in ipairs(group_prefix_list) do
        clear_group(vim.fn.getcompletion(prefix, "highlight"))
    end

    -- print((vim.loop.hrtime() - start) / 1e6, "ms")
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
    vim.defer_fn(clear, 1e3)
    --- yes, clear 4 times!!!
    vim.defer_fn(clear, 3e3)
    --- Don't worry about performance, it's very cheap!
    vim.defer_fn(clear, 5e3)
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
        -- So many pcall...
        pcall(vim.cmd.colorscheme, vim.g.colors_name)
    else
        clear()
    end
end

function M.handle_groups_changed(arg)
    local old = arg.old or {}
    local new = arg.new or {}
    if
        type(old) == "table"
        and type(new) == "table"
        and vim.tbl_islist(old)
        and vim.tbl_islist(new)
    then
        clear_group(vim.tbl_filter(function(v)
            -- print(v)
            return not vim.tbl_contains(old, v)
        end, new))
    else
        vim.notify("g:transparent_groups must be a list")
    end
end

function M.clear_prefix(prefix)
    if not prefix or prefix == "" then
        return
    end
    if not vim.tbl_contains(group_prefix_list, prefix) then
        table.insert(group_prefix_list, prefix)
    end
    clear_group(vim.fn.getcompletion(prefix, "highlight"))
end

M.setup = config.set
M.clear_group = clear_group

return M
