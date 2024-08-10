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
    vim.validate({
        groups = { opts.groups, "t", true },
        extra_groups = { opts.extra_groups, "t", true },
        exclude_groups = { opts.exclude_groups, "t", true },
        on_clear = { opts.on_clear, "f", true },
    })
    config = vim.tbl_extend("force", config, opts or {})
end

return setmetatable(M, {
    __index = function(_, k)
        return config[k]
    end,
})
