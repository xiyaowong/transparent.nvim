local M = {}

local config = {
  enable = false,
  groups = {
    "Normal",
    "NormalNC",
    "Comment",
    "Constant",
    "Special",
    "Identifier",
    "Statement",
    "PreProc",
    "Type",
    "Underlined",
    "Todo",
    "String",
    "Function",
    "Conditional",
    "Repeat",
    "Operator",
    "Structure",
    "LineNr",
    "NonText",
    "SignColumn",
    "CursorLineNr",
    "EndOfBuffer",
  },
  extra_groups = {},
  exclude = {},
}

local clear_group_bg = function(group, highlights)
  if not (group or highlights) then
    return
  end

  if group and vim.fn.highlight_exists(group) == 0 then
    return
  end

  group = group or vim.split(highlights, " ")[1]
  highlights = highlights or vim.api.nvim_exec("hi " .. group, true)

  if vim.tbl_contains(config.exclude, group) or highlights:match("links to") then
    return
  end

  vim.cmd(string.format("hi %s ctermbg=NONE guibg=NONE", group))
end

local function _clear_bg()
  if vim.g.transparent_enabled ~= true then
    return
  end
  for _, group in ipairs(config.groups) do
    clear_group_bg(group)
  end

  if type(config.extra_groups) == "string" then
    if config.extra_groups == "all" then
      local hls = vim.split(vim.api.nvim_exec("highlight", true), "\n")
      for _, hl in ipairs(hls) do
        clear_group_bg(nil, hl)
      end
    else
      clear_group_bg(config.extra_groups)
    end
  else
    for _, group in ipairs(config.extra_groups) do
      clear_group_bg(group)
    end
  end
end

function M.clear_bg()
  if vim.g.transparent_enabled ~= true then
    return
  end
  -- ? some plugins calculate colors from basic highlights
  -- : clear immediately
  _clear_bg()
  -- ? some plugins use autocommands to redefine highlights
  -- : clear again after a while
  vim.defer_fn(_clear_bg, 500)
  -- again
  vim.defer_fn(_clear_bg, 1000)
  -- yes, clear 4 times!!!
  vim.defer_fn(_clear_bg, 5000)
end

function M.toggle_transparent(option)
  if option == nil then
    vim.g.transparent_enabled = not vim.g.transparent_enabled
  else
    vim.g.transparent_enabled = option
  end
  if vim.g.colors_name then
    vim.cmd("colorscheme " .. vim.g.colors_name)
  else
    vim.cmd("doautocmd ColorScheme")
  end
end

function M.setup(user_config)
  config = vim.tbl_extend("force", config, user_config)
  if vim.g.transparent_enabled == nil then
    vim.g.transparent_enabled = config.enable
  end
end

return M
