-- null-ls permits running linters/formatters that are not LSP based
return {
  "nvimtools/none-ls.nvim",
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
}
