return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "gs",
        normal_cur = "gsc",
        normal_line = "gs$",
        normal_cur_line = "gS",
        visual = "gsv",
        visual_line = "gsv$",
        delete = "gsd",
        change = "gsc",
        change_line = "gsc$",
      },
    })
  end,
}
