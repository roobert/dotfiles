-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
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

  -- linter / format executor chained off neovim LSP
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

  use {
  'roobert/robs.vim'
  }

  -- Autopairs but only on CR
  use {
    '9mm/vim-closer'
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

  -- Status bar
  use {
    'ojroques/nvim-hardline'
  }

  -- Tab bar
  use {
    'ojroques/nvim-bufbar'
  }

  -- Spell checking
  use {
    'kamykn/spelunker.vim'
  }

  -- NvimTree explorer
  -- FIXME: Switch to telescope?
  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-tree.lua'

  -- TODO
  -- Decide what to do with this stuff..

  -- Better window management for LSP?
  --use {
  --    'RishabhRD/nvim-lsputils',
  --    requires = {'RishabhRD/popfix'},
  --    config = function() require 'plugins.nvim-lsputils' end
  --}

  --use {
  --'sheerun/vim-polyglot'
  --}

  --use {
  --  'kosayoda/nvim-lightbulb'
  --}

  -- These are like neovim builtin LSP and nvim-lspconfig
  -- vim-lsp is needed too?
  -- paq {'mattn/vim-lsp-settings'}
end)
