".vimrc

" backwards compatibility is limiting so turn it off
set nocompatible

if version > 701

  " install neobundle stuff!
  " stolen from:
  " https://github.com/matthewfranglen/dotfiles/blob/master/vim/vimrc 
  " inspired by: http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
  if has('vim_starting')
      if !filereadable(expand('~/.vim/bundle/neobundle.vim/README.md'))
          echo "Installing NeoBundle.."
          echo ""
          silent !mkdir -p ~/.vim/bundle
          silent !GIT_SSL_NO_VERIFY=1 git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
      endif

      set runtimepath+=~/.vim/bundle/neobundle.vim/
  endif
  call neobundle#rc(expand('~/.vim/bundle/'))

  NeoBundleFetch 'Shougo/neobundle.vim'
  NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin'  : 'make -f make_cygwin.mak',
    \     'mac'     : 'make -f make_mac.mak',
    \     'unix'    : 'make -f make_unix.mak',
    \     },
    \ }

  " me plugins!
  NeoBundle "tomasr/molokai"
  NeoBundle "MarcWeber/vim-addon-mw-utils"
  NeoBundle "tomtom/tlib_vim"
  NeoBundle "garbas/vim-snipmate"
  NeoBundle "honza/vim-snippets"
  NeoBundle "tpope/vim-surround"
  NeoBundle "godlygeek/tabular"
  NeoBundle "puppetlabs/puppet-syntax-vim"
  NeoBundle "rodjek/vim-puppet"
  NeoBundle "scrooloose/syntastic"
  NeoBundle "vim-scripts/YankRing.vim"
  NeoBundle "jiangmiao/auto-pairs"

  NeoBundleCheck
endif

" ctrl-p preferences
let g:ctrlp_working_path_mode = 'c'

" yank ring
nnoremap <silent> <Leader>p :YRShow<CR>
let g:yankring_history_dir = '~/.vim'

" make it colourful..

" For windows, the colors directory is: c:\Users\<user>\vimfiles\colors 

" dont set TERM=xterm-256color since this will break the terminal when
" connecting to
" other systems, instead add an entry to .bashrc:
" alias vi="vim -T xterm-256color"

" xterm16 color scheme settings
"let xterm16_colormap    = 'allblue'
"let xterm16_brightness  = 'default'
""colorscheme xterm16

" hmm.. prefer this more colourful scheme for now..
colorscheme molokai

" this allows 256 colours in non xterm-256 terminals that support 256
let &t_Co=256

" remap \
let mapleader = ","

syntax enable

" me settins
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab       " make tabs spaces
set showmatch       " show matching brackets
set noautoindent
set nocindent
set esckeys         " cursor keys in insert mode
set hls             " highlight search
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

" get rid of ugly vertical split char | for split windows, note the space after \
set fillchars+=vert:\ 

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
autocmd Syntax * syn match ExtraWhitespace /[^\t]\zs\t\+/

"disable autocomment stuff
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" highlight text after 80th column, maybe make this toggleable?
"highlight OverLength ctermbg=red guibg=#FFD9D9
"match OverLength /\%81v.*/

" disable help since sometimes i accidently hit it when aiming for Esc.
nmap <F1> <nop>

" Tabularize plugin bindings
nmap <Leader>> :Ta /=><CR>
vmap <Leader>> :Ta /=><CR>
nmap <Leader>. :Ta /=><CR>
vmap <Leader>. :Ta /=><CR>
nmap <Leader>= :Ta /=<CR>
vmap <Leader>= :Ta /=<CR>
nmap <Leader>e :Ta /=<CR>
vmap <Leader>e :Ta /=<CR>
nmap <Leader>p :Ta /\s"[^ ]*"/<CR>
vmap <Leader>p :Ta /\s"[^ ]*"/<CR>

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

autocmd BufNewFile *.rb 0put = '#!/usr/bin/env ruby'   | normal G
autocmd BufNewFile *.sh 0put = '#!/usr/bin/env bash'   | normal G
autocmd BufNewFile *.py 0put = '#!/usr/bin/env python' | normal G

" expert difficulty!!!
"noiemap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>

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

