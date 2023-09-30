return {
  "roobert/statusline-action-hints.nvim",
  -- dir = "/Users/rw/git/action-hints.nvim",
  name = "action-hints",
  -- dependencies = "roobert/nightshift.vim",
  config = function()
    require("action-hints").setup({
      use_virtual_text = true,
    })
  end,
}
