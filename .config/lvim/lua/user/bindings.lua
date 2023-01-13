-- disable lunarvim line-swapping
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.visual_block_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-k>"] = false
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false

-- disable find file (use search submenu -> find file)
lvim.builtin.which_key.mappings["f"] = nil

-- disable debug submenu
lvim.builtin.which_key.mappings["d"] = nil

-- disable buffer submenu
lvim.builtin.which_key.mappings["b"] = nil

-- disable write file
lvim.builtin.which_key.mappings["w"] = nil

-- disable Packer binding
lvim.builtin.which_key.mappings["p"] = nil

-- disable Treesitter info binding
lvim.builtin.which_key.mappings["T"] = nil

-- disable dashboard binding
lvim.builtin.which_key.mappings[";"] = nil

-- disable lunarvim leader-q to quit..
lvim.builtin.which_key.mappings["q"] = nil

-- disable lunarvim submenu
lvim.builtin.which_key.mappings["L"] = nil

-- disable colorscheme search
lvim.builtin.which_key.mappings["s"]["c"] = nil

-- disable recent file search
lvim.builtin.which_key.mappings["s"]["r"] = nil

-- disable register search
lvim.builtin.which_key.mappings["s"]["R"] = nil

-- disable man page search
lvim.builtin.which_key.mappings["s"]["M"] = nil

-- disable branch search
lvim.builtin.which_key.mappings["s"]["B"] = nil

lvim.builtin.which_key.mappings["w"] = { "<CMD>WhichKey<CR>", "Top-level which-key" }

-- improve keymap search with override
lvim.builtin.which_key.mappings["s"]["k"] = { "<CMD>Telescope keymaps<CR>", "Keymaps" }

-- FIXME: disable unknown binding from BetterWhiteSpace
lvim.builtin.which_key.mappings["s"]["<Space>"] = nil

lvim.builtin.which_key.mappings["s"]["b"] = { "<CMD>Telescope buffers<CR>", "Buffer list" }

lvim.builtin.which_key.mappings["t"] = { "<CMD>TroubleToggle document_diagnostics<CR>", "Trouble" }
lvim.builtin.which_key.mappings["-"] = { "<Plug>(toggle-lsp-diag-vtext)", "Toggle Diagnostics" }

lvim.builtin.which_key.mappings["+"] = { "<CMD>Copilot toggle<CR>", "Toggle Copilot" }

-- override cheatsheet binding to improve description
lvim.builtin.which_key.mappings["?"] = { "<CMD>Cheatsheet<CR>", "Cheatsheet" }

-- NOTE: ctrl-hjkl moves between splits
-- ideally vsplit and split should open next hidden buffer in list..
lvim.builtin.which_key.mappings["|"] = { "<CMD>vsplit +enew<CR>", "Vertical split" }
lvim.builtin.which_key.mappings["_"] = { "<CMD>split +enew<CR>", "Horizontal split" }

-- since we open empty splits - clean them up as we cycle through open buffers
function ChangeTab(motion)
  local last_buffer_id = vim.fn.bufnr()
  local last_buffer_name = vim.fn.expand("%")

  if motion == "next" then
    vim.cmd([[BufferLineCycleWindowlessNext]])
  elseif motion == "prev" then
    vim.cmd([[BufferLineCycleWindowlessPrev]])
  else
    error("Invalid motion: " .. motion)
    return
  end

  if last_buffer_name == "" then
    vim.cmd("bd " .. last_buffer_id)
  end
end

-- switch through visible buffers with shift-l/h
lvim.keys.normal_mode["<S-l>"] = "<CMD>lua ChangeTab('next')<CR>"
lvim.keys.normal_mode["<S-h>"] = "<CMD>lua ChangeTab('prev')<CR>"
lvim.keys.normal_mode["<S-t>"] = "<CMD>BufferLineCycleWindowlessToggle<CR>"

lvim.builtin.which_key.mappings["c"] = { "<CMD>bd<CR>", "Close Buffer/Window" }

