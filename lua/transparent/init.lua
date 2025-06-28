local M = {}

local fn, api = vim.fn, vim.api
local config = require("transparent.config")
local cache = require("transparent.cache")

local islist = vim.islist or vim.tbl_islist

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
            local ok, prev_attrs = pcall(api.nvim_get_hl_by_name, v, true)
            if ok and (prev_attrs.background or prev_attrs.bg or prev_attrs.ctermbg) then
                local attrs = vim.tbl_extend("force", prev_attrs, { bg = "NONE", ctermbg = "NONE" })
                attrs[true] = nil
                api.nvim_set_hl(0, v, attrs)
            end
        end
    end

    -- print((vim.loop.hrtime() - start) / 1e6, "ms")
end

local function clear()
    -- local start = vim.loop.hrtime()

    if not vim.g.transparent_enabled then
        return
    end

    clear_group(config.groups)
    clear_group(config.extra_groups)
    clear_group(type(vim.g.transparent_groups) == "table" and vim.g.transparent_groups or {})
    for _, prefix in ipairs(group_prefix_list) do
        clear_group(fn.getcompletion(prefix, "highlight"))
    end

    -- print((vim.loop.hrtime() - start) / 1e6, "ms")
end

function M.clear()
    if not vim.g.transparent_enabled then
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

    --- post hooks
    api.nvim_exec_autocmds("User", { pattern = "TransparentClear", modeline = false })
    config.on_clear()
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
        M.clear()
    end
end

function M.handle_groups_changed(arg)
    local old = arg.old or {}
    local new = arg.new or {}
    if type(old) == "table" and type(new) == "table" and islist(old) and islist(new) then
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
    clear_group(fn.getcompletion(prefix, "highlight"))
end

function M.remove_prefix(prefix)
    if not prefix or prefix == "" then
        return
    end

    for index, value in pairs(group_prefix_list) do
        if value:match(prefix) then
            table.remove(group_prefix_list, index)
        end
    end
end

function M.remove_all_prefix()
    group_prefix_list = {}
end

M.setup = config.set
M.clear_group = clear_group

return M
