return {
  "roobert/action-hints.nvim",
  config = function()
    require("action-hints").setup({
      use_virtual_text = true,
    })
  end,
}
