-- function signature hints
return {
  "ray-x/lsp_signature.nvim",
  config = function()
    require("lsp_signature").on_attach({
      bind = true,
      doc_lines = 2,
      floating_window = true,
      hint_enable = true,
      hint_prefix = " 👉 ",
      fix_pos = true,
      hint_scheme = "String",
      use_lspsaga = false,
      hi_parameter = "Search",
      max_height = 12,
      handler_opts = {
        max_width = 120,
        border = "single",
      },
      extra_trigger_chars = {},
    })
  end,
  event = "BufRead",
}
