return {
  "echasnovski/mini.bufremove",
  keys = {
    {
      "<leader>C",
      function()
        require("mini.bufremove").delete(0, false)
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>X",
      function()
        require("mini.bufremove").delete(0, true)
      end,
      desc = "Delete Buffer (Force)",
    },
  },
}
