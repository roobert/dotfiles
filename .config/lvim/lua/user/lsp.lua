require("mason-lspconfig").setup({
	ensure_installed = {
		"awk_ls",
		"bashls",
		"cssls",
		"dockerls",
		"gopls",
		"gradle_ls",
		"grammarly",
		"graphql",
		"html",
		"jsonls",
		"tsserver",
		"sumneko_lua",
		"marksman",
		"pyright",
		"pylsp",
		"sqlls",
		"tailwindcss",
		"terraformls",
		"tflint",
		"vuels",
		"yamlls",
	},
})

lvim.lsp.on_attach_callback = function(client, bufnr)
	if client.name == "tailwindcss" then
		require("tailwindcss-colorizer/colorizer").buf_attach(bufnr, { single_column = false, debounce = 500 })
	end
end
