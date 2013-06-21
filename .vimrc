".vimrc

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

syntax enable

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

" get rid of ugly vertical split char |, note the space after \
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

" Tabularize plugin bindings
nmap <Leader>p :Ta /=><CR>
vmap <Leader>p :Ta /=><CR>
nmap <Leader>e :Ta /=<CR>
vmap <Leader>e :Ta /=<CR>

nmap <Leader>r :!!<CR>
vmap <Leader>r :!!<CR>

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
map <C-Up>    <C-w><Up>
map <C-Down>  <C-w><Down>
map <C-Left>  <C-w><Left>
map <C-Right> <C-w><Right>

map <C-l> :tabnext<CR>
map <C-h> :tabprev<CR>

map <C-l> :tabnext<CR>
map <C-h> :tabprev<CR>

" un-highlight last search
map <Leader>/ :noh<CR>

" plugins
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/vim-surround
let g:ctrlp_working_path_mode = 'c'

