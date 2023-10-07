return {
  "mrjones2014/legendary.nvim",
  priority = 10000,
  lazy = false,
  dependencies = { "kkharji/sqlite.lua" },
  keys = {
    { "<Leader>.", "<CMD>Legendary<CR>", desc = "Legendary Keymaps" },
  },
}
