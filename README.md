# nvim-transparent

Remove all background colors to make nvim transparent.

---

Just rewrite [vim-transparent](https://github.com/Kjwon15/vim-transparent) in lua.

# Usage

```lua
require("transparent").setup({
	enable = false, -- enable transparent
	extra_groups = {}, -- extra highlight-groups that should remove background color
})
```

you can also set the `groups` option to override the default groups. the default groups:
`Normal` `Comment` `Constant` `Special` `Identifier` `Statement` `PreProc` `Type` `Underlined`
`Todo` `String` `Function` `Conditional` `Repeat` `Operator` `Structure` `LineNr` `NonText` `SignColumn` `CursorLineNr`.

---

global variable `g:transparent_enabled` has greater priority to option `enable`

**disable by default**

```vim
let g:transparent_enabled = 0
```

# Commands

```
:TransparentEnable
:TransparentDisable
:TransparentToggle
```
