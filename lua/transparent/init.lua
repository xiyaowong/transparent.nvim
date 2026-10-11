local M = {}

local fn, api = vim.fn, vim.api
local config = require("transparent.config")
local cache = require("transparent.cache")

---@diagnostic disable-next-line: deprecated
local islist = vim.islist or vim.tbl_islist

---@param group? string|string[]
local function clear_group(group)
    local groups = type(group) == "string" and { group } or group or {}
    for _, v in ipairs(groups) do
        local ok, prev_attrs = pcall(api.nvim_get_hl_by_name, v, true)
        if ok and (prev_attrs.background or prev_attrs.bg or prev_attrs.ctermbg) then
            local attrs = vim.tbl_extend("force", prev_attrs, { bg = "NONE", ctermbg = "NONE" })
            attrs[true] = nil
            api.nvim_set_hl(0, v, attrs)
        end
    end
end

---@param groups? string|string[]
---@param exclude? string[]
---@return string[]
local function filter_excluded(groups, exclude)
    local list = type(groups) == "string" and { groups } or groups
    if type(list) ~= "table" then
        return {}
    end
    if not exclude or next(exclude) == nil then
        return list
    end
    return vim.tbl_filter(function(group)
        return not vim.tbl_contains(exclude, group)
    end, list)
end

if vim.g.transparent_enabled == nil then
    cache.read()
end

---@alias Prefix string|function

-- used for getcompletion to get highlight groups
---@type (string|function)[]
local group_prefix_list = {}

---@param prefix Prefix
---@return string[]
local function get_groups_of_prefix(prefix)
    local pat = prefix
    if type(pat) == "function" then
        pat = pat()
    end
    if not pat then
        return {}
    end
    return fn.getcompletion(pat, "highlight")
end

local function clear()
    if not vim.g.transparent_enabled then
        return
    end

    local cfg = config.get()
    local exclude = cfg.exclude_groups

    local extra = type(vim.g.transparent_groups) == "table" and vim.g.transparent_groups or {}

    clear_group(filter_excluded(cfg.groups, exclude))
    clear_group(filter_excluded(cfg.extra_groups, exclude))
    clear_group(filter_excluded(extra, exclude))

    for _, prefix in ipairs(group_prefix_list) do
        clear_group(filter_excluded(get_groups_of_prefix(prefix), exclude))
    end
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
    config.get("on_clear")()
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
        local added = vim.tbl_filter(function(v)
            -- print(v)
            return not vim.tbl_contains(old, v)
        end, new)
        clear_group(filter_excluded(added, config.get("exclude_groups")))
    else
        vim.notify("g:transparent_groups must be a list")
    end
end

---@param prefix string|function
function M.clear_prefix(prefix)
    if not prefix or prefix == "" then
        return
    end
    if not vim.tbl_contains(group_prefix_list, prefix) then
        table.insert(group_prefix_list, prefix)
    end

    local groups = get_groups_of_prefix(prefix)
    clear_group(filter_excluded(groups, config.get("exclude_groups")))
end

M.setup = config.set
M.clear_group = clear_group

return M
