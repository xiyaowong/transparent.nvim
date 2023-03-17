local M = {}

local config = {
  enable = false,
  save_state = true, -- allow save state to file
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
  ignore_linked_group = true,
}

local cache_path = vim.fn.stdpath("data") .. "/nvim-transparent"

local open_cache_file = function(mode)
  --- 438(10) == 666(8) [owner/group/others can read/write]
  local flags = 438
  local fd, err = vim.loop.fs_open(cache_path, mode, flags)
  if err then
    vim.api.nvim_notify(("Error opening cache file:\n\n%s"):format(err), vim.log.levels.ERROR, {})
  end
  return fd
end

local read_cache_file = function()
  local fd = open_cache_file("r")
  if not fd then
    return nil
  end

  local stat = assert(vim.loop.fs_fstat(fd))
  local data = assert(vim.loop.fs_read(fd, stat.size, -1))
  assert(vim.loop.fs_close(fd))

  local enabled, _ = data:gsub("[\n\r]", "")
  return enabled == "true"
end

local clear_group_bg = function(group, highlights)
  if not (group or highlights) then
    return
  end

  if group and vim.fn.highlight_exists(group) == 0 then
    return
  end

  group = group or vim.split(highlights, " ")[1]
  highlights = highlights or vim.api.nvim_exec("hi " .. group, true)

  if
    vim.tbl_contains(config.exclude, group)
    or (config.ignore_linked_group and highlights:match("links to"))
  then
    return
  end
  pcall(vim.cmd, string.format("hi %s ctermbg=NONE guibg=NONE", group))
  -- local ok, err = pcall(vim.cmd, string.format("hi %s ctermbg=NONE guibg=NONE", group))
  -- if not ok then
  --   vim.api.nvim_echo(
  --     {
  --       {
  --         string.format("[transparent]:error occurs when setting highlight `%s`: %s", group, err),
  --         "ErrorMsg",
  --       },
  --     },
  --     true,
  --     {}
  --   )
  -- end
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

  -- Write to cache file
  local fd = open_cache_file("w")
  if not fd then
    vim.api.nvim_notify("Could not write cache file!\n\n", vim.log.levels.ERROR, {})
    return
  end

  assert(vim.loop.fs_write(fd, ("%s\n"):format(vim.g.transparent_enabled), -1))
  assert(vim.loop.fs_close(fd))
end

function M.setup(user_config)
  config = vim.tbl_extend("force", config, user_config)

  -- Read cache file if enabled
  if config.enable and config.save_state then
    local save_state = read_cache_file()
    vim.g.transparent_enabled = save_state
  end

  if vim.g.transparent_enabled == nil then
    vim.g.transparent_enabled = config.enable
  end
end

return M
