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

local lazyterm = function()
  Util.float_term(nil, { cwd = Util.get_root() })
end
-- map("n", "<c-/>", "", {})
-- map("n", "<c-t>", lazyterm, { desc = "Terminal (root dir)" })

-- map("v", "<leader>/", "<CMD>MiniComment.textobject()<CR>", { "Comment" })

-- unbind telescope grep
-- map("n", "<leader>/", "", {})
-- map("n", "<leader>/", "gc", { "Comment" })
-- map("v", "<leader>/", "gc", { "Comment" })
-- map("x", "<leader>/", "gc", { "Comment" })

-- map("n", "<c-g>", "<CMD>FzfLua grep<CR>", { desc = "fzf grep" })
-- map("n", "<c-f>", "<CMD>FzfLua files<CR>", { desc = "fzf files" })
-- map("n", "<c-b>", "<CMD>FzfLua buffers<CR>", { desc = "fzf buffers" })
-- map("n", "<c-r>", "<CMD>FzfLua lsp_references<CR>", { desc = "fzf lsp references" })
-- map("n", "<c-k>", "<CMD>FzfLua keymaps<CR>", { desc = "fzf keymaps" })
-- map("n", "<c-s>", "<CMD>FzfLua lsp_document_symbols<CR>", { desc = "fzf lsp document symbols" })

map("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", {})
map("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", {})
map("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", {})

map("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", {})
map("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", {})
map("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", {})
map("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", {})
map("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", {})
map("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", {})

map("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", {})
map("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", {})
map("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", {})
map("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", {})
map("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", {})
map("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", {})

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"

map("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })
map("v", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })
map("x", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })

-- map("i", "<M-left>", "<CMD>lua require('tabtree').previous()<CR>", { desc = "Previous node" })
-- map("i", "<M-right>", "<CMD>lua require('tabtree').next()<CR>", { desc = "Next node" })
--
-- map("n", "<M-left>", "<CMD>lua require('tabtree').previous()<CR>", { desc = "Previous node" })
-- map("n", "<M-right>", "<CMD>lua require('tabtree').next()<CR>", { desc = "Next node" })
--
-- map("n", "<S-Tab>", "<CMD>lua require('tabtree').previous()<CR>", { desc = "Previous node" })
-- map("n", "<Tab>", "<CMD>lua require('tabtree').next()<CR>", { desc = "Next node" })
