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

-- formatting to be done.  See |fo-table|
vim.opt.formatoptions = vim.opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- Use the indent of the second line of a paragraph

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})

vim.g.markdown_recommended_style = 0
