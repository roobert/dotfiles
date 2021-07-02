vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
  -- packer manage itself
  use {
    'wbthomason/packer.nvim'
  }

  -- LSP configurations for builtin LSP client
  -- this handles starting language servers for the built-in
  -- neovim LSP client to attach to
  use {
    'neovim/nvim-lspconfig',
    config = function() require 'plugins.nvim-lspconfig' end
  }

  use {
    'kabouzeid/nvim-lspinstall'
  }

  -- This is a companion to lspconfig and will automatically
  -- install language servers..
  -- https://github.com/kabouzeid/nvim-lspinstall

  -- linter / format executor chained off neovim LSP use {
  use {
    'mattn/efm-langserver'
  }

  -- LSP Completion
  use {
    'hrsh7th/nvim-compe',
    config = function() require 'plugins.nvim-compe' end
  }

  -- Signatures for functions
  use {
    'ray-x/lsp_signature.nvim'
  }

  -- Autopairs but only on CR
  use {
    '9mm/vim-closer'
  }

  -- text objects for paranthesis, brackets, quotes, etc.
  use {
    'tpope/vim-surround'
  }

  -- more text objects - allow changing values in next thing
  use {
    'wellle/targets.vim'
  }

  -- Comment toggling
  use {
    'terrortylor/nvim-comment'
  }

  -- Use '%' to jump between if/end/else, etc.
  use {
    'andymass/vim-matchup',
    event = 'VimEnter'
  }

  -- Improves syntax highlighting..
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Tab bar
  --use {
  --  'ojroques/nvim-bufbar'
  --}
  --use {
  --  'romgrk/barbar.nvim'
  --}
  use {
    'pacha/vem-tabline'
  }

  -- Status bar
  --use {
  --  'ojroques/nvim-hardline'
  --}
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }

  -- Spell checking
  --use {
  --  'kamykn/spelunker.vim'
  --}

  -- NvimTree explorer
  -- FIXME: Switch to telescope?
  --use 'kyazdani42/nvim-web-devicons'
  --use 'ryanoasis/vim-devicons'
  --use 'kyazdani42/nvim-tree.lua'
  --

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'ryanoasis/vim-devicons'}
    }
  }

  -- auto switch dir, useful when opening other files relative to the current
  -- files project root
  use {
    "ahmedkhalf/lsp-rooter.nvim",
    config = function()
      require("lsp-rooter").setup {}
    end
  }

  -- press leader-esc to see keybindings
  use {
    "folke/which-key.nvim",
    config = function()
      require('which-key').setup {
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        presets = {
          z = true
        },
      }
    end
  }

  -- quickly navigate a buffer
  use {
    'phaazon/hop.nvim',
    as = 'hop',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- FIXME - TodoTrouble does not work
  -- Highlight TODO, FIXME, NOTE, etc.
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  }

  use {
    'tpope/vim-commentary'
  }

  -- use this with some other plugin to have nice indent guides..
  use {
    "lukas-reineke/indent-blankline.nvim",
    branch = "lua",
    config = function()
      require("indent-blankline").setup {}
    end
  }

  -- https://github.com/folke/trouble.nvim
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }

  use {
    'roobert/robs.vim',
  }

  use {
    'folke/tokyonight.nvim',
  }

  use {
    'norcalli/nvim-colorizer.lua'
  }

  -- visual block+enter to align stuff
  use {
    'junegunn/vim-easy-align'
  }

  -- auto handle tags..
  use {
    'ludovicchabant/vim-gutentags'
  }

  -- sidebar to show ctags
  use {
    'majutsushi/tagbar'
  }

  -- hints about code actions
  use {
    'kosayoda/nvim-lightbulb'
  }

  -- TODO
  -- Decide what to do with this stuff..

  -- Better window management for LSP?
  --use {
  --    'RishabhRD/nvim-lsputils',
  --    requires = {'RishabhRD/popfix'},
  --    config = function() require 'plugins.nvim-lsputils' end
  --}

  -- adjust shiftwidth and expandtab based on filetype
  use {
    'tpope/vim-sleuth'
  }

  -- auto switch between relative and normal line numbers
  use {
    'jeffkreeftmeijer/vim-numbertoggle'
  }
  --use {
  --  'kosayoda/nvim-lightbulb'
  --}

  -- These are like neovim builtin LSP and nvim-lspconfig
  -- vim-lsp is needed too?
  -- paq {'mattn/vim-lsp-settings'}
end)
