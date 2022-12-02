--[[
Read more about this config: https://roobert.github.io/2022/11/28/Extending-Neovim/

# Reset the state
rm -rf ~/.local/share/lunarvim
]]

--
-- Plugins
--

lvim.plugins = {
  -- place to store reminders and rarely used but useful stuff
  { 'sudormrfbin/cheatsheet.nvim',
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require('cheatsheet').setup {
        bundled_cheatsheets = false,
        -- {
        --   enabled = { 'default' },
        --   disabled = {
        --     'unicode',
        --     'nerd-fonts',
        --     'edit-vim',
        --     'text-manipulation-vim',
        --     'edit-vim',
        --     'file-vim'
        --   },
        -- },
        bundled_plugin_cheatsheets = false,
        include_only_installed_plugins = false,
        location = 'bottom',
        keys_label = 'Keys',
        description_label = 'Description',
        show_help = true,
      }
    end,
  },

  -- my new cool theme!
  { "roobert/nightshift.vim",
    requires = "rktjmp/lush.nvim"
  },

  -- colorscheme creator
  { "rktjmp/lush.nvim" },

  -- useful for TSHighlightCapturesUnderCursor
  { "nvim-treesitter/playground" },

  -- colorize hex colours
  { "norcalli/nvim-colorizer.lua" },

  -- use treesitter to auto close and auto rename html tag
  { "windwp/nvim-ts-autotag" },

  -- permit toggling diagnostics
  { "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require 'toggle_lsp_diagnostics'.init({
        virtual_text = false
      })
    end
  },

  -- prevent overwriting yank buffer when deleting
  { "gbprod/cutlass.nvim",
    config = function()
      require("cutlass").setup({
        cut_key = 'm'
      })
    end
  },

  -- add substitution motions
  { "svermeulen/vim-subversive" },

  -- a yank ring for yank history
  { "svermeulen/vim-yoink" },

  -- automatically install all the formatters and linters specified by:
  -- * linters.setup
  -- * formatters.setup
  { "jayp0521/mason-null-ls.nvim",
    config = function()
      require "mason-null-ls".setup({
        automatic_installation = false,
        automatic_setup = true,
        ensure_installed = nil
      })
    end
  },

  -- displays regexp explanation for regexp under cursor
  -- must TSInstall regex to use
  { 'bennypowers/nvim-regexplainer',
    config = function() require 'regexplainer'.setup({
        -- 'narrative'
        mode = 'narrative', -- TODO: 'ascii', 'graphical'

        -- automatically show the explainer when the cursor enters a regexp
        auto = true,

        -- filetypes (i.e. extensions) in which to run the autocommand
        filetypes = {
          'html',
          'js',
          'cjs',
          'mjs',
          'ts',
          'jsx',
          'tsx',
          'cjsx',
          'mjsx',
          'go',
          'sh',
          'tf',
          'py',
        },

        -- Whether to log debug messages
        debug = false,

        -- 'split', 'popup'
        display = 'split',

        mappings = {
          toggle = 'gR',
          -- examples, not defaults:
          -- show = 'gS',
          -- hide = 'gH',
          -- show_split = 'gP',
          -- show_popup = 'gU',
        },

        narrative = {
          separator = '\n',
        },
      }
      )
    end,
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    }
  },

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

  --     Old text                    Command    New text
  -- ---------------------------------------------------------------------------
  --     surr*ound_words             ysiw)      (surround_words)       you surround in ord
  --     *make strings               ys$"       "make strings"         you sround to end of line
  --     [delete ar*ound me!]        ds]        delete around me!      delete surround
  --     remove <b>HTML t*ags</b>    dst        remove HTML tags       delete surround tags
  --     'change quot*es'            cs'"       "change quotes"        change surround source target
  --     <b>or tag* types</b>        csth1<CR>  <h1>or tag types</h1>  change surround tag
  --     delete(functi*on calls)     dsf        function calls         delete surround function
  --     par*am                      yssffunc   func(param)            you surround some function
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

  -- quick navigation within the visible buffer
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

  -- use '%' to jump between if/end/else, etc.
  { "wellle/targets.vim" },

  -- Highlighting for:
  -- FIXME:
  -- some fixme text
  --
  -- WARNING:
  -- some warning text
  --
  -- NOTE:
  -- some note text
  --
  -- TODO:
  -- some todo text

  -- Without suffixed colon:
  -- FIXME
  -- WARNING
  -- NOTE
  -- TODO
  --
  -- NOTE:
  -- Run PackerCompile after adjusting these settings..
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup(
        {
          search    = { pattern = [[\b(KEYWORDS)\b]], },
          highlight = { pattern = [[.*<(KEYWORDS)\s*]], },
          keywords  = {
            FIXME   = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE", }, },
            WARNING = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            TODO    = { icon = " ", color = "info" },
            NOTE    = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
          },
          colors    = {
            error   = { "DiagnosticError", "ErrorMsg", "#ffaaaa" },
            warning = { "DiagnosticWarning", "WarningMsg", "#ffeedd" },
            info    = { "DiagnosticInfo", "#99ccff" },
            hint    = { "DiagnosticHint", "#99dddd" },
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

  -- highlight whitespace at EOL
  { "ntpeters/vim-better-whitespace" },
  { "michaeljsmith/vim-indent-object" },

  -- tpope copilot plugin..
  -- { "github/copilot.vim" },

  {
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup
        {
          panel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<C-p>"
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
              accept = "<C-Enter>",
              next = "<C-,>",
              prev = "<C-.>",
              dismiss = "<C-e>",
            },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = 'node', -- Node version must be < 18
          server_opts_overrides = {},
          plugin_manager_path = os.getenv "LUNARVIM_RUNTIME_DIR" .. "/site/pack/packer",
        }
      end, 100)
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      }
    end,
  },

  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

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

