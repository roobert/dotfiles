-- prevent overwriting yank buffer when deleting
return {
  "gbprod/cutlass.nvim",
  config = function()
    require("cutlass").setup({
      cut_key = "m",
    })
  end,
}
