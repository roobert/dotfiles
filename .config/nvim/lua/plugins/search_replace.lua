return {
  "roobert/search-replace.nvim",
  keys = {
    { "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", mode = "v" },
    { "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", mode = "v" },
    { "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", mode = "v" },
    { "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", mode = "n" },
    { "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", mode = "n" },
    { "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", mode = "n" },
    { "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", mode = "n" },
    { "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", mode = "n" },
    { "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", mode = "n" },
    { "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", mode = "n" },
    { "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", mode = "n" },
    { "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", mode = "n" },
    { "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", mode = "n" },
    { "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", mode = "n" },
    { "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", mode = "n" },
  },
  config = function()
    require("search-replace").setup({
      default_replace_options = "gcI",
    })
  end,
}