vim.cmd [[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\n\n\ndef main():\n    pass\n\n\nif __name__ == '__main__':\n    main()\" | normal G]]

--lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.installer.setup.check_outdated_servers_on_open = true

vim.opt.textwidth = 88
vim.opt.formatoptions = "tcrqnjv"

vim.opt.undofile = false

--
-- Bindings
--

-- switch buffers with shift-l/h
lvim.keys.normal_mode["<S-l>"] = "<CMD>BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<CMD>BufferLineCyclePrev<CR>"

-- navigate between errors with [/]-d
lvim.keys.normal_mode["[d"] = ":lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["]d"] = ":lua vim.diagnostic.goto_next()<CR>"

lvim.builtin.which_key.mappings["f"] = { "<CMD>Telescope buffers<CR>", "Buffer list" }
lvim.builtin.which_key.mappings["t"] = { "<CMD>TroubleToggle document_diagnostics<CR>", "Trouble" }
lvim.builtin.which_key.mappings["-"] = { "<Plug>(toggle-lsp-diag-vtext)", "Toggle Diagnostics" }

lvim.builtin.which_key.mappings["+"] = { "<CMD>Copilot toggle<CR>", "Toggle Copilot" }

-- yank history interaction
lvim.keys.normal_mode["<c-p>"] = [[<plug>(YoinkPostPasteSwapBack)]]
lvim.keys.normal_mode["<c-n>"] = [[<plug>(YoinkPostPasteSwapForward)]]
lvim.keys.normal_mode["p"] = [[<plug>(YoinkPaste_p)]]
lvim.keys.normal_mode["P"] = [[<plug>(YoinkPaste_P)]]
lvim.keys.normal_mode["gp"] = [[<plug>(YoinkPaste_gp)]]
lvim.keys.normal_mode["gP"] = [[<plug>(YoinkPaste_gP)]]
lvim.keys.normal_mode["<C-y>"] = [[<CMD>Yanks<CR>]]
lvim.keys.insert_mode["<C-y>"] = [[<CMD>Yanks<CR>]]
vim.cmd [[let g:yoinkIncludeDeleteOperations=1]]
vim.cmd [[let g:yoinkSavePersistently=1]]

-- disable lunarvim leader-q to quit..
lvim.builtin.which_key.mappings["q"] = { "", "-" }

-- disable lunarvim line-swapping
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.visual_block_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-k>"] = false
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false

-- highlight code and press Enter then write a character to align on
-- press ctrl-x to cycle to regexp
lvim.keys.visual_mode["<Enter>"] = { "<Plug>(EasyAlign)" }

--
-- LSP
--

require("mason-lspconfig").setup({
  ensure_installed = {
    "awk_ls",
    "bashls",
    "cssls",
    "dockerls",
    "gopls",
    "gradle_ls",
    "grammarly",
    "graphql",
    "html",
    "jsonls",
    "tsserver",
    "sumneko_lua",
    "marksman",
    "pyright",
    "pylsp",
    "sqlls",
    "tailwindcss",
    "terraformls",
    "tflint",
    "vuels",
    "yamlls"
  }
})

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
  { command = "gofmt", filetypes = { "go" } },
  { command = "goimports", filetypes = { "go" } },
  -- FIXME:
  -- { command = "goimports_reviser", filetypes = { "go" }} },
}

--
-- Linting
--

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" }, },
  { command = "codespell", filetypes = { "javascript", "python" } },
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

vim.g.copilot_node_command = "~/.nvm/versions/node/v16.18.1/bin/node"

lvim.builtin.bufferline.highlights = {
  error_selected = { fg = '#b8e0ff', bold = false },
  error_diagnostic_selected = { fg = '#dddddd', bold = false },
}
