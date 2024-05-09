return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      init = function()
        -- disable rtp plugin, as we only need its queries for mini.ai
        -- In case other textobject modules are enabled, we will load them
        -- once nvim-treesitter is loaded
        require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        load_textobjects = true
      end,
    },
  },
  cmd = { "TSUpdateSync" },
  keys = {
    { "<CR>", desc = "Increment selection" },
    { "<BS>", desc = "Decrement selection", mode = "x" },
  },
  ---@type TSConfig
  opts = {
    highlight = { enable = true },
    indent = { enable = true },

    ensure_installed = {
      "arduino",
      "bash",
      "c",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      -- "markdown_inline",
      "python",
      "query",
      "regex",
      "hcl",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },

    -- FIXME: make this useful?
    move = {
      enable = false,
      set_jumps = true,
      goto_next_start = {
        -- ["]m"] = "@function.outer",
        -- ["]]"] = "@class.outer",
      },
      goto_next_end = {
        -- ["]M"] = "@function.outer",
        -- ["]["] = "@class.outer",
      },
      goto_previous_start = {
        -- ["[m"] = "@function.outer",
        -- ["[["] = "@class.outer",
      },
      goto_previous_end = {
        -- ["[M"] = "@function.outer",
        -- ["[]"] = "@class.outer",
      },
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  },

  ---@param opts TSConfig
  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@type table<string, boolean>
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end

    require("nvim-treesitter.configs").setup(opts)

    --   if load_textobjects then
    --     -- PERF: no need to load the plugin, if we only need its queries for mini.ai
    --     if opts.textobjects then
    --       for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
    --         if opts.textobjects[mod] and opts.textobjects[mod].enable then
    --           local Loader = require("lazy.core.loader")
    --           Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
    --           local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
    --           require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
    --           break
    --         end
    --       end
    --     end
    --   end
  end,
}
