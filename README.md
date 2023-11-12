# transparent.nvim

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

All available options:

```lua
require("transparent").setup({ -- Optional, you don't have to run setup.
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {}, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})
```

Normally, you don't need to call setup. There are two better ways for configuration.

### `g:transparent_groups`

Add additional highlight groups by explicitly assigning the variable `g:transparent_groups`.

For example, if you want to add group `ExtraGroup`, you can do it like this:

```lua
vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "ExtraGroup" })
-- vimscript: let g:transparent_groups = extend(get(g:, 'transparent_groups', []), ["ExtraGroup"])
```

**You can execute this statement anywhere and as many times as you want, without worrying about whether the plugin has already been loaded or not.**

Here is an example about [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim).
Simply copy it and paste it after initializing bufferline in your configuration.

```lua
vim.g.transparent_groups = vim.list_extend(
  vim.g.transparent_groups or {},
  vim.tbl_map(function(v)
    return v.hl_group
  end, vim.tbl_values(require('bufferline.config').highlights))
)
```

### `clear_prefix`

Some plugins define highlights dynamically, especially the highlights of icons. e.g. BufferLineDevIcon*, lualine\_*\_DevIcon\*.

So, this plugin provide a helper function `clear_prefix`. It will clear all highlight groups starting with the prefix.

For some plugins of ui, you would like to clear all highlights. At this point you should use `clear_prefix`.

e.g.

- `akinsho/bufferline.nvim`

```lua
require('transparent').clear_prefix('BufferLine')
```

- `nvim-neo-tree/neo-tree.nvim`

```lua
require('transparent').clear_prefix('NeoTree')
```

- `nvim-lualine/lualine.nvim`

```lua
require('transparent').clear_prefix('lualine')
```

---

This plugin will provide a global variable: `g:transparent_enabled`(lua: `vim.g.transparent_enabled`)

Some plugins or themes support setting transparency, and you can use this variable as a flag.<br/>
eg: `require("tokyonight").setup{ transparent = vim.g.transparent_enabled }`

**NOTE**: The plugin will cache and automatically apply transparency settings, so you only need to call the following command.

## FAQ

### How to enable transparent for plugin panels?

You can try adding this highlight group to the options:

```lua
{
  extra_groups = {
    "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
    "NvimTreeNormal" -- NvimTree
  },
}
```

### Floating windows?

It is not recommended to set the floating window to be transparent, it will become very weird, and everything will be mixed together.

For more information: https://github.com/xiyaowong/transparent.nvim/issues?q=label%3A%22float+window%22+sort%3Aupdated-desc

## Commands

```
:TransparentEnable
:TransparentDisable
:TransparentToggle
```

## Migration Guide 2023/3/20

1. remove `enable=true` in your config.

2. start Neovim

3. Run `:TransparentEnable`

It's done, the status of `enable` will cached and the transparent effect is applyed on you neovim, enjoy :)

## Aknowledgement

[vim-transparent](https://github.com/Kjwon15/vim-transparent)
