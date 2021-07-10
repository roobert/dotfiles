O.format_on_save = false
O.colorscheme = "tokyonight"
O.auto_close_tree = 1
O.timeoutlen = 200
O.transparent_window = false

O.plugin.dap.active = true
O.treesitter.ignore_install = { "haskell" }
O.plugin.ts_hintobjects.active = true
O.plugin.ts_textobjects.active = true
O.plugin.ts_textsubjects.active = true
O.plugin.indent_line.active = true
O.plugin.lush.active = true

O.treesitter.ensure_installed = "all"

O.lang.clang.diagnostics.virtual_text = true
O.lang.clang.diagnostics.signs = true
O.lang.clang.diagnostics.underline = true

O.lang.python.isort = true
O.lang.python.diagnostics.virtual_text = true
O.lang.python.diagnostics.signs = true
O.lang.python.diagnostics.underline = true
O.lang.python.analysis.type_checking = "off"
O.lang.python.analysis.auto_search_paths = true
O.lang.python.analysis.use_library_code_types = true
O.lang.sh.linter = "shellcheck"

-- javascript
O.lang.tsserver.linter = nil

O.lang.sh.linter = "shellcheck"

-- FIXME - make telescope use fzf

O.user_plugins = {
    {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}, -- improved fuzzy search
    {'ray-x/lsp_signature.nvim'}, -- signatures for functions
    {'tpope/vim-commentary'}, -- toggle commenting
    {'onsails/lspkind-nvim'}, -- text objects for parenthesis, brackets, quotes, etc.
    {'tpope/vim-surround'}, -- add around objects
    {'andymass/vim-matchup', event = 'VimEnter'}, -- more text objects - allow changing values in next object without being inside it
    {'wellle/targets.vim'}, -- use '%' to jump between if/end/else, etc.
    {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                highlight = {
                    before = "", -- "fg" or "bg" or empty
                    keyword = "bg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
                    after = "fg", -- "fg" or "bg" or empty
                    pattern = [[.*<(KEYWORDS)\s*]], -- pattern used for highlightng (vim regex)
                    comments_only = true, -- uses treesitter to match keywords in comments only
                    max_line_len = 400, -- ignore lines longer than this
                    exclude = {} -- list of file types to exclude highlighting
                },
                search = {
                    command = "rg",
                    args = {
                        "--color=never", "--no-heading", "--with-filename",
                        "--line-number", "--column"
                    },
                    pattern = [[\b(KEYWORDS)\b]]
                }
            }
        end
    }, -- Highlight FIXME, TODO, NOTE, etc.
		{
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }, -- improved debug
    {'roobert/robs.vim'}, -- Nice interface for displaying nvim diagnostics
    {'roobert/tokyoshade.nvim'}, -- Fork of folke/tokyonight..
    {'junegunn/vim-easy-align'}, -- Visual-block+enter to align stuff
    {'ludovicchabant/vim-gutentags'}, -- Auto handle ctags to allow jumping to definitions
    --{'majutsushi/tagbar'}, -- Sidebar to show ctags
    {'simrat39/symbols-outline.nvim'}, -- Sidebar to show symbols
    {'kosayoda/nvim-lightbulb'}, -- Hint about code actions to make them discoverable
    {'jeffkreeftmeijer/vim-numbertoggle'}, -- auto switch between relative and normal line numbers
    {'9mm/vim-closer'}, -- Autopairs but only on CR
    {'f-person/git-blame.nvim'}, -- git blame support
    {
        "ahmedkhalf/lsp-rooter.nvim",
        event = "BufRead",
        config = function() require("lsp-rooter").setup() end
    }, -- pwd changes to project
    {'kevinhwang91/nvim-bqf'}, -- better quick fix
    {'can3p/incbool.vim'} -- toggle booleans with c-x
}

O.user_which_key = {
  x = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Display Trouble document diagnostics" },
}
