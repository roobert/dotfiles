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
map('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
map('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
map('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
map('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- tab navigation
map('n', '<Tab>', '<cmd>bnext<CR>', { noremap = true, silent = true })
map('n', '<S-Tab>', '<cmd>bprev<CR>', { noremap = true, silent = true })

-- s/// shortcut
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>', { silent = true })
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>', { silent = true })

-- unset highlight
map('n', '<leader>h', ':set noh<CR>', { noremap = true, silent = true })

-- search for word under cursor
map('n', '<leader>/', '*N', { noremap = true, silent = true })

-- explore
map('n', '<leader>e', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Toggle diagnostics
local virtual_text = {}
virtual_text.show = true

virtual_text.toggle = function()
    virtual_text.show = not virtual_text.show
    vim.lsp.diagnostic.display(
        vim.lsp.diagnostic.get(0, 1),
        0,
        1,
        {virtual_text = virtual_text.show}
    )
end

map('n', '<Leader>d', '<Cmd>lua virtual_text.toggle()<CR>')
