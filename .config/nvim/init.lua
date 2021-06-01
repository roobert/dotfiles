-- inspired by github.com/ojroques
--
-- requires:
-- git clone https://github.com/savq/paq-nvim.git \
--    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
-- then run:
-- PaqInstall
-- UpdateRemotePlugin


-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

g['python3_host_prog'] = '/Users/robwilson/.pyenv/versions/3.9.5/bin/python'

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
--paq {'airblade/vim-gitgutter'}
--paq {'airblade/vim-rooter'}
paq {'roobert/robs.vim'}
paq {'junegunn/fzf'}
paq {'junegunn/fzf.vim'}
--paq {'justinmk/vim-dirvish'}
--paq {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}
paq {'machakann/vim-sandwich'}
paq {'neovim/nvim-lspconfig'}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'ojroques/nvim-bufbar'}
paq {'ojroques/nvim-bufdel'}
paq {'ojroques/nvim-hardline'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'ojroques/vim-oscyank'}
paq {'sakhnik/nvim-gdb'}
paq {'savq/paq-nvim', opt = true}
paq {'shougo/deoplete-lsp'}
paq {'shougo/deoplete.nvim'}
paq {'tpope/vim-commentary'}
paq {'tpope/vim-fugitive'}
paq {'tpope/vim-unimpaired'}
paq {'jiangmiao/auto-pairs'}


-------------------- PLUGIN SETUP --------------------------
-- bufbar
require('bufbar').setup {show_bufname = 'visible', show_flags = false}

-- bufdel
require('bufdel').setup {next = 'alternate'}
map('n', '<leader>w', '<cmd>BufDel<CR>')

-- buildme
map('n', '<leader>bb', '<cmd>BuildMe<CR>')
map('n', '<leader>be', '<cmd>BuildMeEdit<CR>')
map('n', '<leader>bs', '<cmd>BuildMeStop<CR>')

-- deoplete
-- if this fails with an error, run: :UpdateRemotePlugin
g['deoplete#enable_at_startup'] = 1
fn['deoplete#custom#option']('ignore_case', true)
fn['deoplete#custom#option']('max_list', 10)

-- dirvish
g['dirvish_mode'] = [[:sort ,^.*[\/],]]

-- fzf
map('n', '<leader>/', '<cmd>BLines<CR>')
map('n', '<leader>f', '<cmd>Files<CR>')
map('n', '<leader>h', '<cmd>History:<CR>')
map('n', '<leader>r', '<cmd>Rg<CR>')

-- open buffer navigation
map('n', 's', '<cmd>Buffers<CR>')

g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}

-- fugitive and git
local log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
map('n', '<leader>g<space>', ':Git ')
map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
map('n', '<leader>gg', '<cmd>Git<CR>')
map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>', log))

-- hardline
require('hardline').setup {}

-- indent-blankline
g['indent_blankline_char'] = '┊'
g['indent_blankline_buftype_exclude'] = {'terminal'}
g['indent_blankline_filetype_exclude'] = {'fugitive', 'fzf', 'help', 'man'}

-- lspfuzzy
require('lspfuzzy').setup {}

-- vim-sandwich
cmd 'runtime macros/sandwich/keymap/surround.vim'

-------------------- OPTIONS -------------------------------
local indent, width = 2, 80

opt.colorcolumn = tostring(width)   -- Line length marker
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options
opt.cursorline = false              -- Highlight cursor line
opt.expandtab = true                -- Use spaces instead of tabs
opt.formatoptions = 'crqnj'         -- Automatic formatting options
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = false                  -- Show line numbers
opt.pastetoggle = '<F2>'            -- Paste mode
opt.relativenumber = false          -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = indent             -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.signcolumn = 'auto'              -- Show sign column
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = indent                -- Number of spaces tabs count for
opt.textwidth = width               -- Maximum width of text
opt.updatetime = 100                -- Delay before swap file is saved
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = true                     -- Disable line wrap
opt.incsearch = true

opt.termguicolors = false
cmd 'colorscheme robs'

-------------------- MAPPINGS ------------------------------
--map('', '<leader>c', '"+y')
--map('i', '<C-u>', '<C-g>u<C-u>')
map('i', '<C-w>', '<C-g>u<C-w>')
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', 'jj', '<ESC>')
map('n', '<C-l>', '<cmd>nohlsearch<CR>')
map('n', '<C-w>T', '<cmd>tabclose<CR>')
map('n', '<C-w>t', '<cmd>tabnew<CR>')
map('n', '<F3>', '<cmd>lua toggle_wrap()<CR>')
map('n', '<F4>', '<cmd>set scrollbind!<CR>')
map('n', '<F5>', '<cmd>checktime<CR>')
map('n', '<S-Down>', '<C-w>2<')
map('n', '<S-Left>', '<C-w>2-')
map('n', '<S-Right>', '<C-w>2+')
map('n', '<S-Up>', '<C-w>2>')

-- block swap
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>')

-- open new terminal in tab
map('n', '<leader>t', '<cmd>terminal<CR>')

map('t', '<ESC>', '&filetype == "fzf" ? "\\<ESC>" : "\\<C-\\>\\<C-n>"' , {expr = true})
map('t', 'jj', '<ESC>', {noremap = false})
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

map('n', 'Q', '<cmd>lua warn_caps()<CR>')
map('n', 'U', '<cmd>lua warn_caps()<CR>')

-------------------- TEXT OBJECTS --------------------------
for _, ch in ipairs({
  '<space>', '!', '#', '$', '%', '&', '*', '+', ',', '-', '.',
  '/', ':', ';', '=', '?', '@', '<bslash>', '^', '_', '~', '<bar>',
}) do
  map('x', fmt('i%s', ch), fmt(':<C-u>normal! T%svt%s<CR>', ch, ch), {silent = true})
  map('o', fmt('i%s', ch), fmt(':<C-u>normal vi%s<CR>', ch), {silent = true})
  map('x', fmt('a%s', ch), fmt(':<C-u>normal! F%svf%s<CR>', ch, ch), {silent = true})
  map('o', fmt('a%s', ch), fmt(':<C-u>normal va%s<CR>', ch), {silent = true})
end

-------------------- LSP -----------------------------------
local lsp = require('lspconfig')
for ls, cfg in pairs({
  bashls = {},
  ccls = {},
  jsonls = {},
  pyls = {root_dir = lsp.util.root_pattern('.git', fn.getcwd())},
}) do lsp[ls].setup(cfg) end

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- TREE-SITTER ---------------------------
-- improved syntax highlighting
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  indent = {enable = true},
}

-- for new terminal tabs
function init_term()
  cmd 'setlocal nonumber norelativenumber'
  cmd 'setlocal nospell'
  cmd 'setlocal signcolumn=auto'
end


function toggle_wrap()
  wo.breakindent = not wo.breakindent
  wo.linebreak = not wo.linebreak
  wo.wrap = not wo.wrap
end

function warn_caps()
  cmd 'echohl WarningMsg'
  cmd 'echo "Caps Lock may be on"'
  cmd 'echohl None'
end

vim.tbl_map(function(c) cmd(fmt('autocmd %s', c)) end, {
  'TermOpen * lua init_term()',
  'TextYankPost * lua vim.highlight.on_yank {timeout = 200}',
  'TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | OSCYankReg + | endif',
})