-- not really required now we have a more intelligent tab function
lvim.builtin.which_key.mappings["d"] = { "<CMD>BDelete nameless<CR>", "Clear nameless buffers" }

-- navigate between diagnostics/errors with [/]-d
lvim.keys.normal_mode["[d"] = "<CMD>lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["]d"] = "<CMD>lua vim.diagnostic.goto_next()<CR>"

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

lvim.keys.normal_mode["<C-k>"] = [[<CMD>lua require("ts-node-action").node_action()<CR>]]

-- highlight code and press Enter then write a character to align on
-- press ctrl-x to cycle to regexp
lvim.keys.visual_mode["<Enter>"] = { "<Plug>(EasyAlign)" }

-- rebind git submenu to 'G' and bind lazygit to 'g'
local git_orig = lvim.builtin.which_key.mappings.g
lvim.builtin.which_key.mappings.g = nil
lvim.builtin.terminal.execs = {
  { "lazygit", "<leader>g", "LazyGit", "float" },
}
lvim.builtin.which_key.mappings["G"] = git_orig

lvim.builtin.which_key.mappings["r"] = { name = "SearchReplaceSingleBuffer" }
lvim.builtin.which_key.mappings["r"]["s"] =
{ "<CMD>SearchReplaceSingleBufferSelections<CR>", "SearchReplaceSingleBuffer [s]elction list" }
lvim.builtin.which_key.mappings["r"]["o"] =
{ "<CMD>SearchReplaceSingleBufferOpen<CR>", "SearchReplaceSingleBuffer [o]pen" }
lvim.builtin.which_key.mappings["r"]["w"] =
{ "<CMD>SearchReplaceSingleBufferCWord<CR>", "SearchReplaceSingleBuffer [w]ord" }
lvim.builtin.which_key.mappings["r"]["W"] =
{ "<CMD>SearchReplaceSingleBufferCWORD<CR>", "SearchReplaceSingleBuffer [W]ORD" }
lvim.builtin.which_key.mappings["r"]["e"] =
{ "<CMD>SearchReplaceSingleBufferCExpr<CR>", "SearchReplaceSingleBuffer [e]xpr" }
lvim.builtin.which_key.mappings["r"]["f"] =
{ "<CMD>SearchReplaceSingleBufferCFile<CR>", "SearchReplaceSingleBuffer [f]ile" }

lvim.builtin.which_key.mappings["r"]["b"] = { name = "SearchReplaceMultiBuffer" }
lvim.builtin.which_key.mappings["r"]["b"]["s"] =
{ "<CMD>SearchReplaceMultiBufferSelections<CR>", "SearchReplaceMultiBuffer [s]elction list" }
lvim.builtin.which_key.mappings["r"]["b"]["o"] =
{ "<CMD>SearchReplaceMultiBufferOpen<CR>", "SearchReplaceMultiBuffer [o]pen" }
lvim.builtin.which_key.mappings["r"]["b"]["w"] =
{ "<CMD>SearchReplaceMultiBufferCWord<CR>", "SearchReplaceMultiBuffer [w]ord" }
lvim.builtin.which_key.mappings["r"]["b"]["W"] =
{ "<CMD>SearchReplaceMultiBufferCWORD<CR>", "SearchReplaceMultiBuffer [W]ORD" }
lvim.builtin.which_key.mappings["r"]["b"]["e"] =
{ "<CMD>SearchReplaceMultiBufferCExpr<CR>", "SearchReplaceMultiBuffer [e]xpr" }
lvim.builtin.which_key.mappings["r"]["b"]["f"] =
{ "<CMD>SearchReplaceMultiBufferCFile<CR>", "SearchReplaceMultiBuffer [f]ile" }

lvim.keys.visual_block_mode["<C-r>"] = [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]]
lvim.keys.visual_block_mode["<C-s>"] = [[<CMD>SearchReplaceWithinVisualSelection<CR>]]
lvim.keys.visual_block_mode["<C-b>"] = [[<CMD>SearchReplaceWithinVisualSelectionCWord<CR>]]
