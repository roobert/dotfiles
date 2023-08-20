-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable popup (cmp) menu transparency
vim.opt.pumblend = 0

-- vim.diagnostic.config({
--   float = { border = "rounded" },
-- })
--
-- -- enable borders for all float windows
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
--
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = "single",
-- })
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = "single",
-- })

-- local _border = "single"
--
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = _border,
-- })
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = _border,
-- })
--
-- vim.diagnostic.config({
--   float = { border = _border },
-- })

vim.opt.wrap = true
vim.opt.textwidth = 88
vim.opt.linebreak = true
vim.opt.inccommand = "split"
vim.opt.undofile = false

vim.g.markdown_recommended_style = 0
