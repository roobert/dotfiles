-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable popup (cmp) menu transparency
vim.opt.pumblend = 0
vim.opt.wrap = true
vim.opt.textwidth = 88
vim.opt.linebreak = true
vim.opt.inccommand = "split"

-- undofile is ok if we have Undotree to get us out of trouble..
vim.opt.undofile = true

-- Use internal formatting for bindings like gq.
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     vim.bo[args.buf].formatexpr = nil
--   end,
-- })

vim.g.markdown_recommended_style = 0
