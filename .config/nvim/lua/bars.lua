--require('hardline').setup {}
--require('bufbar').setup {
--  show_bufname = 'all',
--  show_flags = false
--}
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff"},
    lualine_c = {"filename"},
    lualine_x = {
      {"diagnostics", sources = {"nvim_lsp"}},
      "encoding",
      "fileformat",
      "filetype"
    },
    lualine_y = {},
    lualine_z = {"location"}
  }
}
