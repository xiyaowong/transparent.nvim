# nvim-transparent

Remove all background colors to make nvim transparent.

![demo](https://user-images.githubusercontent.com/47070852/226154013-bc0168ba-c914-442e-9132-1e86d1899bc5.gif)

---

## Installation

`xiyaowong/transparent.nvim`

Same as other normal plugins, use your favourite plugin manager to install.

NOTE:<br/>
It is recommended not to lazy load this plugin to avoid some strange phenomena.<br/>
The execution of each function in the plugin is very fast and the time consumption can be ignored.

## Usage

Example config

```lua
require("transparent").setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  },
  extra_groups = { -- table/string: additional groups that should be cleared
    -- In particular, when you set it to 'all', that means all available groups

    -- example of akinsho/nvim-bufferline.lua
    "BufferLineTabClose",
    "BufferlineBufferSelected",
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineSeparator",
    "BufferLineIndicatorSelected",
  },
  exclude_groups = {}, -- table: groups you don't want to clear
})
```

---

This plugin will provide a global variable: `g:transparent_enabled`(lua: `vim.g.transparent_enabled`)

Some plugins or themes support setting transparency, and you can use this variable as a flag.<br/>
eg: `vim.g.tokyonight_transparent = vim.g.transparent_enabled`

**NOTE**: The plugin will cache and automatically apply transparency settings, so you only need to call the following command.

## Commands

```
:TransparentEnable
:TransparentDisable
:TransparentToggle
```

## Aknowledgement

[vim-transparent](https://github.com/Kjwon15/vim-transparent)
