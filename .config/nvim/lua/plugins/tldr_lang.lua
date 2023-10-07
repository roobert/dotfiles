return {
  "roobert/tldr-lang.nvim",
  dependencies = "roobert/node-type.nvim",
  config = function()
    require("tldr-lang").setup()
  end,
}
