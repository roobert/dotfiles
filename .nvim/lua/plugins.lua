-- auto install Packer if it doesn't exist..
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    api.nvim_command 'packadd packer.nvim'
    require('plugins')
    cmd 'PackerInstall'
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- packer manage itself
    use {'wbthomason/packer.nvim'}

    -- improves syntax highlighting, amongst other things..
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- LSP configurations for builtin LSP client
    -- this handles starting language servers for the built-in
    -- neovim LSP client to attach to
    use {
        'neovim/nvim-lspconfig',
        config = function()
            require 'plugins.nvim-lspconfig'
        end
    }

    -- language server installation management with LspInstall
    use {'kabouzeid/nvim-lspinstall'}

    -- complimentary package for  lsp-config and lsp-install but for now we'll
    -- configure our own language servers..
    -- use {'mattn/vim-lsp-settings'}

    -- linter / format executor chained off neovim LSP
    -- nvim-lsp doesn't really handle formatting so we use efm for now to run
    -- things like shellcheck, terraform fmt, and black/isort, etc.
    use {'mattn/efm-langserver'}

    -- fancy vs-code-like completion
    use {
        'hrsh7th/nvim-compe',
        config = function()
            require 'plugins.nvim-compe'
        end
    }

    -- signatures for functions
    use {'ray-x/lsp_signature.nvim'}

    -- icons for signatures
    use {'onsails/lspkind-nvim'}

    -- adjust shiftwidth and expandtab based on filetype
    use {'tpope/vim-sleuth'}

    -- text objects for paranthesis, brackets, quotes, etc.
    use {'tpope/vim-surround'}

    -- toggle commenting
    use {'tpope/vim-commentary'}

    -- more text objects - allow changing values in next object without being
    -- inside it
    use {'wellle/targets.vim'}

    -- use '%' to jump between if/end/else, etc.
    use {'andymass/vim-matchup', event = 'VimEnter'}

    -- Tab bar
    -- use {
    --  'ojroques/nvim-bufbar'
    -- }
    -- use {
    --  'romgrk/barbar.nvim'
    -- }
    use {'pacha/vem-tabline'}

    -- Status bar
    use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}

    -- NvimTree explorer
    use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons'}}

    -- Fancy fuzzy-finder/explorer/viewer/interface
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'ryanoasis/vim-devicons'}}
    }

    -- Auto-switch dir, useful when opening other files relative to the current
    -- files project root
    use {
        "ahmedkhalf/lsp-rooter.nvim",
        config = function()
            require("lsp-rooter").setup {}
        end
    }

    -- Press any key to show next available options..
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {plugins = {spelling = {enabled = true, suggestions = 20}}}
        end
    }

    -- Quickly navigate a buffer
    use {
        'phaazon/hop.nvim',
        as = 'hop',
        config = function()
            require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'}
        end
    }

    -- Highlight FIXME, TODO, NOTE, etc.
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {}
        end
    }

    -- Provide useful indent guides
    use {
        "lukas-reineke/indent-blankline.nvim",
        branch = "lua",
        config = function()
            require("indent-blankline").setup {}
        end
    }

    -- Nice interface for displaying nvim diagnostics
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end
    }

    -- Old theme
    use {'roobert/robs.vim'}

    -- Fork of folke/tokyonight..
    use {'roobert/tokyoshade.nvim'}

    -- Colorize hex colours
    use {'norcalli/nvim-colorizer.lua'}

    -- Visual-block+enter to align stuff
    use {'junegunn/vim-easy-align'}

    -- Auto handle ctags to allow jumping to definitions
    use {'ludovicchabant/vim-gutentags'}

    -- Sidebar to show ctags
    use {'majutsushi/tagbar'}

    -- Hint about code actions to make them discoverable
    use {'kosayoda/nvim-lightbulb'}

    -- auto switch between relative and normal line numbers
    use {'jeffkreeftmeijer/vim-numbertoggle'}

    -- FIXME: Autopairs but only on CR
    use {'9mm/vim-closer'}
end)
