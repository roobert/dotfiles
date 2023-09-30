return {
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
}
