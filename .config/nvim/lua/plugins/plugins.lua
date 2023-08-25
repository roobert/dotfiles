function P(input)
  print(vim.inspect(input))
end

return {
  -- {
  --   dir = "/Users/rw/git/tldr-lang.nvim",
  --   name = "tldr-lang",
  --   dependencies = "roobert/node-type.nvim",
  --   config = function()
  --     require("tldr-lang").setup()
  --   end,
  -- },

  {
    -- "roobert/statusline-action-hints.nvim",
    dir = "/Users/rw/git/keymap-gpt.nvim",
    name = "keymap-gpt",
    -- config = function()
    --   require("keymap-gpt").setup({
    --     use_virtual_text = true,
    --   })
    -- end,
  },

  {
    "roobert/statusline-action-hints.nvim",
    -- dir = "/Users/rw/git/action-hints.nvim",
    name = "action-hints",
    dependencies = "roobert/nightshift.vim",
    config = function()
      require("action-hints").setup({
        use_virtual_text = true,
      })
    end,
  },

  -- {
  --   "roobert/node-type.nvim",
  --   config = function()
  --     require("node-type").setup()
  --   end,
  -- },

  -- FIXME: re-enable
  -- {
  --   --dir = "/Users/rw/git/surround-ui.nvim",
  --   "roobert/surround-ui.nvim",
  --   dependencies = {
  --     "kylechui/nvim-surround",
  --     "folke/which-key.nvim",
  --   },
  --   name = "surround-ui",
  --   config = function()
  --     require("surround-ui").setup()
  --   end,
  -- },

  -- use treesitter to auto close and auto rename html tag
  { "windwp/nvim-ts-autotag" },

  -- {
  --   "roobert/bufferline-cycle-windowless.nvim",
  --   dependencies = {
  --     { "akinsho/bufferline.nvim" },
  --   },
  --   config = function()
  --     require("bufferline-cycle-windowless").setup({
  --       default_enabled = true,
  --     })
  --   end,
  -- },

  -- get access to Bdelete nameless
  -- { "kazhala/close-buffers.nvim" },

  -- text objects for parenthesis, brackets, quotes, etc.
  -- { "onsails/lspkind-nvim" },

  -- more text objects - allow changing values in next object without being inside it,
  -- i.e: ci"" from outside the quotes

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
  -- {
  --   "folke/todo-comments.nvim",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   config = function()
  --     require("todo-comments").setup({
  --       search = { pattern = [[\b(KEYWORDS)\b]] },
  --       highlight = { pattern = [[.*<(KEYWORDS)\s*]] },
  --       keywords = {
  --         FIXME = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
  --         WARNING = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
  --         TODO = { icon = " ", color = "info" },
  --         NOTE = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
  --       },
  --       colors = {
  --         error = { "DiagnosticError", "ErrorMsg", "#ffaaaa" },
  --         warning = { "DiagnosticWarning", "WarningMsg", "#ffeedd" },
  --         info = { "DiagnosticInfo", "#99ccff" },
  --         hint = { "DiagnosticHint", "#99dddd" },
  --       },
  --     })
  --   end,
  -- },

  -- Nice interface for displaying nvim diagnostics
  -- {
  --   "folke/trouble.nvim",
  --   --dependencies = "kyazdani42/nvim-web-devicons",
  --   config = function()
  --     require("trouble").setup({})
  --   end,
  -- },

  -- use lua require("null-ls-embedded").buf_format() to format code blocks in markdown
  { "LostNeophyte/null-ls-embedded" },

  -- highlight whitespace at EOL
  -- { "ntpeters/vim-better-whitespace" },
  -- { "michaeljsmith/vim-indent-object" },

  -- { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- Auto handle ctags to allow jumping to definitions
  -- {
  --   "ludovicchabant/vim-gutentags",
  --   init = function()
  --     vim.g.gutentags_modules = { "ctags" }
  --     vim.g.gutentags_project_root = { ".git" }
  --     vim.g.gutentags_add_default_project_roots = 0
  --     vim.g.gutentags_define_advanced_commands = 1
  --     vim.g.gutentags_cache_dir = os.getenv("HOME") .. "/.cache/tags"
  --   end,
  -- },

  -- {
  --   "iamcco/markdown-preview.nvim",
  --   build = "cd app && npm install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end,
  --   ft = { "markdown" },
  -- },

  -- Sidebar to show ctags
  --{ "majutsushi/tagbar" },

  -- Sidebar to show symbols
  --{ "simrat39/symbols-outline.nvim" },

  -- Chatgpt interface
  -- {
  --   "dense-analysis/neural",
  --   config = function()
  --     require("neural").setup({
  --       open_ai = {
  --         api_key = os.getenv("NEOVIM_OPENAPI_KEY"),
  --       },
  --       ui = {
  --         icon = " ",
  --       },
  --     })
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "ElPiloto/significant.nvim",
  --   },
  -- },

  -- https://github.com/CKolkey/ts-node-action
  -- {
  --   "ckolkey/ts-node-action",
  --   dependencies = { "nvim-treesitter" },
  --   config = function()
  --     require("ts-node-action").setup({})
  --   end,
  -- },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },

  {
    dir = "/Users/rw/git/chatgpt.nvim",
    name = "chatgpt",
    branch = "fix-ChatGPTEditWithInstructions-visual-range",
    -- "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    -- commit = "24bcca7",
    keys = {
      { "<leader>cc", ":<C-U>:ChatGPTEditWithInstructions<CR>", desc = "ChatGPT Interactive" },
      { "<leader>cc", ":<C-U>:ChatGPTEditWithInstructions<CR>", mode = "v", desc = "ChatGPT Interactive" },

      { "<leader>cg", "", desc = "ChatGPT" },
      { "<leader>cg", "", mode = "v", desc = "ChatGPT" },

      { "<leader>cgc", ":<C-U>:ChatGPTRun complete_code<CR>", desc = "Complete" },
      { "<leader>cgc", ":<C-U>:ChatGPTRun complete_code<CR>", mode = "v", desc = "Complete" },

      { "<leader>cgd", ":<C-U>:ChatGPTRun docstring<CR>", desc = "Document" },
      { "<leader>cgd", ":<C-U>:ChatGPTRun docstring<CR>", mode = "v", desc = "Document" },

      { "<leader>cgo", ":<C-U>:ChatGPTRun optimize_code<CR>", desc = "Optimize" },
      { "<leader>cgo", ":<C-U>:ChatGPTRun optimize_code<CR>", mode = "v", desc = "Optimize" },
      { "<leader>cgt", ":<C-U>:ChatGPTRun add_tests<CR>", desc = "Tests" },
      { "<leader>cgt", ":<C-U>:ChatGPTRun add_tests<CR>", mode = "v", desc = "Tests" },

      { "<leader>cgf", ":<C-U>:ChatGPTRun fix_bugs<CR>", desc = "Fix" },
      { "<leader>cgf", ":<C-U>:ChatGPTRun fix_bugs<CR>", mode = "v", desc = "Fix" },

      { "<leader>cga", ":<C-U>:ChatGPTRun code_readability_analysis<CR>", desc = "Analyze" },
      { "<leader>cga", ":<C-U>:ChatGPTRun code_readability_analysis<CR>", mode = "v", desc = "Analyze" },
    },
    config = function()
      require("chatgpt").setup({
        api_key_cmd = nil,
        yank_register = "+",
        edit_with_instructions = {
          diff = false,
          keymaps = {
            close = "<C-c>",
            accept = "<C-y>",
            toggle_diff = "<C-d>",
            toggle_settings = "<C-o>",
            cycle_windows = "<Tab>",
            use_output_as_input = "<C-i>",
          },
        },
        chat = {
          welcome_message = WELCOME_MESSAGE,
          loading_text = "Loading, please wait ...",
          question_sign = "",
          answer_sign = "ﮧ",
          max_line_length = 120,
          sessions_window = {
            border = {
              style = "rounded",
              text = {
                top = " Sessions ",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          },
          keymaps = {
            close = { "<C-c>" },
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
            cycle_modes = "<C-f>",
            select_session = "<Space>",
            rename_session = "r",
            delete_session = "d",
            draft_message = "<C-d>",
            toggle_settings = "<C-o>",
            toggle_message_role = "<C-r>",
            toggle_system_role_open = "<C-s>",
            stop_generating = "<C-x>",
          },
        },
        popup_layout = {
          default = "center",
          center = {
            width = "95%",
            height = "95%",
          },
          right = {
            width = "30%",
            width_settings_open = "50%",
          },
        },
        popup_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " ChatGPT ",
            },
          },
          win_options = {
            wrap = true,
            linebreak = true,
            foldcolumn = "1",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          buf_options = {
            filetype = "markdown",
          },
        },
        system_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " SYSTEM ",
            },
          },
          win_options = {
            wrap = true,
            linebreak = true,
            foldcolumn = "2",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        popup_input = {
          prompt = "  ",
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top_align = "center",
              top = " Prompt ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          submit = "<C-Enter>",
          submit_n = "<Enter>",
          max_visible_lines = 20,
        },
        settings_window = {
          border = {
            style = "rounded",
            text = {
              top = " Settings ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        openai_params = {
          model = "gpt-3.5-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "code-davinci-edit-001",
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        actions_paths = {},
        show_quickfixes_cmd = "Trouble quickfix",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- tab navigation jumping between significant code elements, such as brackets, quotes, etc.
  {
    "roobert/tabtree.nvim",
    -- dir = "/Users/rw/git/tabtree.nvim",
    -- name = "tabtree",
    config = function()
      require("tabtree").setup()
    end,
  },

  {
    "roobert/hoversplit.nvim",
    keys = { "<space>h" },
    -- dir = "/Users/rw/git/hoversplit.nvim",
    -- name = "hoversplit",
    config = function()
      require("hoversplit").setup()
    end,
  },

  -- split/join blocks with leader-m
  {
    "Wansmer/treesj",
    keys = { "<space>m" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
      vim.keymap.set("n", "<leader>m", require("treesj").toggle)
    end,
  },

  -- Hint about code actions to make them discoverable
  -- {
  --   "kosayoda/nvim-lightbulb",
  --   config = function()
  --     require("nvim-lightbulb").setup({
  --       sign = {
  --         enabled = false,
  --       },
  --       virtual_text = {
  --         enabled = true,
  --         text = "⏹",
  --         hl = "MatchParen",
  --       },
  --
  --       autocmd = { enabled = true },
  --     })
  --   end,
  -- },

  {
    "roobert/nightshift.vim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme nightshift]])
    end,
  },

  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local select_one_or_multi = function(prompt_bufnr)
        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        if not vim.tbl_isempty(multi) then
          require("telescope.actions").close(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format("%s %s", "edit", j.path))
            end
          end
        else
          require("telescope.actions").select_default(prompt_bufnr)
        end
      end

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<CR>"] = select_one_or_multi,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },

  -- prefer fzf to telescope for fuzzy finding stuff
  -- unfortunately telescope is too tightly integrated into lazyvim so telescope-fzf-native is a
  -- better option
  -- {
  --   "ibhagwan/fzf-lua",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("fzf-lua").setup({
  --       winopts = {
  --         preview = {
  --           layout = "vertical",
  --         },
  --       },
  --       actions = {
  --         files = {
  --           ["default"] = require("fzf-lua.actions").file_edit,
  --         },
  --       },
  --     })
  --   end,
  -- },

  {
    "roobert/f-string-toggle.nvim",
    dependencies = "nvim-treesitter",
    config = function()
      require("f-string-toggle").setup()
    end,
  },

  {
    "roobert/search-replace.nvim",
    name = "search-replace",
    config = function()
      require("search-replace").setup({
        default_replace_options = "gcI",
      })
    end,
  },

  -- :Lushify appears broken in LazyVim
  -- colorscheme creator
  { "rktjmp/lush.nvim" },

  -- useful for TSHighlightCapturesUnderCursor, or use <leader>ui
  { "nvim-treesitter/playground" },

  -- colorize hex colours
  { "NvChad/nvim-colorizer.lua" },

  -- prevent overwriting yank buffer when deleting
  {
    "gbprod/cutlass.nvim",
    config = function()
      require("cutlass").setup({
        cut_key = "m",
      })
    end,
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

  -- FIXME:
  -- Visual-block+enter to align stuff, ctrl-x to switch to regexp
  { "junegunn/vim-easy-align" },

  -- auto switch between relative and normal line numbers
  { "jeffkreeftmeijer/vim-numbertoggle" },

  -- toggle booleans with c-x
  { "can3p/incbool.vim" },

  -- set useful word boundaries for camel case and snake case
  { "chaoren/vim-wordmotion" },

  -- completion hints for tailwindcss
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },

  -- this is too tightly integrated with telescope..
  {
    "gbprod/yanky.nvim",
    enabled = false,
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
    opts = function()
      -- local mapping = require("yanky.telescope.mapping")
      -- local mappings = mapping.get_defaults()
      -- mappings.i["<c-p>"] = nil
      return {
        highlight = { timer = 200 },
        ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
        picker = {
          telescope = {
            use_default_mappings = false,
            -- mappings = mappings,
          },
        },
      }
    end,
  },

  -- color picker / highlighter
  { "uga-rosa/ccc.nvim" },

  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
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
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
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
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
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

      if load_textobjects then
        -- PERF: no need to load the plugin, if we only need its queries for mini.ai
        if opts.textobjects then
          for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              local Loader = require("lazy.core.loader")
              Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
              local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
              require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
              break
            end
          end
        end
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class" },
      },
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  },

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
          -- plugin_manager_path = os.getenv("LUNARVIM_RUNTIME_DIR") .. "/site/pack/packer",
        })
      end, 100)
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      require("lazyvim.util").on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter({})
        end
      end)
    end,
  },

  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        -- prefer "go surround" as mnemonic
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- try to get better habbits
  -- {
  --   "m4xshen/hardtime.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   opts = {},
  -- },

  {
    dir = "/Users/rw/git/trouble.nvim",
    branch = "feature-buffer-wrap",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true, wrap = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = {
      options = {
        separator_style = "slant",
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
      highlights = {
        fill = {
          bg = "#252d52",
        },

        separator_selected = {
          fg = "#252d52",
        },

        separator_visible = {
          fg = "#252d52",
        },

        separator = {
          fg = "#252d52",
        },

        buffer_visible = {
          fg = "#9696ca",
          bold = false,
        },

        buffer_selected = {
          --fg = "#bae1ff",
          fg = "#eeeeee",
          bold = false,
        },

        tab_selected = {
          bold = false,
        },
      },
    },
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = "<leader>/",

        -- Toggle comment on current line
        comment_line = "<leader>/",

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        textobject = "gc",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("lazyvim.config").icons
      local Util = require("lazyvim.util")

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },

        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = {
            -- {
            --   require("node-type").statusline,
            -- },
            {
              require("action-hints").statusline,
            },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = Util.fg("Statement"),
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = Util.fg("Constant"),
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = Util.fg("Debug"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- increase timeout for slow formatters/linters called via null-ls
      format = { timeout_ms = 4000 },

      -- alternate path to call Mason.ensure_installed()
      -- list of available servers: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      --
      -- terraform/python (and where possible) configure through lazyvim extras: https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras/lang
      servers = {
        dotls = {},
        gopls = {},
        graphql = {},
        sqlls = {},
        svelte = {},
        yamlls = {},

        -- merge pyright and ruff diagnostic capabilities
        -- pyright at least provides unused variable detection
        pyright = {
          capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
          end)(),
          settings = {
            python = {
              analysis = {
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportUnusedVariable = "warning",
                },
                typeCheckingMode = "basic",
              },
            },
          },
        },

        ruff_lsp = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },

    -- example of setup injection
    -- setup = {
    --   ruff_lsp = function()
    --     require("lazyvim.util").on_attach(function(client, _)
    --       if client.name == "ruff_lsp" then
    --         -- Disable hover in favor of Pyright
    --         client.server_capabilities.hoverProvider = false
    --       end
    --     end)
    --   end,
    -- },
  },

  -- Mason ensures dependencies are installed
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "alex",
        "awk-language-server",
        "bash-language-server",
        "black",
        "dockerfile-language-server",
        "dot-language-server",
        "eslint-lsp",
        "html-lsp",
        "htmlbeautifier",
        "isort",
        "jq",
        "jq-lsp",
        "misspell",
        "prettier",
        "proselint",
        -- prefer ruff and pyright
        -- "python-lsp-server",
        "shellcheck",
        "shfmt",
        "sql-formatter",
        "sqlfluff",
        "sqlfmt",
        "sqlls",
        "stylua",
        "svelte-language-server",
        "vue-language-server",
        "write-good",
        "yq",
      },
    },
  },

  -- null-ls permits running linters/formatters that are not LSP based
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        -- stuff here also gets installed by Mason via mason-null-ls
        vim.list_extend(opts.sources, {
          null_ls.builtins.diagnostics.proselint,
          null_ls.builtins.code_actions.proselint,
          null_ls.builtins.diagnostics.alex,
          null_ls.builtins.diagnostics.write_good,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.shfmt,
          -- shellcheck diagnostics now supplied by bash-language-server
          --null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.sql_formatter.with({
            extra_filetypes = { "sql", "bigquery" },
            extra_args = { "-l", "bigquery" },
          }),
          -- null_ls.builtins.formatting.sqlfluff.with({
          --   extra_filetypes = { "sql", "bigquery" },
          --   args = { "fix", "--disable-progress-bar", "-f", "-n", "-" },
          --   extra_args = { "--dialect", "bigquery" },
          -- }),
          -- null_ls.builtins.diagnostics.sqlfluff.with({
          --   extra_filetypes = { "sql", "bigquery" },
          --   extra_args = { "--dialect", "bigquery" },
          -- }),
          -- null_ls.builtins.formatting.sqlformat,
          -- null_ls.builtins.formatting.sqlfmt,
          require("null-ls-embedded").nls_source.with({
            filetypes = { "markdown", "html", "vue", "lua" },
          }),
        })
      end
    end,
  },
}
