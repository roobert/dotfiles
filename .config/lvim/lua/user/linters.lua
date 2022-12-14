local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "flake8", filetypes = { "python" } },
	{ command = "shellcheck", extra_args = { "--severity", "warning" } },
	{ command = "codespell", filetypes = { "javascript", "python" } },
})
