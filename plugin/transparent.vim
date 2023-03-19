if exists('g:loaded_transparent') | finish | endif

let g:loaded_transparent = 1

augroup transparent
    autocmd!
    autocmd VimEnter,ColorScheme * lua require('transparent').clear()
    command -bar -nargs=0 TransparentEnable  lua require('transparent').toggle(true)
    command -bar -nargs=0 TransparentDisable lua require('transparent').toggle(false)
    command -bar -nargs=0 TransparentToggle  lua require('transparent').toggle()
augroup END
