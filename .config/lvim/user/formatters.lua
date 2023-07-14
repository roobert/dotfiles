-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { command = "black",         filetypes = { "python" } },
  { command = "isort",         filetypes = { "python" } },
  { command = "shfmt",         filetypes = { "sh" } },
  { command = "terraform_fmt", filtypes = { "terraform" } },
  {
    command = "prettier",
    extra_args = { "--print-with", "100" },
    filetypes = { "typescript", "typescriptreact" },
  },
  { command = "gofmt",     filetypes = { "go" } },
  { command = "goimports", filetypes = { "go" } },
  -- FIXME:
  -- { command = "goimports_reviser", filetypes = { "go" }} },
  {
    command = "sql_formatter",
    extra_args = { "-l", "bigquery" },
    filetypes = { "bigquery" },
  },
})
