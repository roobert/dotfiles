-- interface for installing plugins
return {
  -- "roobert/activate.nvim",
  dir = "/Users/rw/git/activate.nvim",
  name = "activate",
  keys = {
    { "<leader>P", '<CMD>lua require("activate").list_plugins()<CR>', desc = "Plugins" },
  },
}
