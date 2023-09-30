return {
  "roobert/search-replace.nvim",
  name = "search-replace",
  config = function()
    require("search-replace").setup({
      default_replace_options = "gcI",
    })
  end,
}
