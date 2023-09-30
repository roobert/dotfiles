return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
  },
  opts = {
    options = {
      separator_style = "slant",
      close_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      right_mouse_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = require("lazyvim.config").icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
    highlights = {
      fill = {
        bg = "#252d52",
      },

      separator_selected = {
        fg = "#252d52",
      },

      separator_visible = {
        fg = "#252d52",
      },

      separator = {
        fg = "#252d52",
      },

      buffer_visible = {
        fg = "#9696ca",
        bold = false,
      },

      buffer_selected = {
        --fg = "#bae1ff",
        fg = "#eeeeee",
        bold = false,
      },

      tab_selected = {
        bold = false,
      },
    },
  },
}
