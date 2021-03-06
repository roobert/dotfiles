O.format_on_save = true
O.timeoutlen = 200
O.transparent_window = true
O.line_wrap_cursor_movement = false
-- this apparently does nothing..
--O.auto_close_tree = 1

O.colorscheme = "nightshift"
O.plugin.galaxyline.colors.bg = "#000000"

-- NOTE: DIinstall python_dbg
O.plugin.dap.active = true
--O.plugin.ts_hintobjects.active = true
--O.plugin.ts_textobjects.active = true
--O.plugin.ts_textsubjects.active = true

-- don't include spellings in autocomplete suggestions since it pollutes the list
O.completion.spell = false
O.completion.autocomplete = true

-- Lots of errors if haskell isn't ignored
O.treesitter.ignore_install = { "haskell" }
O.treesitter.ensure_installed = "maintained"
O.treesitter.highlight.enabled = true

O.lang.clang.diagnostics.virtual_text = true
O.lang.clang.diagnostics.signs = true
O.lang.clang.diagnostics.underline = true
O.lang.python.isort = true
O.lang.python.diagnostics.virtual_text = true
O.lang.python.diagnostics.signs = true
O.lang.python.diagnostics.underline = true
O.lang.python.analysis.type_checking = "on"
O.lang.python.analysis.auto_search_paths = true
O.lang.python.analysis.use_library_code_types = true
O.lang.python.formatter.exe = "black"
O.lang.python.formatter.args = {"-q"}
O.lang.python.formatter.stdin = true

O.lang.sh.linter = "shellcheck"
--O.lang.tsserver.linter = nil

-- install formatters: black, isort, shfmt, terraform fmt, stylua
-- install linters:

O.user_plugins = {
  {
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"
      vim.g.indent_blankline_buftype_exclude = { "terminal" }
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = true
      vim.g.indent_blankline_filetype_exclude = {
        "help",
        "terminal",
        "dashboard",
      }
    end
  }, -- indent blank lines for nice indent guides
  { "roobert/nightshift.vim" }, -- my new cool theme!
	{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }, -- improved fuzzy search
	{ "ray-x/lsp_signature.nvim" }, -- signatures for functions
	{ "tpope/vim-commentary" }, -- toggle commenting
	{ "onsails/lspkind-nvim" }, -- text objects for parenthesis, brackets, quotes, etc.
	{ "tpope/vim-surround" }, -- add around objects
	{ "andymass/vim-matchup", event = "VimEnter" }, -- more text objects - allow changing values in next object without being inside it
	{ "wellle/targets.vim" }, -- use '%' to jump between if/end/else, etc.
	{
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				highlight = {
					before = "", -- "fg" or "bg" or empty
					keyword = "bg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
					after = "fg", -- "fg" or "bg" or empty
					pattern = [[.*<(KEYWORDS)\s*]], -- pattern used for highlightng (vim regex)
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
					pattern = [[\b(KEYWORDS)\b]],
				},
			})
		end,
	}, -- Highlight FIXME, TODO, NOTE, etc.
	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	}, -- improved debug
	{ "roobert/robs.vim" }, -- Nice interface for displaying nvim diagnostics
	{ "junegunn/vim-easy-align" }, -- Visual-block+enter to align stuff
	{ "ludovicchabant/vim-gutentags",
    setup = function()
      vim.g.gutentags_modules = {'ctags'}
      vim.g.gutentags_project_root = {'.git'}
      vim.g.gutentags_add_default_project_roots = 0
      vim.g.gutentags_define_advanced_commands = 1
      vim.g.gutentags_cache_dir = os.getenv('HOME') .. '/.cache/tags'
    end
  }, -- Auto handle ctags to allow jumping to definitions
	--{'majutsushi/tagbar'}, -- Sidebar to show ctags
	{ "simrat39/symbols-outline.nvim" }, -- Sidebar to show symbols
	{ "kosayoda/nvim-lightbulb" }, -- Hint about code actions to make them discoverable
	{ "jeffkreeftmeijer/vim-numbertoggle" }, -- auto switch between relative and normal line numbers
	{ "f-person/git-blame.nvim" }, -- git blame support
	{
		"ahmedkhalf/lsp-rooter.nvim",
		event = "BufRead",
		config = function()
			require("lsp-rooter").setup()
		end,
	}, -- pwd changes to project
	{ "kevinhwang91/nvim-bqf" }, -- better quick fix
	{ "can3p/incbool.vim" }, -- toggle booleans with c-x
  {'karb94/neoscroll.nvim'}, -- smooth scrolling
  {'chaoren/vim-wordmotion'}, -- set useful word boundaries for camel case and snake case
  {'rktjmp/lush.nvim'}, -- colorscheme creator
  {'nvim-treesitter/playground'}, -- Add playground until it's re-enabled in core
  { 'ibhagwan/fzf-lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional for icons
      'vijaymarupudi/nvim-fzf' }
  }, -- fzf instead of telescope
}


O.user_which_key = {
	x = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Display Trouble document diagnostics" },
}

-- FIXME
-- * this doesn't work!
--O.plugin.telescope.active = true
--O.plugin.telescope.extensions = {
--	fzf = {
--		fuzzy = true, -- false will only do exact matching
--		override_generic_sorter = true, -- override the generic sorter
--		override_file_sorter = true, -- override the file sorter
--		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
--		-- the default case_mode is "smart_case"
--	},
--	fzy_native = {
--		override_generic_sorter = false,
--		override_file_sorter = false,
--	},
--}
--
--require("telescope").load_extension("fzf")

require('neoscroll').setup()

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

vim.api.nvim_set_keymap("n", "<leader>F", '<CMD>silent Format<CR>', { noremap = true, silent = true })

vim.cmd [[nnoremap <c-f> <cmd>lua require('fzf-lua').files()<CR>]]
