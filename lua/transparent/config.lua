local M = {}

---@class TransparentConfig
---@field groups? string[]|function
---@field extra_groups? string[]|function
---@field exclude_groups? string[]|function
---@field on_clear? function

---@class ResolvedTransparentConfig
---@field groups? string[]
---@field extra_groups? string[]
---@field exclude_groups? string[]
---@field on_clear? function

-- stylua: ignore start
---@type TransparentConfig
local config = {
  groups = {
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {},
  exclude_groups = {},
  on_clear = function () end
}
-- stylua: ignore end

function M.set(opts)
    opts = opts or {}

    vim.validate("opts", opts, "table")
    vim.validate("groups", opts.groups, { "table", "function" }, true)
    vim.validate("extra_groups", opts.extra_groups, { "table", "function" }, true)
    vim.validate("exclude_groups", opts.exclude_groups, { "table", "function" }, true)
    vim.validate("on_clear", opts.on_clear, "function", true)

    config = vim.tbl_extend("force", config, opts)
end

---@overload fun(): ResolvedTransparentConfig
---@overload fun(option: "groups"|"extra_groups"|"exclude_groups"): string[]
---@overload fun(option: "on_clear"): function
function M.get(option)
    local function resolve(value)
        if type(value) == "function" then
            return value()
        end
        return value
    end

    if not option then
        return {
            groups = resolve(config.groups),
            extra_groups = resolve(config.extra_groups),
            exclude_groups = resolve(config.exclude_groups),
            on_clear = config.on_clear,
        }
    end

    if option == "on_clear" then
        return config.on_clear
    end

    return resolve(config[option])
end

return M
