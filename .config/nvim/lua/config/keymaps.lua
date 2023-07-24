-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opt = vim.opt

opt.wrap = true
opt.textwidth = 88
opt.linebreak = true
opt.inccommand = "split"

vim.g.markdown_recommended_style = 0
