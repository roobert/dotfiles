  return {
    dir = "/Users/rw/git/tldr-lang.nvim",
    name = "tldr-lang",
    dependencies = "roobert/node-type.nvim",
    config = function()
      require("tldr-lang").setup()
    end,
  }
