"/.vimrc
"
" OSX VIM 8:
" sudo su -
" cd /usr/local/bin
" ln -s python3 python
" brew uninstall vim
" brew cleanup -s
" make sure /usr/local/bin has priority in $PATH
"
" /usr/local/bin/pip3 install isort pynvim
"
" /usr/local/opt/python@3.8//libexec/bin/python -m pip install pynvim

set pyxversion=3
let g:python3_host_prog = '/Volumes/home/rw/.pyenv/shims/python'

for f in argv()
  if isdirectory(f)
    echomsg "vim: cowardly refusing to edit directory: " . f
    quit
  endif
endfor

" backwards compatibility is limiting so turn it off
set nocompatible

" annoyingly, this needs to be set before yankring is installed otherwise
" the yankring_history file is created in ~/
let g:yankring_history_dir = '~/.vim'

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
    \'jamessan/vim-gnupg',
    \'junegunn/vim-easy-align',
    \'jiangmiao/auto-pairs',
    \'briandoll/change-inside-surroundings.vim',
    \'posva/vim-vue',
    \'dense-analysis/ale',
    \'hashivim/vim-terraform',
    \'godlygeek/tabular',
    \'itspriddle/vim-shellcheck',
    \'nvie/vim-flake8',
    \'ap/vim-buftabline',
    \'Shougo/deoplete.nvim',
    \'Shougo/context_filetype.vim',
    \'fisadev/vim-isort',
    \'roxma/nvim-yarp',
    \'deoplete-plugins/deoplete-jedi',
    \'roxma/vim-hug-neovim-rpc',
    \'sheerun/vim-polyglot',
    \'ntpeters/vim-better-whitespace',
    \'fisadev/vim-isort',
    \'roobert/robs.vim'
  \]

    "\'gryf/pylint-vim',
    "\'ycm-core/YouCompleteMe',
    "\'zxqfl/tabnine-vim',
    "\'tpope/vim-commentary',
    "\'tpope/vim-repeat',
    "\'vim-scripts/tlib',
    "\'vim-scripts/nginx.vim',
    "\'vim-scripts/xterm16.vim',
    "\'vim-scripts/gundo',
    "\'vim-scripts/SyntaxAttr.vim',
    "\'vim-scripts/ZoomWin',
    "\'MarcWeber/vim-addon-mw-utils',
    "\'garbas/vim-snipmate',
    "\'honza/vim-snippets',
    "\'puppetlabs/puppet-syntax-vim',
    "\'rodjek/vim-puppet',
    "\'ngmy/vim-rubocop',
    "\'nathanaelkane/vim-indent-guides',
    "\'wellle/targets.vim',
    "\'easymotion/vim-easymotion',
    "\'rhysd/clever-f.vim',
    "\'vim-scripts/ruby-matchit',
    "\'endel/vim-github-colorscheme',
    "\'ntpeters/vim-better-whitespace',

  if filereadable('/usr/bin/go') || filereadable('/usr/local/go/bin/go') || filereadable('/home/rw/opt/go/bin/go') || filereadable('/home/rw/git/go/bin/go')
    call add(plugins, 'fatih/vim-go')
    " go get golang.org/x/tools/cmd/goimports
    let g:go_fmt_command = "/home/rw/go/bin/goimports"
  endif

  let new_plugins = 1

  call plug#begin('~/.vim/plugged')

  "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

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

  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_autoclose_preview_window_after_completion = 1

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

let g:current_line_whitespace_disabled_hard=1

let g:deoplete#enable_at_startup = 1

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
"let g:syntastic_python_checkers = ['python', 'pyflakes', 'pep8', 'pylint']
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

nnoremap <silent> <Plug>LocationPrevious    :<C-u>exe 'call <SID>LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext        :<C-u>exe 'call <SID>LocationNext()'<CR>
"nmap <silent> ,,    <Plug>LocationPrevious
"nmap <silent> ..    <Plug>LocationNext

function! ToggleErrors()
  let old_last_winnr = winnr('$')
  lclose

  " Nothing was closed, open syntastic error location panel
  if old_last_winnr == winnr('$')
    Errors
  endif
endfunction

nmap <Leader>e :<C-u>call ToggleErrors()<CR>

" toggle yankring
nnoremap <Leader>p :YRShow<CR>

" make it colourful..

" For windows, the colors directory is: c:\Users\<user>\vimfiles\colors

" dont set TERM=xterm-256color since this will break the terminal when
" connecting to
" other systems, instead add an entry to .bashrc:
" alias vi="vim -T xterm-256color"

