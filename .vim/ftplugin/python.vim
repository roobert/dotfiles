setlocal autoread

autocmd BufWritePost *.py call flake8#Flake8()
let g:flake8_show_quickfix=0

silent let g:black_virtualenv = substitute(system('poetry env info -p'), '\n\+$', '', '')
silent let s:black_command = substitute(system('which black'), '\n\+$', '', '')

if g:black_virtualenv == ""
    echom 'Skipping black formatting, unable to find virtualenv'
elseif s:black_command == "black not found"
    echom 'Skipping black formatting, unable to find black command'
else
    autocmd! BufWritePre <buffer> call s:PythonAutoformat()
endif

function s:PythonAutoformat() abort
    let cursor_pos = getpos('.')
    execute ':%!black -q - 2>/dev/null'
    execute ':%!isort - 2>/dev/null'
    call cursor(cursor_pos[1], cursor_pos[2])
endfunction
