return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- NOTE: codespell can update code to be incorrect!
      --["*"] = { "codespell" },
      ["markdown"] = { "prettierd_or_prettier" },
      ["markdown.mdx"] = { "prettierd_or_prettier" },

      ["javascript"] = { "dprint" },
      ["javascriptreact"] = { "dprint" },
      ["typescript"] = { "dprint" },
      ["typescriptreact"] = { "dprint" },

      ["python"] = { "isort", "black" },

      ["sh"] = { "shfmt" },
      ["bash"] = { "shfmt" },
      ["zsh"] = { "shfmt" },

      ["lua"] = { "stylua" },
      ["go"] = { "gofmt" },
      ["rust"] = { "rustfmt" },

      ["sql"] = { "sql_formatter" },
      ["bigquery"] = { "sql_formatter_bq" },

      ["html"] = { "prettierd_or_prettier" },
      ["vue"] = { "prettierd_or_prettier" },
      ["css"] = { "prettierd_or_prettier" },
      ["scss"] = { "prettierd_or_prettier" },
      ["json"] = { "prettierd_or_prettier" },
      ["yaml"] = { "prettierd_or_prettier" },
      ["toml"] = { "prettierd_or_prettier" },

      ["terraform"] = { "terraform_fmt" },
    },
    formatters = {
      sql_formatter_bq = {
        command = "sql-formatter",
        args = { "-l", "bigquery" },
      },
      dprint = {
        condition = function(ctx)
          return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        end,
      },
      prettierd = {
        -- No external config reference
      },
      prettier = {
        -- No external config reference
        args = { 
          "--stdin-filepath", 
          "$FILENAME", 
        },
      },
      prettierd_or_prettier = {
        command = vim.fn.executable("prettierd") == 1 and "prettierd" or "prettier",
        args = function(self, ctx)
          if self.command == "prettierd" then
            return { "$FILENAME" }
          else
            return { 
              "--stdin-filepath", 
              "$FILENAME", 
            }
          end
        end,
      },
    },
  },
}
