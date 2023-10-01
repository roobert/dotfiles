return {
  "roobert/hoversplit.nvim",
  keys = {
    {
      "<space>h",
      "<CMD>lua require('hoversplit').split_remain_focused()<CR>",
      desc = "Toggle hoversplit help",
    },
  },
  config = function()
    require("hoversplit").setup()
  end,
}
