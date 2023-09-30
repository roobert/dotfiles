-- split/join blocks with leader-m
return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>m", "<cmd>lua require('treesj').toggle()<cr>", desc = "Join/Unjoin" },
  },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
}
