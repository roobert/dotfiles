lvim.log.level = "info"

lvim.leader = "space"

lvim.colorscheme = "nightshift"

lvim.format_on_save = true
lvim.lint_on_save = true

lvim.builtin.alpha.active = false
lvim.builtin.gitsigns.active = true
lvim.builtin.breadcrumbs.active = true
lvim.builtin.indentlines.active = false

lvim.builtin.cmp.formatting = {
  format = require("tailwindcss-colorizer-cmp").formatter
}

-- highlight/match brackets
lvim.builtin.treesitter.matchup.enable = true

-- enable incremental selection with <CR> and <tab>/<s-tab>
lvim.builtin.treesitter.incremental_selection = {
  module_path = "nvim-treesitter.incremental_selection",
  enable = true,
  keymaps = {
    init_selection = "<CR>",
    node_incremental = "<CR>",
    node_decremental = "<TAB>",
    scope_incremental = "<S-TAB>",
  },
  is_supported = function()
    return true
  end,
}

lvim.builtin.bufferline = {
  active = true,
  options = {
    separator_style = "slant",
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
}

lvim.builtin.project.active = false

lvim.builtin.telescope = {
  active = true,
  defaults = {
    layout_strategy = "vertical",
    initial_mode = "insert",
  },
}

vim.cmd([[set timeoutlen=500]])
vim.cmd([[set wrap]])
vim.cmd([[set linebreak]])
vim.cmd([[set cmdheight=1]])

-- Undo setting from lunarvim - wrapping cursor movement across lines
vim.cmd([[set whichwrap=b,s]])
vim.cmd([[set iskeyword+=_]])

-- show search/replace in split window
vim.o.inccommand = "split"

vim.cmd([[autocmd FileType text,latex,tex,md,markdown setlocal spell]])

vim.cmd([[autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G]])

vim.cmd(
  [[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\n\n\ndef main():\n    pass\n\n\nif __name__ == '__main__':\n    main()\" | normal G]]
)

--lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.installer.setup.check_outdated_servers_on_open = true

vim.opt.textwidth = 88
vim.opt.formatoptions = "tcrqnjv"

vim.opt.undofile = false

vim.g.copilot_node_command = "~/.nvm/versions/node/v16.18.1/bin/node"

lvim.builtin.lualine.on_config_done = function(lualine)
  local config = lualine.get_config()

  -- Remove attached lsp clients from statusline
  table.remove(config.sections.lualine_x, 2)

  -- Remove file type from statusline
  table.remove(config.sections.lualine_x, 3)

  lualine.setup(config)
end
