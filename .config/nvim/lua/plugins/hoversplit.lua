return {
  "roobert/hoversplit.nvim",
  keys = { "<space>h" },
  -- dir = "/Users/rw/git/hoversplit.nvim",
  -- name = "hoversplit",
  config = function()
    require("hoversplit").setup()
  end,
}