" xterm16 color scheme settings
"let xterm16_colormap   = 'allblue'
"let xterm16_brightness = 'default'
"colorscheme xterm16

set rtp+=~/.vim/plugged/robs.vim/output/vim
set background=dark
"let base16colorspace=256
"let g:base16_shell_path='~/.vim/plugged/robs.vim/output/shell/'
"colorscheme base16-robs
colorscheme robs


" molokai 256 colour
"let g:rehash256 = 1

"colorscheme molokai
"colorscheme apprentice
"colorscheme iceberg

" this allows 256 colours in non xterm-256 terminals that support 256
let &t_Co=256

syntax enable

" FIXME: coloured background breaks copy and paste (make sure this is after 'syntax enable')
hi Normal ctermfg=252 ctermbg=none

highlight User1 ctermfg=red
highlight User2 ctermfg=blue

function! StatusLine()
  let padded_line_no = "%=%0".len(line("$"))."l"
  " FIXME
  return "%=____ ___  __ _   _     %{expand('%:p:h')}/%1*%t%*\ \-\ " . padded_line_no . "/%L\ %03c\ "
endfunction

set laststatus=2
set statusline=%!StatusLine()

" leader
"let mapleader = "\<Space>"

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
set esckeys         " cursor keys in insert mode
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
" zsh style tab completion for
set wildmenu
set wildmode=full

" get rid of ugly vertical split char | for split windows, note the space after \
"set fillchars+=vert:\ ,stlnc:─,stl:─
set fillchars+=vert:\ ,stlnc:_,stl:_

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
autocmd Syntax * syn match ExtraWhitespace /[^\t]\zs\t\+/

"disable autocomment stuff
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" commentary settings..
autocmd FileType apache set commentstring=#\ %s
autocmd FileType sh     set commentstring=#\ %s
autocmd FileType zsh    set commentstring=#\ %s
autocmd FileType ruby   set commentstring=#\ %s

" highlight text after 80th column, maybe make this toggleable?
"highlight OverLength ctermbg=red guibg=#FFD9D9
"match OverLength /\%81v.*/

" disable help since sometimes i accidently hit it when aiming for Esc.
nmap <F1> <nop>

" Tabularize plugin bindings
"nmap <Leader>> :Ta /=><CR>
"vmap <Leader>> :Ta /=><CR>
"nmap <Leader>. :Ta /=><CR>
"vmap <Leader>. :Ta /=><CR>
"nmap <Leader>= :Ta /=<CR>
"vmap <Leader>= :Ta /=<CR>
""nmap <Leader>p :Ta /\s"[^ ]*"/<CR>
""vmap <Leader>p :Ta /\s"[^ ]*"/<CR>

" vim easy align
" start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" Default fzf layout
"let g:fzf_layout = { 'down': '40%' }
"map <C-F> :FZF<CR>

" change surround bindings
"nmap <Leader>' 

" run shortcuts..
"nmap <Leader>r :!!<CR>
"vmap <Leader>r :!!<CR>
"nmap <Leader>R :!./%<CR>
"vmap <Leader>R :!./%<CR>
"nmap <Leader>x :!chmod +x ./%<CR>
"vmap <Leader>x :!chmod +x ./%<CR>
"nmap <Leader>X :!chmod +x ./%<CR>
"vmap <Leader>X :!chmod +x ./%<CR>

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
autocmd BufNewFile *.py 0put = '#!/usr/bin/env python'                    | normal G
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

" remap leader-ru to leader-r
"let g:vimrubocop_keymap = 0
"nmap <Leader>r :RuboCop<CR>

nnoremap <silent> <F4> :call <SID>SearchMode()<CR>
function s:SearchMode()
  if !exists('s:searchmode') || s:searchmode == 0
    echo 'Search next: scroll hit to middle if not on same page'
    nnoremap <silent> n n:call <SID>MaybeMiddle()<CR>
    nnoremap <silent> N N:call <SID>MaybeMiddle()<CR>
    let s:searchmode = 1
  elseif s:searchmode == 1
    echo 'Search next: scroll hit to middle'
    nnoremap n nzz
    nnoremap N Nzz
    let s:searchmode = 2
  else
    echo 'Search next: normal'
    nunmap n
    nunmap N
    let s:searchmode = 0
  endif
endfunction

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

" easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap s <Plug>(easymotion-s2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" show syntax highlighting information about attribute under cursor
map -c :call SyntaxAttr()<CR>

map <Leader>v :r !xsel -p<CR>


call deoplete#custom#option('num_processes', 1)


