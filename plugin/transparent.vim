if exists('g:loaded_transparent') | finish | endif

let g:loaded_transparent = 1

augroup transparent
    autocmd!
    autocmd VimEnter,ColorScheme * lua require('transparent').clear_bg()
    command -bar -nargs=0 TransparentEnable lua require('transparent').toggle_transparent(true)
    command -bar -nargs=0 TransparentDisable lua require('transparent').toggle_transparent(false)
    command -bar -nargs=0 TransparentToggle lua require('transparent').toggle_transparent()
augroup END
