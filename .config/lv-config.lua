-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
--
-- TSInstall python
-- LSPInstall python
-- PackerSync
-- PackerCompile
-- install formatters: black, isort, shfmt, terraform fmt, stylua

--NOTE
-- * See :PackerStatus for loaded plugins..
-- * Install LSP Servers with LspInstall ...
-- * Install DSP servers with DIinstall ...
-- * Install formatters and linters into global context, or project env

-- lvim.debug = true
-- lvim.log.level = "debug"

-- general
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "nightshift"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
-- end
--
lvim.builtin.which_key.mappings["D"] = {
	"<cmd>TroubleToggle lsp_document_diagnostics<cr>",
	"Document Diagnostics",
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>lua require'telescope'.extensions.project.project{}<CR>", "Projects" }

lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
	f = { "<cmd>TroubleToggle lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Document Diagnostics" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "QuickFix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "LocationList" },
	w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.telescope.active = true
lvim.builtin.nvimtree.active = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- set a formatter if you want to override the default lsp one (if it exists)
lvim.lang.python.formatters = {
	{
		exe = "black",
		args = { "--fast" },
	},
	{
		exe = "isort",
		args = { "--profile", "black" },
	},
}

lvim.lang.lua.formatters = { { exe = "stylua" } }
lvim.lang.lua.linters = { { exe = "luacheck" } }

-- set an additional linter
lvim.lang.python.linters = {
	{
		exe = "flake8",
		args = {},
	},
}

--lvim.completion.autocomplete = true
lvim.transparent_window = true
lvim.line_wrap_cursor_movement = false
--lvim.colorscheme = "nightshift"

--lvim.builtin.galaxyline.colors.bg = "#001040"
--lvim.builtin.galaxyline.colors.alt_bg = "#001040"

lvim.plugins = {
	{ "windwp/nvim-ts-autotag" },
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
		end,
	}, -- indent blank lines for nice indent guides
	{ "roobert/nightshift.vim" }, -- my new cool theme!
	{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }, -- improved fuzzy search
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").on_attach({
				bind = true, -- This is mandatory, otherwise border config won't get registered.
				-- If you want to hook lspsaga or other signature handler, pls set to false
				doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
				-- set to 0 if you DO NOT want any API comments be shown
				-- This setting only take effect in insert mode, it does not affect signature help in normal
				-- mode, 10 by default

				floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
				hint_enable = true, -- virtual hint enable
				hint_prefix = " 👉 ", -- Panda for parameter
				fix_pos = true,
				hint_scheme = "String",
				use_lspsaga = false, -- set to true if you want to use lspsaga popup
				hi_parameter = "Search", -- how your parameter will be highlight
				max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
				-- to view the hiding contents
				max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
				handler_opts = {
					border = "single", -- double, single, shadow, none
				},
				extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
				-- deprecate !!
				-- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
			})
		end,
		event = "InsertEnter",
	}, -- signatures for functions
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
	-- FIXME: broken
	--{
	--	"ludovicchabant/vim-gutentags",
	--	setup = function()
	--		vim.g.gutentags_modules = { "ctags" }
	--		vim.g.gutentags_project_root = { ".git" }
	--		vim.g.gutentags_add_default_project_roots = 0
	--		vim.g.gutentags_define_advanced_commands = 1
	--		vim.g.gutentags_cache_dir = os.getenv("HOME") .. "/.cache/tags"
	--	end,
	--}, -- Auto handle ctags to allow jumping to definitions
	--{'majutsushi/tagbar'}, -- Sidebar to show ctags
	{ "simrat39/symbols-outline.nvim" }, -- Sidebar to show symbols
	{ "kosayoda/nvim-lightbulb" }, -- Hint about code actions to make them discoverable
	{ "jeffkreeftmeijer/vim-numbertoggle" }, -- auto switch between relative and normal line numbers
	--{ "f-person/git-blame.nvim" }, -- git blame support
	{
		"ahmedkhalf/lsp-rooter.nvim",
		event = "BufRead",
		config = function()
			require("lsp-rooter").setup()
		end,
	}, -- pwd changes to project
	{ "kevinhwang91/nvim-bqf" }, -- better quick fix
	{ "can3p/incbool.vim" }, -- toggle booleans with c-x
	{ "karb94/neoscroll.nvim" }, -- smooth scrolling
	{ "chaoren/vim-wordmotion" }, -- set useful word boundaries for camel case and snake case
	{ "rktjmp/lush.nvim" }, -- colorscheme creator
	{ "nvim-treesitter/playground" }, -- Add playground until it's re-enabled in core
	{
		"ibhagwan/fzf-lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional for icons
			"vijaymarupudi/nvim-fzf",
		},
	}, -- fzf instead of telescope
	{ "ntpeters/vim-better-whitespace" }, -- highlight whitespace at EOL
}

-- FIXME
-- * this doesn't work!
--lvim.plugin.telescope.extensions = {
--  fzf = {
--    fuzzy = true, -- false will only do exact matching
--    override_generic_sorter = true, -- override the generic sorter
--    override_file_sorter = true, -- override the file sorter
--    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
--    -- the default case_mode is "smart_case"
--  },
--  fzy_native = {
--    override_generic_sorter = false,
--    override_file_sorter = false,
--  },
--}
--
--require("telescope").load_extension("fzf")

