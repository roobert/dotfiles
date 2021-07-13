-- FIXME: none of these work
function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Search for word under cursor
map('n', '<leader>*', '*N', {noremap = true, silent = true})

-- s/// shortcut
map('n', '<leader>S', ':%s//gcI<Left><Left><Left><Left>', {silent = false})
map('v', '<leader>S', ':s//gcI<Left><Left><Left><Left>', {silent = false})

-- Toggle CTags sidebar..
map('n', '<leader>C', '<cmd>TagbarToggle<CR>')

-- Execute code action
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')

-- Easily escape out of Terminal mode
map('t', '<leader><escape>', '<C-\\><C-n>')

-- Paste last yank, nb: pressing '"' allows which-key to show register yank history
map('n', '<leader>P', '"0p')


