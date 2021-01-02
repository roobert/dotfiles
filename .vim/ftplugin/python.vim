setlocal autoread

autocmd BufWritePost *.py call flake8#Flake8()
let g:flake8_show_quickfix=0

silent let s:black_command = substitute(system('which black'), '\n\+$', '', '')
silent let g:black_virtualenv = substitute(system('poetry env info -p'), '\n\+$', '', '')

autocmd! BufWritePre <buffer> call s:PythonAutoformat()

function s:PythonAutoformat() abort
    let cursor_pos = getpos('.')
    execute ':%!black -q - 2> /dev/null'
    execute ':%!isort -q - 2> /dev/null'
    call cursor(cursor_pos[1], cursor_pos[2])
endfunction

" mainly for the benefit of pythons black:
" https://black.readthedocs.io/en/stable/the_black_code_style.html#line-length
set colorcolumn=88
set textwidth=88
