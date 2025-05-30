local M = {}

-- stylua: ignore start
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
    vim.validate("groups", opts.groups, "table", true)
    vim.validate("extra_groups", opts.extra_groups, "table", true)
    vim.validate("exclude_groups", opts.exclude_groups, "table", true)
    vim.validate("on_clear", opts.on_clear, "function", true)
    config = vim.tbl_extend("force", config, opts)
end

return setmetatable(M, {
    __index = function(_, k)
        return config[k]
    end,
})
