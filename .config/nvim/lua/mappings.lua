-- FIXME: DRY this up
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set leader as spacebar
api.nvim_set_keymap('n', '<space>', '<NOP>',
  { noremap = true, silent = true }
)
g.mapleader = " "

-- FIXME: make this available via a popup
--
-- window management:
-- * :sf = split find open file
-- * :vert sf = vertical split find open file..
-- * window only? maximise current window
-- * vimgrep to search across buffers and add to quickfix
--
-- surround:
-- * ys prefix mnemomic: you surround
-- * cst" can change an html tag
-- * cs"' (or whatever) changes quotes and parens
-- * cs) include space around word
-- * ds) delete surround
-- * visual block mode can surround line with html tag
-- * 2cs" - change outer quotes
-- 
-- spellcheck:
--
-- commenting:
--
-- movement:
-- HopWord = <leader>h
-- HopLine = <leader>l
--
-- searching:
-- * f<letter> - ; and , for next/prev
--
-- change targets:
-- * c2ina - change second inside brackets
-- * c2in" - change second inside quote
-- * cli" - change last inside "

-- Hop navigation
map('n', '<leader>j', '<cmd>HopWord<CR>')
map('n', '<leader>l', '<cmd>HopLine<CR>')

-- Easy align stuff
map('v', '<enter>', '<cmd>EasyAlign<CR>')

-- Paste last yank, nb: pressing '"' allows which-key to show register yank history
map('n', '<leader>p', '"0p')

-- Execute code action
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')

-- toggle line numbers
map('n', '<leader>n', '<cmd>set nonumber!|set norelativenumber!<CR>')

-- Clumziness..
--map('n', ':Q', ':)

-- Toggle CTags sidebar..
map('n', '<leader>c', '<cmd>TagbarToggle<CR>')

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Tab navigation
map('n', '<Tab>', '<cmd>bnext<CR>', { noremap = true, silent = true })
map('n', '<S-Tab>', '<cmd>bprev<CR>', { noremap = true, silent = true })

-- s/// shortcut
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>', { silent = false })
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>', { silent = false })

-- toggle Trouble diagnostics viewer
map('n', '<leader>t', '<cmd>TroubleToggle lsp_document_diagnostics<CR>')

-- Unset highlight
map('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true })

-- Search for word under cursor
map('n', '<leader>/', '*N', { noremap = true, silent = true })

-- Explore
map('n', '<leader>e', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- FIXME: Toggle diagnostics
vim.g.diagnostics_active = true

function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.lsp.diagnostic.clear(0)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    vim.g.diagnostics_active = false
  else
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      }
    )
    vim.g.diagnostics_active = true
  end
end

vim.api.nvim_set_keymap('n', '<leader>d', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true})
