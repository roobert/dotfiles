"/.vimrc
"
" intall dependencies:
" > pip install isort pynvim jedi
"

set pyxversion=3

" this seems to get ignored.. try finding bin/python under /usr
" and randomly installing depends with .../bin/python -m pip install ...
" because computers
if filereadable('/Users/rw/.pyenv/shims/python')
  let g:python3_host_prog = '/Users/rw/.pyenv/shims/python'
endif

for f in argv()
  if isdirectory(f)
    echomsg "vim: cowardly refusing to edit directory: " . f
    quit
  endif
endfor

" backwards compatibility is limiting so turn it off
set nocompatible

if !filewritable(expand('~/.viminfo'))
  echo "~/.viminfo is not writable!"
endif

if version > 701
  " inspired by: http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
  if has('vim_starting')
    if !filereadable(expand('~/.vim/plugged/vim-plug/README.md'))
      echo "Installing vim-plug.."

      silent !mkdir -p ~/.vim/plugged
      silent !GIT_SSL_NO_VERIFY=1 git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug
    endif
  endif

  let g:plug_window = 'new'

  set runtimepath+=~/.vim/plugged/vim-plug
  source ~/.vim/plugged/vim-plug/plug.vim

  let g:terraform_align=1
  let g:terraform_fmt_on_save=1

  let plugins = [
    \'junegunn/vim-plug',
    \'tpope/vim-surround',
    \'tpope/vim-unimpaired',
    \'vim-scripts/YankRing.vim',
    \'junegunn/vim-easy-align',
    \'jiangmiao/auto-pairs',
    \'briandoll/change-inside-surroundings.vim',
    \'posva/vim-vue',
    \'dense-analysis/ale',
    \'hashivim/vim-terraform',
    \'vim-syntastic/syntastic',
    \'preservim/nerdcommenter',
    \'godlygeek/tabular',
    \'itspriddle/vim-shellcheck',
    \'nvie/vim-flake8',
    \'ap/vim-buftabline',
    \'Shougo/deoplete.nvim',
    \'Shougo/context_filetype.vim',
    \'fisadev/vim-isort',
    \'roxma/nvim-yarp',
    \'roxma/vim-hug-neovim-rpc',
    \'deoplete-plugins/deoplete-jedi',
    \'sheerun/vim-polyglot',
    \'ntpeters/vim-better-whitespace',
    \'fisadev/vim-isort',
    \'roobert/robs.vim'
  \]

  if filereadable('/usr/bin/go') || filereadable('/usr/local/go/bin/go') || filereadable('/home/rw/opt/go/bin/go') || filereadable('/home/rw/git/go/bin/go')
    call add(plugins, 'fatih/vim-go')
    " NOTE: go get golang.org/x/tools/cmd/goimports
    let g:go_fmt_command = "/home/rw/go/bin/goimports"
  endif

  let new_plugins = 1

  call plug#begin('~/.vim/plugged')

  " if a plugin isn't installed, install it!
  for plugin in plugins
    let plugin_name = split(plugin, '/')[1]
    let plugin_dir  = expand('~') . '/.vim/plugged/' . plugin_name

    " if possible plugin directories aren't found...
    if !isdirectory(plugin_dir)
      let new_plugins = 0
    endif

    " register all plugin paths, even those not installed
    Plug plugin
  endfor

  call plug#end()

  if new_plugins == 0
    silent PlugInstall

    " close install buffer
    bdelete
  endif
endif

if !has('nvim')
	pythonx import pynvim
endif

let g:syntastic_terraform_tffilter_plan = 0
let g:terraform_completion_keys = 1
let g:terraform_registry_module_completion = 0

let g:current_line_whitespace_disabled_hard=1
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'

call deoplete#initialize()

inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")

set completeopt-=preview

" use <tab> / <s-tab> to cycle through completions
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()

inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

filetype plugin indent on

" indent colours
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size  = 2
let g:indent_guides_enable_on_vim_startup = 1

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1
"autocmd BufWritePost * :Errors

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_ruby_checkers = [ 'mri', 'rubocop' ]

function! <SID>LocationPrevious()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfunction

function! <SID>LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfunction

function! ToggleErrors()
  let old_last_winnr = winnr('$')
  lclose

  " Nothing was closed, open syntastic error location panel
  if old_last_winnr == winnr('$')
    Errors
  endif
endfunction

nnoremap <silent> <Plug>LocationPrevious    :<C-u>exe 'call <SID>LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext        :<C-u>exe 'call <SID>LocationNext()'<CR>
nmap <silent><leader>[ <Plug>LocationPrevious
nmap <silent><leader>] <Plug>LocationNext
nmap <Leader>e :<C-u>call ToggleErrors()<CR>

" annoyingly, this needs to be set before yankring is installed otherwise
" the yankring_history file is created in ~/
let g:yankring_history_dir = '~/.vim'

