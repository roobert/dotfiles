-- colorize hex colours
return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      user_default_options = { names = false },
    })
  end,
}
