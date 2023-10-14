return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      ["markdown"] = { { "prettierd", "prettier" }, "proselint", "alex", "write_good" },
      ["markdown.mdx"] = { { "prettierd", "prettier" }, "proselint", "alex", "write_good" },

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

      ["html"] = { "prettierd", "prettier" },
      ["vue"] = { "prettierd", "prettier" },
      ["css"] = { "prettierd", "prettier" },
      ["scss"] = { "prettierd", "prettier" },
      ["json"] = { "prettierd", "prettier" },
      ["yaml"] = { "prettierd", "prettier" },
      ["toml"] = { "prettierd", "prettier" },
    },
    formatters = {
      sql_formatter_bq = {
        command = "sql-formatter",
        args = { "--dialect", "bigquery" },
      },
      dprint = {
        condition = function(ctx)
          return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