-- FIXME
--require("neoscroll").setup()

--require("nvim-treesitter.configs").setup({
--	playground = {
--		enable = true,
--		disable = {},
--		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--		persist_queries = false, -- Whether the query persists across vim sessions
--		keybindings = {
--			toggle_query_editor = "o",
--			toggle_hl_groups = "i",
--			toggle_injected_languages = "t",
--			toggle_anonymous_nodes = "a",
--			toggle_language_display = "I",
--			focus_language = "f",
--			unfocus_language = "F",
--			update = "R",
--			goto_node = "<cr>",
--			show_help = "?",
--		},
--	},
--	autotag = {
--		enable = true,
--	},
--})

-- make code actions discoverable!
require("nvim-lightbulb").update_lightbulb({
	sign = {
		enabled = true,
		-- Priority of the gutter sign
		priority = 10,
	},
	float = {
		enabled = false,
		-- Text to show in the popup float
		text = "💡",
		-- Available keys for window options:
		-- - height     of floating window
		-- - width      of floating window
		-- - wrap_at    character to wrap at for computing height
		-- - max_width  maximal width of floating window
		-- - max_height maximal height of floating window
		-- - pad_left   number of columns to pad contents at left
		-- - pad_right  number of columns to pad contents at right
		-- - pad_top    number of lines to pad contents at top
		-- - pad_bottom number of lines to pad contents at bottom
		-- - offset_x   x-axis offset of the floating window
		-- - offset_y   y-axis offset of the floating window
		-- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
		-- - winblend   transparency of the window (0-100)
		win_opts = {},
	},
	virtual_text = {
		enabled = false,
		-- Text to show at virtual text
		text = "💡",
	},
	status_text = {
		enabled = false,
		-- Text to provide when code actions are available
		text = "💡",
		-- Text to provide when no actions are available
		text_unavailable = "",
	},
})

vim.cmd("set timeoutlen=500")
vim.cmd("set wrap")
vim.cmd("set linebreak")

vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])

-- automatically switch between relative and absolute line numbers
vim.cmd([[set number relativenumber]])

-- Undo setting from lunarvim - wrapping cursor movement across lines
vim.cmd("set whichwrap=b,s")
vim.cmd("set iskeyword+=_")

vim.cmd("autocmd FileType text,latex,tex,md,markdown setlocal spell")

vim.cmd([[autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G]])
vim.cmd(
	[[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\ndef main():\n  pass\nif __name__ == '__main__':\n  main()\n\" | normal G]]
)

vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80
vim.opt.formatoptions = "tcorqnjv"

-- FIXME: none of these work
--function map(mode, lhs, rhs, opts)
--	local options = { noremap = true }
--	if opts then
--		options = vim.tbl_extend("force", options, opts)
--	end
--	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
--end
--
---- Search for word under cursor
--map("n", "<leader>*", "*N", { noremap = true, silent = true })
--
---- s/// shortcut
--map("n", "<leader>S", ":%s//gcI<Left><Left><Left><Left>", { silent = false })
--map("v", "<leader>S", ":s//gcI<Left><Left><Left><Left>", { silent = false })
--
---- Toggle CTags sidebar..
--map("n", "<leader>C", "<cmd>TagbarToggle<CR>")
--
---- Execute code action
--map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
--
---- Easily escape out of Terminal mode
--map("t", "<leader><escape>", "<C-\\><C-n>")
--
---- Paste last yank, nb: pressing '"' allows which-key to show register yank history
--map("n", "<leader>P", '"0p')

-- FIXME: these are ignored

-- icons for signatures
--require("lspkind").init({
--	-- enables text annotations
--	--
--	-- default: true
--	with_text = true,
--
--	-- default symbol map
--	-- can be either 'default' or
--	-- 'codicons' for codicon preset (requires vscode-codicons font installed)
--	--
--	-- default: 'default'
--	preset = "codicons",
--
--	-- override preset symbols
--	--
--	-- default: {}
--	symbol_map = {
--		Text = "",
--		Method = "ƒ",
--		Function = "",
--		Constructor = "",
--		Variable = "",
--		Class = "",
--		Interface = "ﰮ",
--		Module = "",
--		Property = "",
--		Unit = "",
--		Value = "",
--		Enum = "了",
--		Keyword = "",
--		Snippet = "﬌",
--		Color = "",
--		File = "",
--		Folder = "",
--		EnumMember = "",
--		Constant = "",
--		Struct = "",
--	},
--})

--vim.opt.listchars = {
--  tab = "→ ",
--  eol = "↲",
--  nbsp = "␣",
--  trail = "•",
--  extends = "⟩",
--  precedes = "⟨",
--  space = "␣",
--}

-- vim easy align
-- start interactive EasyAlign in visual mode (e.g. vip<Enter>)
--vmap <Enter> <Plug>(EasyAlign)
--
-- Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
-- nmap <Leader>a <Plug>(EasyAlign)
