-- switch buffers with shift-l/h
lvim.keys.normal_mode["<S-l>"] = "<CMD>BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<CMD>BufferLineCyclePrev<CR>"

-- navigate between errors with [/]-d
lvim.keys.normal_mode["[d"] = ":lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["]d"] = ":lua vim.diagnostic.goto_next()<CR>"

lvim.builtin.which_key.mappings["f"] = { "<CMD>Telescope buffers<CR>", "Buffer list" }
lvim.builtin.which_key.mappings["t"] = { "<CMD>TroubleToggle document_diagnostics<CR>", "Trouble" }
lvim.builtin.which_key.mappings["-"] = { "<Plug>(toggle-lsp-diag-vtext)", "Toggle Diagnostics" }

lvim.builtin.which_key.mappings["+"] = { "<CMD>Copilot toggle<CR>", "Toggle Copilot" }

-- yank history interaction
lvim.keys.normal_mode["<c-p>"] = [[<plug>(YoinkPostPasteSwapBack)]]
lvim.keys.normal_mode["<c-n>"] = [[<plug>(YoinkPostPasteSwapForward)]]
lvim.keys.normal_mode["p"] = [[<plug>(YoinkPaste_p)]]
lvim.keys.normal_mode["P"] = [[<plug>(YoinkPaste_P)]]
lvim.keys.normal_mode["gp"] = [[<plug>(YoinkPaste_gp)]]
lvim.keys.normal_mode["gP"] = [[<plug>(YoinkPaste_gP)]]
lvim.keys.normal_mode["<C-y>"] = [[<CMD>Yanks<CR>]]
lvim.keys.insert_mode["<C-y>"] = [[<CMD>Yanks<CR>]]
vim.cmd([[let g:yoinkIncludeDeleteOperations=1]])
vim.cmd([[let g:yoinkSavePersistently=1]])

-- disable lunarvim leader-q to quit..
lvim.builtin.which_key.mappings["q"] = { "", "-" }

-- disable lunarvim line-swapping
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.visual_block_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-k>"] = false
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false

-- highlight code and press Enter then write a character to align on
-- press ctrl-x to cycle to regexp
lvim.keys.visual_mode["<Enter>"] = { "<Plug>(EasyAlign)" }

-- FIXME:
-- search/replace word under cursor
lvim.keys.normal_mode["<leader>r"] = ":%s/\\<<C-r><C-w>\\>//gcI<Left><Left><Left><Left>"
lvim.keys.visual_mode["<leader>r"] = ":%s/\\<<C-r><C-w>\\>//gcI<Left><Left><Left><Left>"
lvim.keys.visual_block_mode["<leader>r"] = ":%s/\\<<C-r><C-w>\\>//gcI<Left><Left><Left><Left>"
