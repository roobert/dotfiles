".vimrc

" For windows, the colors directory is: c:\Users\<user>\vimfiles\colors 

" dont set TERM=xterm-256color since this will break the terminal when
" connecting to
" other systems, instead add an entry to .bashrc:
" alias vi="vim -T xterm-256color"

" xterm16 color scheme settings

" Select colormap: 'soft', 'softlight', 'standard' or 'allblue'
"let xterm16_colormap    = 'soft'
"let xterm16_colormap    = 'softlight'
"let xterm16_colormap    = 'standard'
""let xterm16_colormap    = 'allblue'

" Select brightness: 'low', 'med', 'high', 'default' or custom levels.
"let xterm16_brightness  = 'low'
"let xterm16_brightness  = 'med'
"let xterm16_brightness  = 'high'
""let xterm16_brightness  = 'default'

""colorscheme xterm16

" this allows 256 colours in non xterm-256 terminals that support 256
" colours (testing)
let &t_Co=256

" Solarized settings
colorscheme solarized
set background=dark
let g:solarized_termcolors = 256
let g:solarized_underline = 0
let g:solarized_contrast = "high"

" colorscheme jellybeans

" syntax isn't always enabled by default
syntax enable


" settings
"set cursorline      " highlight line that cursor is on
set tabstop=4
set shiftwidth=4
set softtabstop=4   " work uses 'spaces' not tabs
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
"setl foldmethod=indent

" highlight text after 80th column
"highlight OverLength ctermbg=red guibg=#FFD9D9
"match OverLength /\%81v.*/

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
autocmd Syntax * syn match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
"autocmd Syntax * syn match ExtraWhitespace /^\t*\zs \+/<<

"disable autocomment stuff
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Tab navigation
map <C-l> :tabnext<CR>
map <C-h> :tabprev<CR>

" Tabularize plugin bindings
nmap <C-a>p :Ta /=><CR>
vmap <C-a>p :Ta /=><CR>
map <C-a>e :Ta /=<CR>
vmap <C-a>e :Ta /=<CR>

" write file using sudo don't prompt to re-open file
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command WQ :execute ':silent w !sudo tee % > /dev/null' | :quit!
command Wq WQ

" include _ as a word boundary
set iskeyword-=_

" expert difficulty
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>