" toggle yankring
nnoremap <Leader>p :YRShow<CR>

set rtp+=~/.vim/plugged/robs.vim/output/vim
set background=dark
colorscheme robs

" this allows 256 colours in non xterm-256 terminals that support 256
let &t_Co=256

syntax enable

" FIXME: coloured background breaks copy and paste (make sure this is after 'syntax enable')
hi Normal ctermfg=252 ctermbg=none

highlight User1 ctermfg=red
highlight User2 ctermfg=blue

function!StatusLine()
  let padded_line_no = "%=%0".len(line("$"))."l"
  " FIXME
  return "%=_______________________________________________________________________________________ ___  __ _   _     %{expand('%:p:h')}/%1*%t%*\ \-\ " . padded_line_no . "/%L\ %03c\ "
endfunction

set laststatus=2
set statusline=%!StatusLine()

" me settins
set showcmd
set matchpairs+=<:>,{:},(:),[:]
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab       " make tabs spaces
set showmatch       " show matching brackets
set noautoindent
set nocindent
set hls             " highlight search
set incsearch
set nonumber        " display line numbers
set wrap
set guioptions=-MtR " disable menus, tabs and scrollbars in gvim
set hidden          " make buffers hidden by default
set iskeyword-=_
set tabpagemax=999  " by default this is 10 and has bitten me hard!
set splitright      " when splitting the buffer, create new buffer on right
set t_ut=           " make tmux/screen display properly for vim themes with coloured backgrounds
set ignorecase      " ignore case when searching
set smartcase       " ignore case if search pattern is lowercase
set nrformats=      " treat numbers as decimal when using <C-a> and <C-x>
set wildmenu
set wildmode=full

" get rid of ugly vertical split char | for split windows, note the space after \
"set fillchars+=vert:\ ,stlnc:─,stl:─
set fillchars+=vert:\ ,stlnc:_,stl:_

" disable help since sometimes i accidently hit it when aiming for Esc.
nmap <F1> <nop>

" vim easy align
" start interactive EasyAlign in visual mode (e.g. <visual select><Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" write file using sudo don't prompt to re-open file
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command WQ :execute ':silent w !sudo tee % > /dev/null' | :quit!

" laziness
command Wq WQ
command Q q

" Entering Ex mode.  Type "visual" to go to Normal mode?
" NO. THANK. YOU.
map Q <Nop>

autocmd BufNewFile *.rb 0put = '#!/usr/bin/env ruby'                      | normal G
autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G
autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\n\n\ndef main():\n    pass\n\n\nif __name__ == \\"__main__\\":\n    main()\" | normal G
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" spellcheck for .txt and .md
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell

" expert difficulty!!!
noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

" toggle paste mode (!)
set pastetoggle=<Leader>p

" window / buffer stuff
set splitbelow
set splitright
" window move
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" window create
nmap <C-W><J> :topleft  vnew<CR>
nmap <C-W><K> :botright vnew<CR>
nmap <C-W><H> :topleft  new<CR>
nmap <C-W><L> :botright new<CR>
" buffer create
nmap <C-B><H> :leftabove  vnew<CR>
nmap <C-B><L> :rightbelow vnew<CR>
nmap <C-B><J> :leftabove  new<CR>
nmap <C-B><K> :rightbelow new<CR>

"ctrl + w _ "Max out the height of the current split
"ctrl + w | "Max out the width of the current split
"ctrl + w = "Normalize all split sizes, which is very handy when resizing terminal

" tab navigation
map <S-h> :tabprev<CR>
map <S-l> :tabnext<CR>

set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" un-highlight last search
map <Leader>/ :noh<CR>

" tmux
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

" If cursor is in first or last line of window, scroll to middle line.
function s:MaybeMiddle()
  if winline() == 1 || winline() == winheight(0)
    normal! zz
  endif
endfunction

" open help in a new tab
augroup HelpInTabs
  autocmd!
  autocmd BufEnter *.txt call HelpInNewTab()
augroup END

function! HelpInNewTab ()
  if &buftype == 'help'
    "Convert the help window to a tab...
    execute "normal \<C-W>T"
  endif
endfunction

let g:netrw_liststyle=3

" smart f
let g:clever_f_smart_case=1
let g:clever_f_chars_match_any_signs=';'

" show syntax highlighting information about attribute under cursor
map -c :call SyntaxAttr()<CR>

" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#documentation_command = "D"

let g:NERDSpaceDelims = 0
let g:NERDCompactSexyComs = 0
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 0
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

nmap <Leader>\ <Plug>NERDCommenterToggle
vmap <Leader>\ <Plug>NERDCommenterToggle<CR>gv

call deoplete#custom#option('num_processes', 1)

set colorcolumn=80
set textwidth=80
highlight ColorColumn ctermbg=black guibg=black
