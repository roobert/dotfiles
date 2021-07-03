-- require('hardline').setup {}
--
-- require('bufbar').setup {
--  show_bufname = 'all',
--  show_flags = false
-- }
--
require('lualine').setup {
    options = {section_separators = {'', ''}, component_separators = {'', ''}, theme = 'tokyonight'},
    sections = {
        lualine_a = {},
        lualine_c = {"diff"},
        lualine_b = {{"filename", file_status = true, path = 1}},
        lualine_x = {{"diagnostics", sources = {"nvim_lsp"}}, "fileformat"},
        lualine_y = {},

        -- FIXME: how to make right side not colored..
        lualine_z = {{"location", color = nil}}
    }
}
