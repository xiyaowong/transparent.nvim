if exists('g:loaded_transparent') | finish | endif

if !has('nvim')
    echohl Error
    echom "Sorry this plugin only works with versions of neovim that support lua"
    echohl clear
    finish
endif

let g:loaded_transparent = 1

augroup transparent
    autocmd!
    autocmd VimEnter,ColorScheme * lua require('transparent').clear_bg()
    command -bar -nargs=0 TransparentEnable lua require('transparent').enable_transparent()
    command -bar -nargs=0 TransparentDisable lua require('transparent').disable_transparent()
    command -bar -nargs=0 TransparentToggle lua require('transparent').toggle_transparent()
augroup END
