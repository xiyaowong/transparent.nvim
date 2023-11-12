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
}
-- stylua: ignore end

function M.set(opts)
    opts = opts or {}

    local keys = vim.tbl_keys(opts)
    local msgs = {}
    if vim.tbl_contains(keys, "exclude") then
        table.insert(msgs, '- "exclude" has been changed to "exclude_groups".')
    end
    if vim.tbl_contains(keys, "ignore_linked_group") then
        table.insert(msgs, '- "ignore_linked_group" has been removed.')
    end
    if vim.tbl_contains(keys, "enable") then
        table.insert(msgs, '- "enable" has been removed.')
    end
    if type(opts.extra_groups) == "string" then
        table.insert(msgs, '- "extra_groups" must be a table.')
    end
    if not vim.tbl_isempty(msgs) then
        table.insert(
            msgs,
            1,
            "[transparent.nvim] Please check the README for detailed information."
        )
        local msg = table.concat(msgs, "\n")
        vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.WARN)
        end, 3000)
    end

    opts.enable = nil
    opts.ignore_linked_group = nil
    opts.exclude_groups = opts.exclude_groups or opts.exclude

    config = vim.tbl_extend("force", config, opts or {})
end

return setmetatable(M, {
    __index = function(_, k)
        return config[k]
    end,
})
