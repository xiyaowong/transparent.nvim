# transparent.nvim

Remove all background colors to make nvim transparent.

![demo](https://user-images.githubusercontent.com/47070852/226154013-bc0168ba-c914-442e-9132-1e86d1899bc5.gif)

---

## Installation

`xiyaowong/transparent.nvim`

Install it with your favorite plugin manager, like any other plugin.

> [!NOTE]
> Avoid lazy-loading this plugin to ensure the highlight-clearing logic is triggered. The plugin's function runs quickly.

## Usage

All available options:

```lua
 -- Optional, you don't have to run setup.
require("transparent").setup({
  -- table|function: default groups
  groups = {
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  -- table|function: additional groups that should be cleared
  extra_groups = {},
  -- table|function: groups you don't want to clear
  exclude_groups = {},
  -- function: code to be executed after highlight groups are cleared
  -- Also the user event "TransparentClear" will be triggered
  on_clear = function() end,
})
```

Normally, you don't need to call setup. There are two better ways for configuration.

### Dynamic groups

`groups`, `extra_groups` and `exclude_groups` also accept a function. It is called
each time the highlights are cleared, so it can return groups that are only known
at runtime. The function may return `nil` or an empty list, in which case no groups
are added or excluded.

```lua
require("transparent").setup({
  groups = function()
    -- compute groups lazily
    return { "Normal", "NormalNC" }
  end,
  exclude_groups = function()
    return vim.g.transparent_enabled and { "SomeGroup" } or {}
  end,
})
```

### `g:transparent_groups`

Add additional highlight groups by explicitly assigning the variable `g:transparent_groups`.

For example, if you want to add group `ExtraGroup`, you can do it like this:

```lua
vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "ExtraGroup" })
-- vimscript: let g:transparent_groups = extend(get(g:, 'transparent_groups', []), ["ExtraGroup"])
```

**You can execute this statement anywhere and as many times as you want, without worrying about whether the plugin has already been loaded or not.**

Here is an example using [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim).
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

So, this plugin provides a helper function `clear_prefix`. It will clear all highlight groups starting with the prefix.

The prefix can also be a function, which is called each time to compute the prefix.
Returning `nil` means the prefix is skipped:

```lua
require('transparent').clear_prefix(function()
  return 'BufferLine'
end)
```

For some UI plugins, you may want to clear all highlights. At this point you should use `clear_prefix`.

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

This plugin provides a global variable: `g:transparent_enabled` (lua: `vim.g.transparent_enabled`)

Some plugins or themes support setting transparency, and you can use this variable as a flag.<br/>
e.g. `require("tokyonight").setup{ transparent = vim.g.transparent_enabled }`

**NOTE**: The plugin will cache and automatically apply transparency settings, so you only need to call the following commands.

## Commands

```
:TransparentEnable
:TransparentDisable
:TransparentToggle
```

## FAQ

### How to enable transparency for plugin panels?

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

It is not recommended to make floating windows transparent; it will look very odd, and everything will be mixed together.

For more information: https://github.com/xiyaowong/transparent.nvim/issues?q=label%3A%22float+window%22+sort%3Aupdated-desc

## Acknowledgement

[vim-transparent](https://github.com/Kjwon15/vim-transparent)
