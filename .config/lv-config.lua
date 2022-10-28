--[[
# Reset the state
rm -rf ~/.local/share/lunarvim

# Install Diagnostics
DIInstall python

# Install Treesitter configs (highlighting, etc.)
TSInstall all

# Install language servers (formatting, linting, etc.)
Mason
LspInstall psyright pylsp sumneko_lua bashls terraformls tflint yamlls
LspInstallInfo

# Install plugins
PackerSync

# Show loaded plugins
PackerStatus

# More info
LvimInfo
LspInfo
]]

-- NOTE
-- TODO
-- FIXME for lualine
-- darken the grey?
-- dont display lsp attached stuff
-- dont display file type?
-- dont display left most aligned 'a' section
-- trouble stats?

--
-- Plugins
--

lvim.plugins = {
  -- my new cool theme!
  { "roobert/nightshift.vim" },

  -- colorize hex colours
  { "norcalli/nvim-colorizer.lua" },

  { "windwp/nvim-ts-autotag" },

  -- function signature hints
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
        handler_opts = {
          max_width = 120,
          border = "single",
        },
        extra_trigger_chars = {}
      })
    end,
    event = "BufRead",
  },

  -- text objects for parenthesis, brackets, quotes, etc.
  { "onsails/lspkind-nvim" },

  --     Old text                    Command         New text
  -- --------------------------------------------------------------------------------
  --     surr*ound_words             ysiw)           (surround_words)       you surround in ord
  --     *make strings               ys$"            "make strings"         you sround to end of line
  --     [delete ar*ound me!]        ds]             delete around me!      delete surround
  --     remove <b>HTML t*ags</b>    dst             remove HTML tags       delete surround tags
  --     'change quot*es'            cs'"            "change quotes"        change surround source target
  --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>  change surround tag
  --     delete(functi*on calls)     dsf             function calls         delete surround function
  --     par*am                      yssffunc        func(param)            you surround some function
  -- add around objects
  {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  -- { "tpope/vim-surround" },

  -- more text objects - allo changing values in next object without being inside it,
  -- i.e: ci"" from outside the quotes
  { "andymass/vim-matchup", event = "VimEnter" },

  -- use '%' to jump between if/end/else, etc.
  { "wellle/targets.vim" },

  -- Highlighting for:
  -- FIXME
  -- BUG
  -- WARNING
  -- TODO
  -- HACK
  -- NOTE
  -- FIX
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup(
        {
          signs = true, -- show icons in the signs column
          sign_priority = 8, -- sign priority
          -- keywords recognized as todo comments
          keywords = {
            FIX = {
              icon = " ", -- icon used for the sign, and in search results
              color = "error", -- can be a hex color, or a named color (see below)
              alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "FIX" },
              -- signs = false, -- configure signs for some keywords individually
            },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", "WARN" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
            TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
          },
          gui_style = {
            fg = "NONE", -- The gui style to use for the fg highlight group.
            bg = "BOLD", -- The gui style to use for the bg highlight group.
          },
          merge_keywords = true, -- when true, custom keywords will be merged with the defaults
          -- highlighting of the line containing the todo comment
          -- * before: highlights before the keyword (typically comment characters)
          -- * keyword: highlights of the keyword
          -- * after: highlights after the keyword (todo text)
          highlight = {
            before = "", -- "fg" or "bg" or empty
            keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
            max_line_len = 400, -- ignore lines longer than this
            exclude = {}, -- list of file types to exclude highlighting
          },
          -- list of named colors where we try to extract the guifg from the
          -- list of highlight groups or use the hex color if hl not found as a fallback
          colors = {
            error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
            warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
            info = { "DiagnosticInfo", "#2563EB" },
            hint = { "DiagnosticHint", "#10B981" },
            default = { "Identifier", "#7C3AED" },
            test = { "Identifier", "#FF00FF" }
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
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS):]], -- ripgrep regex
            -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
          },
        }
      )
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

  -- Visual-block+enter to align stuff, ctrl-x to switch to regexp
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

  {
    "phaazon/hop.nvim",
    as = "hop",
    keys = { "s", "S" },
    config = function()
      -- see :h hop-config
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      vim.api.nvim_set_keymap("n", "s", ":HopWord<cr>", {})
      vim.api.nvim_set_keymap("n", "S", ":HopPattern<cr>", {})
    end,
  },

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

  -- On-screen jump via labels <s><two characters>
  -- { "ggandor/leap.nvim",
  --   setup = function()
  --     require("leap").add_default_mappings()
  --   end,
  -- },

  -- Prevent overwriting yank buffer when deleting
  -- {
  --   "gbprod/cutlass.nvim",
  --   config = function()
  --     require("cutlass").setup({
  --       cut_key = 'x'
  --     })
  --   end
  -- }
}

--
-- Settings
--

lvim.log.level = "info"

lvim.leader = "space"

lvim.colorscheme = "nightshift"

lvim.format_on_save = true
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

-- show search/replace in split window
vim.cmd [[set inccommand=split]]

vim.cmd [[autocmd FileType text,latex,tex,md,markdown setlocal spell]]

vim.cmd [[autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G]]

vim.cmd [[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\ndef main():\n  pass\nif __name__ == '__main__':\n  main()\n\" | normal G]]

--lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.installer.setup.check_outdated_servers_on_open = true

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

--
-- Bindings
--

-- goto definition with gd
--
-- close a buffer leader-c
--
-- toggle buffer list leader-f
--
-- toggle trouble with leader-t
--
-- toggle diagnostic inline hints with leader--
--
-- shift-k = show description / show full line in Trouble
--
-- switch panes with ctrl-hjkl

-- switch buffers with shift-l/h
lvim.keys.normal_mode["<S-l>"] = "<CMD>BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<CMD>BufferLineCyclePrev<CR>"

-- navigate between errors with [/]-d
lvim.keys.normal_mode["[d"] = ":lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["]d"] = ":lua vim.diagnostic.goto_next()<CR>"

lvim.builtin.which_key.mappings["f"] = { "<CMD>Telescope buffers<CR>", "Buffer list" }
lvim.builtin.which_key.mappings["t"] = { "<CMD>TroubleToggle document_diagnostics<CR>", "Trouble" }
lvim.builtin.which_key.mappings["-"] = { "<CMD>call v:lua.toggle_diagnostics()<CR>", "Toggle Diagnostics" }

-- highlight code and press Enter then write a character to align on
-- press ctrl-x to cycle to regexp
lvim.keys.visual_mode["<Enter>"] = { "<Plug>(EasyAlign)" }

--
-- Formatting
--

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  { command = "shfmt", filetypes = { "sh" } },
  { command = "terraform_fmt", filtypes = { "terraform" } },
  {
    command = "prettier",
    extra_args = { "--print-with", "100" },
    filetypes = { "typescript", "typescriptreact" },
  },
}

--
-- Linting
--

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" }, },
  { command = "codespell", filetypes = { "javascript", "python" },
  },
}

--
-- Treesitter
--

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
  "go",
  "hcl",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
