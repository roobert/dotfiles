--[[
install formatters and linters:
* black, isort, shfmt, shellcheck, terraform fmt, stylua, luacheck

rm -rf ~/.local/share/lunarvim

DIInstall python
TSInstall all
Mason
LspInstall psyright pylsp sumneko_lua bashls terraformls tflint yamlls
LspInstallInfo

PackerSync

# Show loaded plugins
PackerStatus

# More info
LvimInfo
LspInfo
]]

-- general
lvim.log.level = "info"
lvim.format_on_save = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.plugins = {
  -- my new cool theme!
  { "roobert/nightshift.vim" },

  { "windwp/nvim-ts-autotag" },

  {
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
        max_width = 120,
        handler_opts = {
          border = "single",
        },
        extra_trigger_chars = {}
      })
    end,
    event = "BufRead",
  },

  -- text objects for parenthesis, brackets, quotes, etc.
  { "onsails/lspkind-nvim" },

  -- add around objects
  { "tpope/vim-surround" },

  -- more text objects - allow changing values in next object without being inside it
  { "andymass/vim-matchup", event = "VimEnter" },

  -- use '%' to jump between if/end/else, etc.
  { "wellle/targets.vim" },

  -- Highlight FIXME, TODO, NOTE, etc.
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
        highlight = {
          before = "", -- "fg" or "bg" or empty
          keyword = "bg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
          after = "fg", -- "fg" or "bg" or empty
          pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
          comments_only = true, -- uses treesitter to match keywords in comments only
          max_line_len = 400, -- ignore lines longer than this
          exclude = {}, -- list of file types to exclude highlighting
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]],
        },
      })
    end,
  },

  -- Nice interface for displaying nvim diagnostics
  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
    end,
  },

  -- Visual-block+enter to align stuff
  { "junegunn/vim-easy-align" },

  -- Hint about code actions to make them discoverable
  { "kosayoda/nvim-lightbulb" },

  -- auto switch between relative and normal line numbers
  { "jeffkreeftmeijer/vim-numbertoggle" },

  -- toggle booleans with c-x
  { "can3p/incbool.vim" },

  -- set useful word boundaries for camel case and snake case
  { "chaoren/vim-wordmotion" },

  -- colorscheme creator
  { "rktjmp/lush.nvim" },

  -- highlight whitespace at EOL
  { "ntpeters/vim-better-whitespace" },
  { 'michaeljsmith/vim-indent-object' },

  -- Auto handle ctags to allow jumping to definitions
  -- {
  --   "ludovicchabant/vim-gutentags",
  --   setup = function()
  --     vim.g.gutentags_modules = { "ctags" }
  --     vim.g.gutentags_project_root = { ".git" }
  --     vim.g.gutentags_add_default_project_roots = 0
  --     vim.g.gutentags_define_advanced_commands = 1
  --     vim.g.gutentags_cache_dir = os.getenv("HOME") .. "/.cache/tags"
  --   end,
  -- },

  -- Sidebar to show ctags
  --{ "majutsushi/tagbar" },

  -- Sidebar to show symbols
  --{ "simrat39/symbols-outline.nvim" },
}

lvim.colorscheme = "nightshift"
lvim.lint_on_save = true
lvim.builtin.gitsigns.active = true
lvim.builtin.bufferline.active = true
lvim.builtin.breadcrumbs.active = true
lvim.builtin.indentlines = { active = false }

vim.cmd [[set timeoutlen=500]]
vim.cmd [[set wrap]]
vim.cmd [[set linebreak]]
vim.cmd [[set cmdheight=1]]

-- Undo setting from lunarvim - wrapping cursor movement across lines
vim.cmd [[set whichwrap=b,s]]
vim.cmd [[set iskeyword+=_]]

vim.cmd [[autocmd FileType text,latex,tex,md,markdown setlocal spell]]

vim.cmd [[autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G]]

vim.cmd [[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\ndef main():\n  pass\nif __name__ == '__main__':\n  main()\n\" | normal G]]

--vim.opt.colorcolumn = "88"
vim.opt.textwidth = 88
vim.opt.formatoptions = "tcrqnjv"

vim.opt.undofile = false

-- remove inline diagnostic text
vim.diagnostic.config({ virtual_text = false })

-- allow toggling of diagnostic text
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.config({ virtual_text = true })
  end
end

lvim.keys.normal_mode["<leader>-"] = ":call v:lua.toggle_diagnostics()<CR>"

-- toggle buffer list shift-f
--
-- toggle trouble with leader-t
--
-- toggle diagnostic inline hints with leader--
--
-- shift-k = show description / show full line in Trouble
--
-- switch panes with ctrl-hjkl
--
-- switch buffers with shift-l/h
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

lvim.keys.normal_mode["<S-f>"] = ":Telescope buffers<CR>"

lvim.keys.normal_mode["<leader>t"] = "<CMD>TroubleToggle document_diagnostics<CR>"

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "shfmt", filetypes = { "sh" } },
  { command = "terraform_fmt", filtypes = { "terraform" } },
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  {
    command = "prettier",
    extra_args = { "--print-with", "100" },
    filetypes = { "typescript", "typescriptreact" },
  },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  {
    -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "shellcheck",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--severity", "warning" },
  },
  {
    command = "codespell",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "python" },
  },
}

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.installer.setup.check_outdated_servers_on_open = true

lvim.log.level = "info"
lvim.format_on_save = true
lvim.leader = "space"
