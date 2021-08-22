# nvim-transparent

Remove all background colors to make nvim transparent.

![screenshot](https://user-images.githubusercontent.com/47070852/124546661-9353ce80-de5d-11eb-81ba-f8282e034d9f.gif)

---

## Usage

example config

```lua
require("transparent").setup({
  enable = true, -- boolean: enable transparent
  extra_groups = { -- table/string: additional groups that should be clear
    -- In particular, when you set it to 'all', that means all avaliable groups

    -- example of akinsho/nvim-bufferline.lua
    "BufferLineTabClose",
    "BufferlineBufferSelected",
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineSeparator",
    "BufferLineIndicatorSelected",
  },
  exclude = {}, -- table: groups you don't want to clear
})
```

you can also set the `groups` option to override the default groups. the default groups:
`Normal` `Comment` `Constant` `Special` `Identifier` `Statement` `PreProc` `Type` `Underlined`
`Todo` `String` `Function` `Conditional` `Repeat` `Operator` `Structure` `LineNr` `NonText` `SignColumn` `CursorLineNr`.

---

global variable `g:transparent_enabled` has greater priority to option `enable`

**disable by default**

```vim
let g:transparent_enabled = v:false
```

## Commands

```
:TransparentEnable
:TransparentDisable
:TransparentToggle
```

## Aknowledgement

[vim-transparent](https://github.com/Kjwon15/vim-transparent)
