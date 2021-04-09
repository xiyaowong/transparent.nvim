local M = {}
local vim = vim

local config = {}
local default_config = {
	enable = true,
	groups = {
		"Normal",
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
}

local clear_group_bg = function(group)
	local highlights = vim.api.nvim_exec("highlight " .. group, true)
	if highlights:match("links to") then
		return
	end
	local term = highlights:match([[term=([%w#]+)]]) or "NONE"
	local ctermfg = highlights:match([[ctermfg=([%w#]+)]]) or "NONE"
	local gui = highlights:match([[gui=([%w#]+)]]) or "NONE"
	local guifg = highlights:match([[guifg=([%w#]+)]]) or "NONE"
	vim.cmd(string.format(
		"hi %s term=%s ctermfg=%s ctermbg=NONE gui=%s guifg=%s guibg=NONE",
		group,
		term,
		ctermfg,
		gui,
		guifg
	))
end

function M.clear_bg()
	if vim.g.transparent_enabled == 1 then
		for _, group in ipairs(config.groups) do
			clear_group_bg(group)
		end
		for _, group in ipairs(config.extra_groups) do
			clear_group_bg(group)
		end
	end
end

function M.enable_transparent()
	vim.g.transparent_enabled = 1
	vim.cmd("colorscheme " .. vim.g.colors_name)
end

function M.disable_transparent()
	vim.g.transparent_enabled = 0
	vim.cmd("colorscheme " .. vim.g.colors_name)
end

function M.toggle_transparent()
	vim.g.transparent_enabled = vim.g.transparent_enabled == 0 and 1 or 0
	vim.cmd("colorscheme " .. vim.g.colors_name)
end

function M.setup(user_config)
	config = vim.tbl_extend("force", default_config, user_config)
	if vim.g.transparent_enabled == nil then
		vim.g.transparent_enabled = config.enable and 1 or 0
	end
end

return M
