-- FIXME: DRY this up
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- set leader as spacebar
api.nvim_set_keymap('n', '<space>', '<NOP>',
  { noremap = true, silent = true }
)
g.mapleader = " "

-- window navigation
map('n', '<S-h>', '<C-w>h', { noremap = true, silent = true })
map('n', '<S-j>', '<C-w>j', { noremap = true, silent = true })
map('n', '<S-k>', '<C-w>k', { noremap = true, silent = true })
map('n', '<S-l>', '<C-w>l', { noremap = true, silent = true })

-- tab navigation
map('n', '<Tab>', '<cmd>bnext<CR>', { noremap = true, silent = true })
map('n', '<S-Tab>', '<cmd>bprev<CR>', { noremap = true, silent = true })

-- s/// shortcut
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>', { silent = true })
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>', { silent = true })

-- unset highlight
map('n', '<leader>h', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- search for word under cursor
map('n', '<leader>/', '*N', { noremap = true, silent = true })

-- explore
map('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
