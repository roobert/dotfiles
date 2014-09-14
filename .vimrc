".vimrc

" backwards compatibility is limiting so turn it off
set nocompatible

" annoyingly, this needs to be set before yankring is installed otherwise
" the yankring_history file is created in ~/
let g:yankring_history_dir = '~/.vim'

if !filewritable(expand('~/.viminfo'))
  echo "~/.viminfo is not writable!"
endif

if version > 701

  syntax off

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

  let plugins = [
    \'vim-scripts/xterm16.vim',
    \'MarcWeber/vim-addon-mw-utils',
    \'tomtom/tlib_vim',
    \'garbas/vim-snipmate',
    \'honza/vim-snippets',
    \'tpope/vim-surround',
    \'tpope/vim-commentary',
    \'tpope/vim-repeat',
    \'puppetlabs/puppet-syntax-vim',
    \'rodjek/vim-puppet',
    \'scrooloose/syntastic',
    \'vim-scripts/YankRing.vim',
    \'jiangmiao/auto-pairs',
    \'ngmy/vim-rubocop',
    \'tpope/vim-unimpaired',
    \'nathanaelkane/vim-indent-guides',
    \'vim-scripts/nginx.vim',
    \'junegunn/vim-easy-align'
  \]

  "\'godlygeek/tabular',

  if filereadable('/usr/bin/go')
    call add(plugins, 'fatih/vim-go')
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
    bdelete
  endif
endif

filetype plugin indent on

" remap \ (set this first since it affects plugin preferences)
"let mapleader = ","

" indent colours
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size  = 1
let g:indent_guides_enable_on_vim_startup = 1

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1
"autocmd BufWritePost * :Errors

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

let g:syntastic_ruby_checkers = [ 'mri', 'rubocop' ]

" molokai 256 colour
"let g:rehash256 = 1

" make it colourful..

" For windows, the colors directory is: c:\Users\<user>\vimfiles\colors 

" dont set TERM=xterm-256color since this will break the terminal when
" connecting to
" other systems, instead add an entry to .bashrc:
" alias vi="vim -T xterm-256color"

" xterm16 color scheme settings
let xterm16_colormap   = 'allblue'
let xterm16_brightness = 'default'
colorscheme xterm16

" hmm.. prefer this more colourful scheme for now..
"colorscheme molokai
"colorscheme apprentice
"colorscheme iceberg

" this allows 256 colours in non xterm-256 terminals that support 256
let &t_Co=256

syntax enable

" FIXME: coloured background breaks copy and paste (make sure this is after 'syntax enable')
hi Normal ctermfg=252 ctermbg=none

" me settins
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
set fillchars+=vert:\ 

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


" change surround bindings
"nmap <Leader>' 

" run shortcuts..
nmap <Leader>r :!!<CR>
vmap <Leader>r :!!<CR>
nmap <Leader>R :!./%<CR>
vmap <Leader>R :!./%<CR>
nmap <Leader>x :!chmod +x ./%<CR>
vmap <Leader>x :!chmod +x ./%<CR>
nmap <Leader>X :!chmod +x ./%<CR>
vmap <Leader>X :!chmod +x ./%<CR>

" write file using sudo don't prompt to re-open file
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command WQ :execute ':silent w !sudo tee % > /dev/null' | :quit!

" laziness
command Wq WQ
command Q q

" Entering Ex mode.  Type "visual" to go to Normal mode?
" NO. THANK. YOU.
map Q <Nop>

autocmd BufNewFile *.rb 0put = \"#!/usr/bin/env ruby\n#encoding=utf-8\n\n\"   | normal G
autocmd BufNewFile *.sh 0put = '#!/usr/bin/env bash'   | normal G
autocmd BufNewFile *.py 0put = '#!/usr/bin/env python' | normal G
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" spellcheck for .txt and .md
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell


" expert difficulty!!!
noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

" override default vertical split binding to open a new buffer rather than split current buffer
map <C-W>v :vnew<CR>
map <C-w><C-v> :vnew<CR>

" make navigating with ctrl- arrow keys less painful by making it so you dont have to let go of ctrl-w
map <C-w><C-Up>    <C-w><Up>
map <C-w><C-Down>  <C-w><Down>
map <C-w><C-Left>  <C-w><Left>
map <C-w><C-Right> <C-w><Right>

" not os-x workstation friendly..
map <C-Up>    <C-w><Up>
map <C-Down>  <C-w><Down>
map <C-Left>  <C-w><Left>
map <C-Right> <C-w><Right>

" tab navigation
map <S-h> :tabprev<CR>
map <S-l> :tabnext<CR>

" un-highlight last search
map <Leader>/ :noh<CR>

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

