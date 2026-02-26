vim.g.mapleader = " "

-- plugins
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
})

-- colorscheme
require("github-theme").setup({
	options = { transparent = true },
})
vim.cmd.colorscheme("github_light")

-- treesitter parsers
local ts_parsers = {
	"typescript", "tsx", "javascript", "go", "gomod", "gosum",
	"java", "json", "yaml", "toml",
}
local nts = require("nvim-treesitter")
nts.install(ts_parsers)

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		nts.update()
	end,
})

-- lsp
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"terraformls", "gopls", "ruff", "pyright",
		"lua_ls", "ts_ls",
	},
})
vim.lsp.enable({
	"terraformls", "gopls", "ruff", "pyright",
	"lua_ls", "ts_ls",
})

-- completion + format on save
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
		if client:supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
				end,
			})
		end
	end,
})

-- use system clipboard for yank/paste
vim.o.clipboard = "unnamedplus"

-- d/x/c delete without clobbering yank register
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "x", '"_x')
vim.keymap.set({ "n", "v" }, "X", '"_X')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

-- m = cut (delete + yank, the original d behavior)
vim.keymap.set({ "n", "v" }, "m", "d")
vim.keymap.set("n", "mm", "dd")
vim.keymap.set({ "n", "v" }, "M", "D")

-- inline diagnostics (virtual text), toggle with <leader>i
vim.diagnostic.config({ virtual_text = true })
vim.keymap.set("n", "<leader>i", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
end)

-- statusline
local function statusline()
	local mode_map = {
		n = "NORMAL",
		i = "INSERT",
		v = "VISUAL",
		V = "V-LINE",
		["\22"] = "V-BLOCK",
		c = "COMMAND",
		R = "REPLACE",
		t = "TERMINAL",
		s = "SELECT",
		S = "S-LINE",
		["\19"] = "S-BLOCK",
	}
	local mode = mode_map[vim.fn.mode()] or vim.fn.mode()

	local path = vim.fn.expand("%:~:.")
	if path == "" then path = "[No Name]" end
	local modified = vim.bo.modified and " [+]" or ""

	-- diagnostics (colorised, right side)
	local diag = ""
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	if errors > 0 then diag = diag .. "%#StlError# E:" .. errors end
	if warnings > 0 then diag = diag .. "%#StlWarn# W:" .. warnings end
	if info > 0 then diag = diag .. "%#StlInfo# I:" .. info end
	if hints > 0 then diag = diag .. "%#StlHint# H:" .. hints end
	if diag ~= "" then diag = diag .. "%#StatusLine# " end

	-- lsp server name
	local lsp = ""
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients > 0 then lsp = clients[1].name end

	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	local pct = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)

	return " " .. mode
	    .. "  " .. path .. modified
	    .. "%="
	    .. diag
	    .. " " .. lsp
	    .. "  " .. line .. ":" .. col
	    .. "  " .. pct .. "%%"
	    .. " "
end

_G.statusline = statusline
vim.o.statusline = "%!v:lua.statusline()"
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#d0d0d0", fg = "#444444" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#d8d8d8", fg = "#999999" })
vim.api.nvim_set_hl(0, "StlError", { bg = "#d0d0d0", fg = "#d32f2f", bold = true })
vim.api.nvim_set_hl(0, "StlWarn", { bg = "#d0d0d0", fg = "#e67e00", bold = true })
vim.api.nvim_set_hl(0, "StlInfo", { bg = "#d0d0d0", fg = "#0277bd", bold = true })
vim.api.nvim_set_hl(0, "StlHint", { bg = "#d0d0d0", fg = "#558b2f", bold = true })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#c8c8c8" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#c8c8c8", fg = "#888888" })

-- help: show keybinding cheatsheet in a floating window
vim.keymap.set("n", "<leader><space>", function()
	local help = {
		"── Keybindings ──────────────────────────",
		"",
		"SPC i       toggle inline diagnostics",
		"",
		"── Diagnostics ──────────────────────────",
		"]d / [d     next / prev diagnostic",
		"]e / [e     next / prev error",
		"]w / [w     next / prev warning",
		"",
		"── LSP ──────────────────────────────────",
		"gd          go to definition",
		"gr          references",
		"K           hover docs",
		"grn         rename symbol",
		"gra         code action",
		"",
		"── Format ───────────────────────────────",
		"auto        format on save (LSP)",
	}
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, help)
	vim.bo[buf].modifiable = false
	local width = 45
	local height = #help
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })
	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })
end)
