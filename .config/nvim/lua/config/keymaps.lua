-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Unbind move lines
map("n", "<A-j>", "", {})
map("n", "<A-k>", "", {})
map("i", "<A-j>", "", {})
map("i", "<A-k>", "", {})
map("v", "<A-j>", "", {})
map("v", "<A-k>", "", {})

-- better navigation using ctrl-hjkl
map("n", "<C-l>", "$", { desc = "EOL" })
map("n", "<C-h>", "^", { desc = "BOL" })
map("n", "<C-j>", "<C-d>", { desc = "Scroll down" })
map("n", "<C-k>", "<C-u>", { desc = "Scroll up" })

-- remap all window management to Option key
map("n", "<M-l>", "<C-w><Right>", { desc = "Win Left" })
map("n", "<M-h>", "<C-w><Left>", { desc = "Win Right" })
map("n", "<M-j>", "<C-w><Down>", { desc = "Win Down" })
map("n", "<M-k>", "<C-w><Up>", { desc = "Win Up" })

-- splitting, with and without shift key
map("n", "<M-|>", "<CMD>vsplit<CR>", { desc = "VSplit" })
map("n", "<M-_>", "<CMD>split<CR>", { desc = "Split" })
map("n", "<M-->", "<CMD>split<CR>", { desc = "Split" })
map("n", "<M-\\>", "<CMD>vsplit<CR>", { desc = "VSplit" })
map("n", "<Leader>-_", "<CMD>split<CR>", { desc = "Split" })

-- close buffers
map("n", "<M-d>", "<CMD>close<CR>", { desc = "Close" })

local lazyterm = function()
  Util.float_term(nil, { cwd = Util.get_root() })
end

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"

map("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })
map("v", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })
map("x", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })
