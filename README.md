# nvim-transparent

Remove all background colors to make nvim transparent.

![screenshot](https://user-images.githubusercontent.com/47070852/124546661-9353ce80-de5d-11eb-81ba-f8282e034d9f.gif)

---

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

Some plugins or themes support setting transparency, and you can use this
variable as a flag. eg: `vim.g.tokyonight_transparent = vim.g.transparent_enabled`

**NOTE**: The plugin will cache and automatically apply transparency settings, so you only need to call the following command.

## Commands

```
:TransparentEnable
:TransparentDisable
:TransparentToggle
```

## Aknowledgement

[vim-transparent](https://github.com/Kjwon15/vim-transparent)
