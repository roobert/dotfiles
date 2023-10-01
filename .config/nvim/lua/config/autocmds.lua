-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.cmd([[autocmd FileType text,latex,tex,md,markdown setlocal spell]])

vim.cmd([[autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G]])

vim.cmd(
  [[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\n\n\ndef main():\n    pass\n\n\nif __name__ == '__main__':\n    main()\" | normal G]]
)

vim.cmd([[autocmd BufRead,BufNewFile *.bq setfiletype bigquery]])

-- Allow closing these additional buffer types with 'q'
autocmd("FileType", {
  pattern = { "fzf", "hoversplit" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ftplugins overwrite formatoptions, so use autocmd to override ftplugins
-- https://github.com/LazyVim/LazyVim/discussions/431
augroup("formatoptions", { clear = true })
autocmd("Filetype", {
  pattern = { "*" },
  callback = function()
    -- See fo-table help for option list:
    vim.opt.formatoptions = vim.opt.formatoptions
      - "a" -- disable autoformatting
      - "t" -- disable auto wrap on textwidth
      + "c" -- comments should respect textwidth
      + "q" -- permit formatting with gq
      - "o" -- disable comment continuation with o and O
      + "r" -- continue comments when pressing enter
      + "n" -- indent past the formatlistpat, not underneath it.
      + "j" -- auto remove comment leader when joining lines
      - "2" -- Use the indent of the second line of a paragraph
  end,
  group = "formatoptions",
  desc = "Set formatoptions for all filetypes",
})

-- disable the back tick coneallevel for markdown files..
autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.md" },
  callback = function()
    vim.cmd("set conceallevel=0")
  end,
})
