setlocal autoread

let b:ale_linters = ['flake8']
let b:ale_fixers = ['black', 'isort']
let g:ale_python_flake8_options = '--max-line-length=88'

set colorcolumn=88
set textwidth=88
