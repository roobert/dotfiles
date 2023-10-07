-- interface for installing plugins
return {
  "roobert/activate.nvim",
  keys = {
    { "<leader>P", '<CMD>lua require("activate").list_plugins()<CR>', desc = "Plugins" },
  },
}
