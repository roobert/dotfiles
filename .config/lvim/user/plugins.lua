lvim.plugins = {
  -- my new cool theme!
  {
    "roobert/nightshift.vim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme nightshift]])
    end,
  },

  -- {
  -- 	dir = "/Users/rw/git/CodeGPT.nvim",
  -- 	name = "dpayne/CodeGPT.nvim",
  -- 	lazy = false,
  -- 	priority = 100000,
  -- 	dependencies = {
  -- 		"MunifTanjim/nui.nvim",
  -- 	},
  -- },

  -- prefer fzf to telescope for fuzzy finding stuff
  {
    "ibhagwan/fzf-lua",
    setup = require("fzf-lua").setup({
      actions = {
        files = {
          ["default"] = require("fzf-lua.actions").file_edit,
        }
      }
    })
  },

  {
    "prabirshrestha/vim-lsp",
  },

  -- chatgpt..
  -- { "MunifTanjim/nui.nvim" },
  { "dpayne/CodeGPT.nvim" },

  -- {
  -- 	name = "neovim-test",
  -- 	dir = "/Users/rw/git/neovim-test.nvim",
  -- 	config = function()
  -- 		require("neovim-test").setup({
  -- 			test_opt = "blah",
  -- 		})
  -- 	end,
  -- },

  {
    "roobert/f-string-toggle.nvim",
    dependencies = "nvim-treesitter",
    config = function()
      require("f-string-toggle").setup()
    end,
  },

  -- {
  -- 	dir = "/Users/rw/git/tldr-lang.nvim",
  -- 	name = "tldr-lang",
  -- 	dependencies = "roobert/node-type.nvim",
  -- 	config = function()
  -- 		require("tldr-lang").setup()
  -- 	end,
  -- },

  -- FIXME: re-enable
  -- {
  -- 	dir = "/Users/rw/git/statusline-action-hints.nvim",
  -- 	name = "statusline-action-hints",
  -- 	config = function()
  -- 		require("statusline-action-hints").setup({
  -- 			definition_identifier = "gd",
  -- 			template = "%s ref:%s",
  -- 		})
  -- 	end,
  -- },

  -- {
  -- 	dir = "/Users/rw/git/node-type.nvim",
  -- 	name = "node-type",
  -- 	config = function()
  -- 		require("node-type").setup()
  -- 	end,
  -- },

  {
    "symphorien/node-type.nvim",
    config = function()
      require("node-type").setup()
    end,
  },

  -- FIXME: re-enable
  {
    --dir = "/Users/rw/git/surround-ui.nvim",
    "roobert/surround-ui.nvim",
    dependencies = {
      "kylechui/nvim-surround",
      "folke/which-key.nvim",
    },
    name = "surround-ui",
    config = function()
      require("surround-ui").setup()
    end,
  },

  {
    "roobert/search-replace.nvim",
    name = "search-replace",
    config = function()
      require("search-replace").setup({
        default_replace_options = "gcI",
      })
    end,
  },

  -- colorscheme creator
  { "rktjmp/lush.nvim" },

  -- smooth scrolling
  -- FIXME:
  -- * disable ctrl-b
  -- * disable ctrl-f
  -- * fix neoscroll-motions.nvim
  -- {
  -- 	"karb94/neoscroll.nvim",
  -- 	config = function()
  -- 		require("neoscroll").setup({
  -- 			-- -- All these keys will be mapped to their corresponding default scrolling animation
  -- 			-- mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
  -- 			-- hide_cursor = true, -- Hide cursor while scrolling
  -- 			-- stop_eof = true, -- Stop at <EOF> when scrolling downwards
  -- 			-- respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  -- 			-- cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  -- 			-- easing_function = nil, -- Default easing function
  -- 			-- pre_hook = nil, -- Function to run before the scrolling animation starts
  -- 			-- post_hook = nil, -- Function to run after the scrolling animation ends
  -- 			-- performance_mode = false, -- Disable "Performance Mode" on all buffers.
  -- 		})
  -- 	end,
  -- },

  -- FIXME: extra motion support for neoscroll
  -- {
  -- 	"roobert/neoscroll-motions.nvim",
  -- 	config = function()
  -- 		require("neoscroll-motions").setup()
  -- 	end,
  -- },
  -- {
  -- 	dir = "/Users/rw/git/neoscroll-motions.nvim",
  -- 	name = "neoscroll-motions",
  -- 	config = function()
  -- 		require("neoscroll-motions").setup()
  -- 	end,
  -- },

  -- place to store reminders and rarely used but useful stuff
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("cheatsheet").setup({
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
        location = "bottom",
        keys_label = "Keys",
        description_label = "Description",
        show_help = true,
      })
    end,
  },

  -- useful for TSHighlightCapturesUnderCursor
  { "nvim-treesitter/playground" },

  -- colorize hex colours
  { "NvChad/nvim-colorizer.lua" },

  -- use treesitter to auto close and auto rename html tag
  { "windwp/nvim-ts-autotag" },

  -- permit toggling diagnostics
  {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require("toggle_lsp_diagnostics").init({
        virtual_text = false,
      })
    end,
  },

  -- automatically stop hlsearch
  {
    "asiryk/auto-hlsearch.nvim",
    config = function()
      require("auto-hlsearch").setup()
    end,
  },

  -- prevent overwriting yank buffer when deleting
  {
    "gbprod/cutlass.nvim",
    config = function()
      require("cutlass").setup({
        cut_key = "m",
      })
    end,
  },

  -- a yank ring for yank history
  { "svermeulen/vim-yoink" },

  -- add substitution motions
  { "svermeulen/vim-subversive" },

  -- automatically install all the formatters and linters specified by:
  -- * linters.setup
  -- * formatters.setup
  -- {
  --   "jayp0521/mason-null-ls.nvim",
  --   config = function()
  --     require("mason-null-ls").setup({
  --       automatic_installation = false,
  --       automatic_setup = true,
  --       ensure_installed = nil,
  --     })
  --     require("mason-null-ls").setup_handlers()
  --   end,
  -- },

  -- scope buffers to tabs to work around vims annoying buffer and tab management
  --{ "tiagovla/scope.nvim" },

  -- merge bdelete, close, and quit
  --{ "mhinz/vim-sayonara" },

  {
    "roobert/bufferline-cycle-windowless.nvim",
    dependencies = {
      { "akinsho/bufferline.nvim" },
    },
    config = function()
      require("bufferline-cycle-windowless").setup({
        default_enabled = true,
      })
    end,
  },

  -- get access to Bdelete nameless
  { "kazhala/close-buffers.nvim" },

  -- displays regexp explanation for regexp under cursor
  -- must TSInstall regex to use
  {
    "bennypowers/nvim-regexplainer",
    config = function()
      require("regexplainer").setup({
        -- 'narrative'
        mode = "narrative", -- TODO: 'ascii', 'graphical'
        -- automatically show the explainer when the cursor enters a regexp
        auto = true,
        -- filetypes (i.e. extensions) in which to run the autocommand
        filetypes = {
          "html",
          "js",
          "cjs",
          "mjs",
          "ts",
          "jsx",
          "tsx",
          "cjsx",
          "mjsx",
          "go",
          "sh",
          "tf",
          "py",
        },
        -- Whether to log debug messages
        debug = false,
        -- 'split', 'popup'
        display = "split",
        mappings = {
          toggle = "gR",
          -- examples, not defaults:
          -- show = 'gS',
          -- hide = 'gH',
          -- show_split = 'gP',
          -- show_popup = 'gU',
        },
        narrative = {
          separator = "\n",
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
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
        extra_trigger_chars = {},
      })
    end,
    event = "BufRead",
  },

  -- text objects for parenthesis, brackets, quotes, etc.
  { "onsails/lspkind-nvim" },

  --     Old text                    Command    New text
  -- ---------------------------------------------------------------------------
  --     surr*ound_words             ysiw)      (surround_words)       you surround in word
  --     *make strings               ys$"       "make strings"         you sround to end of line
  --     [delete ar*ound me!]        ds]        delete around me!      delete surround
  --     remove <b>HTML t*ags</b>    dst        remove HTML tags       delete surround tags
  --     'change quot*es'            cs'"       "change quotes"        change surround source target
  --     <b>or tag* types</b>        csth1<CR>   change surround tag
  --     delete(functi*on calls)     dsf        function calls         delete surround function
  --     par*am                      yssffunc   func(param)            you surround some function
  -- add around objects
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  -- { "tpope/vim-surround" },

  -- more text objects - allow changing values in next object without being inside it,
  -- i.e: ci"" from outside the quotes

  -- highlighting/navigation of matching brackets
  { "andymass/vim-matchup" },

  -- quick navigation within the visible buffer
  -- {
  --   "phaazon/hop.nvim",
  --   name = "hop",
  --   keys = { "s", "S" },
  --   config = function()
  --     -- see :h hop-config
  --     require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
  --     vim.api.nvim_set_keymap("n", "s", ":HopWord<cr>", {})
  --     vim.api.nvim_set_keymap("n", "S", ":HopPattern<cr>", {})
  --   end,
  -- },

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
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
        search = { pattern = [[\b(KEYWORDS)\b]] },
        highlight = { pattern = [[.*<(KEYWORDS)\s*]] },
        keywords = {
          FIXME = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          WARNING = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          TODO = { icon = " ", color = "info" },
          NOTE = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#ffaaaa" },
          warning = { "DiagnosticWarning", "WarningMsg", "#ffeedd" },
          info = { "DiagnosticInfo", "#99ccff" },
          hint = { "DiagnosticHint", "#99dddd" },
        },
      })
    end,
  },

  -- Nice interface for displaying nvim diagnostics
  {
    "folke/trouble.nvim",
    --dependencies = "kyazdani42/nvim-web-devicons",
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

  -- use lua require("null-ls-embedded").buf_format() to format code blocks in markdown
  -- { "LostNeophyte/null-ls-embedded" },

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
        require("copilot").setup({
          panel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<C-p>",
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
          copilot_node_command = "node", -- Node version must be < 18
          server_opts_overrides = {},
          plugin_manager_path = os.getenv("LUNARVIM_RUNTIME_DIR") .. "/site/pack/packer",
        })
      end, 100)
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup({
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      })
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- Auto handle ctags to allow jumping to definitions
  -- {
  --   "ludovicchabant/vim-gutentags",
  --   init = function()
  --     vim.g.gutentags_modules = { "ctags" }
  --     vim.g.gutentags_project_root = { ".git" }
  --     vim.g.gutentags_add_default_project_roots = 0
  --     vim.g.gutentags_define_advanced_commands = 1
  --     vim.g.gutentags_cache_dir = os.getenv("HOME") .. "/.cache/tags"
  --   end,
  -- },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Sidebar to show ctags
  --{ "majutsushi/tagbar" },

  -- Sidebar to show symbols
  --{ "simrat39/symbols-outline.nvim" },

  -- Chatgpt interface
  {
    "dense-analysis/neural",
    config = function()
      require("neural").setup({
        open_ai = {
          api_key = os.getenv("NEOVIM_OPENAPI_KEY"),
        },
        ui = {
          icon = " ",
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "ElPiloto/significant.nvim",
    },
  },

  -- completion hints for tailwindcss
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },

  -- https://github.com/CKolkey/ts-node-action
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("ts-node-action").setup({})
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
    },
  }
}