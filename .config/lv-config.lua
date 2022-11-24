--[[
# Reset the state
rm -rf ~/.local/share/lunarvim

# Install Diagnostics
DIInstall python

# Install Treesitter configs (highlighting, etc.)
TSInstall all

# Install language servers (formatting, linting, etc.)
Mason
LspInstall psyright pylsp sumneko_lua bashls terraformls tflint yamlls hadolint
LspInstallInfo

# Install plugins
PackerSync

# Show loaded plugins
PackerStatus

# More info
LvimInfo
LspInfo
]]

-- darken the grey?
-- hide lsp attached stuff
-- hide file type?
-- hide left most aligned 'a' section
-- trouble stats?

--
-- Plugins
--

lvim.plugins = {
  -- my new cool theme!
  { "roobert/nightshift.vim" },

  -- useful for TSHighlightCapturesUnderCursor
  { "nvim-treesitter/playground" },

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

  -- highlight jump letters for f/F and t/T
  -- {
  --   "jinh0/eyeliner.nvim",
  --   config = function()
  --     require 'eyeliner'.setup {
  --       highlight_on_key = true
  --     }
  --   end
  -- },

  -- On-screen jump via labels <s><two characters>
  -- { "ggandor/leap.nvim",
  --   setup = function()
  --     require("leap").add_default_mappings()
  --   end,
  -- },

  -- -- Smart jump/search within visible buffer - incompatible with eyeliner.nvim
  -- {
  --   "https://gitlab.com/madyanov/svart.nvim",
  --   as = "svart.nvim",
  --   configure = function()
  --     require("svart").configure({
  --       search_update_register = false
  --     })
  --   end
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

  -- colorscheme creator
  { "rktjmp/lush.nvim" },

  -- highlight whitespace at EOL
  { "ntpeters/vim-better-whitespace" },
  { "michaeljsmith/vim-indent-object" },

  -- -- prevent delete from yanking
  -- {
  --   "tenxsoydev/karen-yank.nvim",
  --   config = function()
  --     require("karen-yank").setup(
  --       {
  --         on_delete = {
  --           -- True: delete into "_ by default; use regular registers with karen key
  --           -- False: use regular registers by default; delete into "_ with karen key
  --           black_hole_default = true,
  --         },
  --         on_yank = {
  --           -- Preserve cursor position on yank
  --           preserve_cursor = true,
  --           preserve_selection = false,
  --         },
  --         on_paste = {
  --           -- True: paste-over-selection will delete replaced text without moving it into a register - Vim default.
  --           -- False: paste-over-selection will move the replaced text into a register
  --           black_hole_default = true,
  --           preserve_selection = false,
  --         },
  --         number_regs = {
  --           -- Use number registers for yanks
  --           enable = true,
  --           -- Prevent populating multiple number registers with the same entries
  --           deduplicate = true,
  --           -- For some conditions karen will use a transitory register
  --           transitory_reg = {
  --             -- Register to use
  --             reg = "y",
  --             -- Placeholder with which the register will be filled after use
  --             -- E.g. possible values are '""' to clear it or 'false' to leave the transient content
  --             placeholder = "👩🏼",
  --           },
  --         },
  --         mappings = {
  --           -- The key that controls usage of registers - will probably talk to the manager when things don't work as intended
  --           -- You can map e.g., "<leader><leader>" if you are using the plugin inverted(black_whole_default=false)
  --           karen = "y",
  --           -- Unused keys possible values: { "d", "D", "c", "C", "x", "X", "s", "S" },
  --           -- "S" / "s" are often utilized for plugins like surround or hop. Therefore, they are not used by default
  --           unused = { "s", "S" },
  --         },
  --       }
  --     )
  --   end
  -- },

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

  -- { 'junegunn/fzf', run = function()
  --   vim.fn['fzf#install']()
  -- end
  -- },

  -- {
  --   "hrsh7th/cmp-copilot",
  --   disable = not lvim.builtin.sell_soul_to_devel,
  --   config = function()
  --     lvim.builtin.cmp.formatting.source_names["copilot"] = "(Cop)"
  --     table.insert(lvim.builtin.cmp.sources, { name = "copilot" })
  --   end
  -- },

  -- { "zbirenbaum/copilot.lua",
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup {
  --         plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
  --       }
  --     end, 100)
  --   end,
  -- },

  -- {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua", "nvim-cmp" },
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end
  -- }

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

  -- Prevent overwriting yank buffer when deleting
  -- {
  --   "gbprod/cutlass.nvim",
  --   config = function()
  --     require("cutlass").setup({
  --       cut_key = 'x'
  --     })
  --   end
  -- }

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

-- FIXME:
-- this toggle doesn't work when the virtual text is off by default

-- remove inline diagnostic text
vim.diagnostic.config({ virtual_text = false })

-- allow toggling of diagnostic text
vim.g.diagnostics_visible = false
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
-- toggle copilot = leader-+
--
-- gl = go to long description, i.e: to expand diagnostics
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
lvim.builtin.which_key.mappings["+"] = { "<CMD>Copilot toggle<CR>", "Toggle Copilot" }

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
--vim.g.copilot_no_tab_map = true

--lvim.keys.normal_mode["<c-p>"] = { [[<CMD>Copilot panel<CR>]] }
--lvim.keys.insert_mode["<c-p>"] = { [[<CMD>Copilot panel<CR>]] }

-- lvim.keys.insert_mode["<c-e>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
-- lvim.keys.insert_mode["<c-.>"] = { [[<Plug>(copilot-next)]] }
-- lvim.keys.insert_mode["<c-,>"] = { [[<Plug>(copilot-previous)]] }
-- lvim.keys.insert_mode["<c-x>"] = { [[<Plug>(copilot-suggest)]] }
-- lvim.keys.insert_mode["<c-j>"] = { [[<CMD>Copilot panel<CR>]] }

-- disable inline virtual text for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = vim.g.diagnostics_visible
  }
)
