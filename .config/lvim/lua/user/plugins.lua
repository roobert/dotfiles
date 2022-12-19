lvim.plugins = {
	-- place to store reminders and rarely used but useful stuff
	{
		"sudormrfbin/cheatsheet.nvim",
		requires = {
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

	-- my new cool theme!
	{ "roobert/nightshift.vim", requires = "rktjmp/lush.nvim" },

	-- colorscheme creator
	{ "rktjmp/lush.nvim" },

	-- useful for TSHighlightCapturesUnderCursor
	{ "nvim-treesitter/playground" },

	-- colorize hex colours
	{ "norcalli/nvim-colorizer.lua" },

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
	{
		"jayp0521/mason-null-ls.nvim",
		config = function()
			require("mason-null-ls").setup({
				automatic_installation = false,
				automatic_setup = true,
				ensure_installed = nil,
			})
			require("mason-null-ls").setup_handlers()
		end,
	},

	-- scope buffers to tabs to work around vims annoying buffer and tab management
	--{ "tiagovla/scope.nvim" },

	-- merge bdelete, close, and quit
	--{ "mhinz/vim-sayonara" },

	{
		"roobert/bufferline-cycle-windowless.nvim",
		requires = {
			{ "akinsho/bufferline.nvim" },
		},
		setup = function()
			require("bufferline-cycle-windowless").setup()
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
		requires = {
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
		end,
	},
	-- { "tpope/vim-surround" },

	-- more text objects - allow changing values in next object without being inside it,
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

	-- use lua require("null-ls-embedded").buf_format() to format code blocks in markdown
	{ "LostNeophyte/null-ls-embedded" },

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
	--   setup = function()
	--     vim.g.gutentags_modules = { "ctags" }
	--     vim.g.gutentags_project_root = { ".git" }
	--     vim.g.gutentags_add_default_project_roots = 0
	--     vim.g.gutentags_define_advanced_commands = 1
	--     vim.g.gutentags_cache_dir = os.getenv("HOME") .. "/.cache/tags"
	--   end,
	-- },

	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- Sidebar to show ctags
	--{ "majutsushi/tagbar" },

	-- Sidebar to show symbols
	--{ "simrat39/symbols-outline.nvim" },
}
