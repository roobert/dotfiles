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

colorscheme molokai

" this allows 256 colours in non xterm-256 terminals that support 256
" colours (testing)
let &t_Co=256

" syntax isn't always enabled by default
syntax enable

" settings
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
"set cursorline      " highlight line that cursor is on

" highlight text after 80th column
"highlight OverLength ctermbg=red guibg=#FFD9D9
"match OverLength /\%81v.*/

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
autocmd Syntax * syn match ExtraWhitespace /[^\t]\zs\t\+/

"disable autocomment stuff
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Tab navigation
map <C-l> :tabnext<CR>
map <C-h> :tabprev<CR>

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
command Wq WQ
command Q q

" Entering Ex mode.  Type "visual" to go to Normal mode?
" NO. THANK. YOU.
map Q <Nop>

autocmd BufNewFile *.rb 0put = '#!/usr/bin/env ruby'   | normal G
autocmd BufNewFile *.sh 0put = '#!/usr/bin/env bash'   | normal G
autocmd BufNewFile *.py 0put = '#!/usr/bin/env python' | normal G

" plugins
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/vim-surround
let g:ctrlp_working_path_mode = 'c'

" expert difficulty
"noiemap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>
