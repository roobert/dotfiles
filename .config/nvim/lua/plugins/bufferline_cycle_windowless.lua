return {
  "roobert/bufferline-cycle-windowless.nvim",
  dependencies = {
    { "akinsho/bufferline.nvim" },
  },
  config = function()
    require("bufferline-cycle-windowless").setup({
      -- whether to start in enabled or disabled mode
      default_enabled = true,
    })
  end,
}
