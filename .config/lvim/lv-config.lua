--[[
O is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
O.format_on_save = true
O.lint_on_save = true
O.completion.autocomplete = true
O.default_options.wrap = true
O.default_options.timeoutlen = 200
O.transparent_window = true
O.line_wrap_cursor_movement = false
O.colorscheme = "nightshift"

-- keymappings
O.keys.leader_key = "space"
-- overwrite the key-mappings provided by LunarVim for any mode, or leave it empty to keep them
-- O.keys.normal_mode = {
--   Page down/up
--   {'[d', '<PageUp>'},
--   {']d', '<PageDown>'},
--
--   Navigate buffers
--   {'<Tab>', ':bnext<CR>'},
--   {'<S-Tab>', ':bprevious<CR>'},
-- }
-- if you just want to augment the existing ones then use the utility function
-- require("lv-utils").add_keymap_insert_mode({ silent = true }, {
-- { "<C-s>", ":w<cr>" },
-- { "<C-c>", "<ESC>" },
-- })
-- you can also use the native vim way directly
-- vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
O.plugin.dashboard.active = true
O.plugin.terminal.active = true
O.plugin.zen.active = false
O.plugin.zen.window.height = 0.90
O.plugin.nvimtree.side = "left"
O.plugin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "maintained"
O.treesitter.ignore_install = { "haskell" }
O.treesitter.highlight.enabled = true

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- O.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- python
--O.lang.python.diagnostics.virtual_text = true
--O.lang.python.analysis.use_library_code_types = true
-- To change default formatter from yapf to black
--O.lang.python.formatter.exe = "black"
--O.lang.python.formatter.args = {"-"}

-- To change enabled linters
-- https://github.com/mfussenegger/nvim-lint#available-linters
O.lang.python.linters = { "flake8", "pylint", "mypy", ... }

-- go
-- To change default formatter from gofmt to goimports
--O.lang.formatter.go.exe = "goimports"

-- javascript
O.lang.tsserver.linter = nil

-- rust
-- O.lang.rust.rust_tools = true
-- O.lang.rust.formatter = {
--   exe = "rustfmt",
--   args = {"--emit=stdout", "--edition=2018"},
-- }

-- scala
-- O.lang.scala.metals.active = true
-- O.lang.scala.metals.server_version = "0.10.5",

--LaTeX
-- Options: https://github.com/latex-lsp/texlab/blob/master/docs/options.md
O.lang.latex.active = true
O.lang.latex.aux_directory = "."
O.lang.latex.bibtex_formatter = "texlab"
O.lang.latex.build.args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" }
O.lang.latex.build.executable = "latexmk"
O.lang.latex.build.forward_search_after = false
O.lang.latex.build.on_save = false
O.lang.latex.chktex.on_edit = false
O.lang.latex.chktex.on_open_and_save = false
O.lang.latex.diagnostics_delay = 300
O.lang.latex.formatter_line_length = 80
O.lang.latex.forward_search.executable = "zathura"
O.lang.latex.latex_formatter = "latexindent"
O.lang.latex.latexindent.modify_line_breaks = false
-- O.lang.latex.auto_save = false
-- O.lang.latex.ignore_errors = { }

-- Additional Plugins
-- O.user_plugins = {
--     {"folke/tokyonight.nvim"}, {
--         "ray-x/lsp_signature.nvim",
--         config = function() require"lsp_signature".on_attach() end,
--         event = "InsertEnter"
--     }
-- }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- O.user_autocommands = {{ "BufWinEnter", "*", "echo \"hi again\""}}

-- Additional Leader bindings for WhichKey
-- O.user_which_key = {
--   A = {
--     name = "+Custom Leader Keys",
--     a = { "<cmd>echo 'first custom command'<cr>", "Description for a" },
--     b = { "<cmd>echo 'second custom command'<cr>", "Description for b" },
--   },
-- }


-- this apparently does nothing..
--O.auto_close_tree = 1

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
O.lang.python.formatter.args = {"-q -"}
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

--vim.api.nvim_set_keymap("n", "<leader>F", '<CMD>silent Format<CR>', { noremap = true, silent = true })
--vim.cmd [[nnoremap <c-f> <cmd>lua require('fzf-lua').files()<CR>]]
--nnoremap <leader>ta :ToggleAlternate<CR>

-- make code actions discoverable!
--require'nvim-lightbulb'.update_lightbulb {
--    sign = {
--        enabled = true,
--        -- Priority of the gutter sign
--        priority = 10
--    },
--    float = {
--        enabled = false,
--        -- Text to show in the popup float
--        text = "💡",
--        -- Available keys for window options:
--        -- - height     of floating window
--        -- - width      of floating window
--        -- - wrap_at    character to wrap at for computing height
--        -- - max_width  maximal width of floating window
--        -- - max_height maximal height of floating window
--        -- - pad_left   number of columns to pad contents at left
--        -- - pad_right  number of columns to pad contents at right
--        -- - pad_top    number of lines to pad contents at top
--        -- - pad_bottom number of lines to pad contents at bottom
--        -- - offset_x   x-axis offset of the floating window
--        -- - offset_y   y-axis offset of the floating window
--        -- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
--        -- - winblend   transparency of the window (0-100)
--        win_opts = {}
--    },
--    virtual_text = {
--        enabled = false,
--        -- Text to show at virtual text
--        text = "💡"
--    },
--    status_text = {
--        enabled = false,
--        -- Text to provide when code actions are available
--        text = "💡",
--        -- Text to provide when no actions are available
--        text_unavailable = ""
--    }
--}

--vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- automatically switch between relative and absolute line numbers
vim.cmd [[set number relativenumber]]

-- FIXME: none of these work
function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Search for word under cursor
map('n', '<leader>*', '*N', {noremap = true, silent = true})

-- s/// shortcut
map('n', '<leader>S', ':%s//gcI<Left><Left><Left><Left>', {silent = false})
map('v', '<leader>S', ':s//gcI<Left><Left><Left><Left>', {silent = false})

-- Toggle CTags sidebar..
map('n', '<leader>C', '<cmd>TagbarToggle<CR>')

-- Execute code action
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')

-- Easily escape out of Terminal mode
map('t', '<leader><escape>', '<C-\\><C-n>')

-- Paste last yank, nb: pressing '"' allows which-key to show register yank history
map('n', '<leader>P', '"0p')


-- FIXME: these are ignored

--vim.opt.listchars = {
--  tab = "→ ",
--  eol = "↲",
--  nbsp = "␣",
--  trail = "•",
--  extends = "⟩",
--  precedes = "⟨",
--  space = "␣",
--}

-- Undo setting from lunarvim - wrapping cursor movement across lines
vim.cmd "set whichwrap=b,s"
vim.cmd "set iskeyword+=_"

-- NOTE
-- * See :PackerStatus for loaded plugins..

-- FIXME: part of lvim now?
-- Disable some in built plugins completely
--local disabled_built_ins = {
--    'netrw', 'netrwPlugin', 'netrwSettings', 'netrwFileHandlers', 'gzip', 'zip',
--    'zipPlugin', 'tar', 'tarPlugin', -- 'man',
--    'getscript', 'getscriptPlugin', 'vimball', 'vimballPlugin', '2html_plugin',
--    'logipat', 'rrhelper', 'spellfile_plugin'
--    -- 'matchit', 'matchparen', 'shada_plugin',
--}
--
--for _, plugin in pairs(disabled_built_ins) do vim.g['loaded_' .. plugin] = 1 end

-- return require('packer').setup(function(use)
--    use {'ray-x/lsp_signature.nvim'}
--
--    -- icons for signatures
--    use {'onsails/lspkind-nvim'}
--
--    -- text objects for paranthesis, brackets, quotes, etc.
--    use {'tpope/vim-surround'}
--
--    -- toggle commenting
--    use {'tpope/vim-commentary'}
--
--    -- more text objects - allow changing values in next object without being
--    -- inside it
--    use {'wellle/targets.vim'}
--
--    -- use '%' to jump between if/end/else, etc.
--    use {'andymass/vim-matchup', event = 'VimEnter'}
--
--    -- Highlight FIXME, TODO, NOTE, etc.
--    use {
--        "folke/todo-comments.nvim",
--        requires = "nvim-lua/plenary.nvim",
--        config = function()
--            require("todo-comments").setup {
--                highlight = {
--                    before = "", -- "fg" or "bg" or empty
--                    keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
--                    after = "fg", -- "fg" or "bg" or empty
--                    pattern = [[.*<(KEYWORDS)\s*]], -- pattern used for highlightng (vim regex)
--                    comments_only = true, -- uses treesitter to match keywords in comments only
--                    max_line_len = 400, -- ignore lines longer than this
--                    exclude = {} -- list of file types to exclude highlighting
--                },
--                search = {
--                    command = "rg",
--                    args = {
--                        "--color=never", "--no-heading", "--with-filename",
--                        "--line-number", "--column"
--                    },
--                    pattern = [[\b(KEYWORDS)\b]]
--                }
--            }
--        end
--    }
--
--    -- Nice interface for displaying nvim diagnostics
--    use {
--        "folke/trouble.nvim",
--        requires = "kyazdani42/nvim-web-devicons",
--        config = function() require("trouble").setup {} end
--    }
--
--    -- Old theme
--    use {'roobert/robs.vim'}
--
--    -- Fork of folke/tokyonight..
--    use {'roobert/tokyoshade.nvim'}
--
--    -- Visual-block+enter to align stuff
--    use {'junegunn/vim-easy-align'}
--
--    -- Auto handle ctags to allow jumping to definitions
--    use {'ludovicchabant/vim-gutentags'}
--
--    -- Sidebar to show ctags
--    use {'majutsushi/tagbar'}
--
--    -- Hint about code actions to make them discoverable
--    use {'kosayoda/nvim-lightbulb'}
--
--    -- auto switch between relative and normal line numbers
--    use {'jeffkreeftmeijer/vim-numbertoggle'}
--
--    -- Autopairs but only on CR
--    use {'9mm/vim-closer'}
-- end)

require'lsp_signature'.on_attach({
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
        border = "single" -- double, single, shadow, none
    },
    extra_trigger_chars = {} -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    -- deprecate !!
    -- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
})

-- icons for signatures
require('lspkind').init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' or
    -- 'codicons' for codicon preset (requires vscode-codicons font installed)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
        Text = '',
        Method = 'ƒ',
        Function = '',
        Constructor = '',
        Variable = '',
        Class = '',
        Interface = 'ﰮ',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '了',
        Keyword = '',
        Snippet = '﬌',
        Color = '',
        File = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = ''
    }
})

vim.cmd [[autocmd FileType text,latex,tex,md,markdown setlocal spell]]

vim.api.nvim_set_keymap("n", "<leader>dD", "<cmd>Trouble lsp_document_diagnostics<cr>",
  {silent = true, noremap = true}
)
