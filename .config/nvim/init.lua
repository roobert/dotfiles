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
					if vim.g.autoformat ~= false then
						vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
					end
				end,
			})
		end
	end,
})

-- toggle auto-format
vim.keymap.set("n", "<leader><S-f>", function()
	vim.g.autoformat = vim.g.autoformat == false
	vim.notify("Auto-format: " .. (vim.g.autoformat and "on" or "off"))
end)

-- use system clipboard for yank/paste
vim.o.clipboard = "unnamedplus"
vim.o.showmode = false

-- navigate splits with Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- cycle buffers with Shift+h/l
vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")

-- open splits with Space+hjkl
vim.keymap.set("n", "<leader>h", "<cmd>leftabove vsplit<CR>")
vim.keymap.set("n", "<leader>l", "<cmd>rightbelow vsplit<CR>")
vim.keymap.set("n", "<leader>k", "<cmd>leftabove split<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>rightbelow split<CR>")

-- jump to buffer by name
vim.keymap.set("n", "<leader>b", ":b ")

-- show LSP capabilities for current buffer
vim.keymap.set("n", "<leader><S-l>", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached")
		return
	end
	local methods = {
		{ "textDocument/formatting", "formatting" },
		{ "textDocument/rangeFormatting", "range formatting" },
		{ "textDocument/completion", "completion" },
		{ "textDocument/hover", "hover" },
		{ "textDocument/definition", "go to definition" },
		{ "textDocument/references", "references" },
		{ "textDocument/rename", "rename" },
		{ "textDocument/codeAction", "code action" },
		{ "textDocument/publishDiagnostics", "diagnostics" },
		{ "textDocument/signatureHelp", "signature help" },
		{ "textDocument/documentSymbol", "document symbols" },
	}
	local lines = { "── LSP Clients (" .. vim.bo.filetype .. ") ──────────────" }
	for _, c in ipairs(clients) do
		table.insert(lines, "")
		table.insert(lines, c.name)
		for _, m in ipairs(methods) do
			local icon = c:supports_method(m[1]) and "  ✓ " or "  · "
			table.insert(lines, icon .. m[2])
		end
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	local width = 42
	local height = #lines
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
	vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
end)

-- close split
vim.keymap.set("n", "<leader>c", "<C-w>q")

-- maximise split (close all others)
vim.keymap.set("n", "<leader>m", "<C-w>o")

-- equalize split sizes
vim.keymap.set("n", "<leader>=", "<C-w>=")


-- code action (fix)
vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action)

-- close buffer, keep split open
vim.keymap.set("n", "<leader>x", function()
	local buf = vim.api.nvim_get_current_buf()
	local last = #vim.fn.getbufinfo({ buflisted = 1 }) == 1
	if last then
		vim.cmd("enew")
	else
		vim.cmd("bprev")
	end
	local ok, err = pcall(vim.cmd, "bdelete " .. buf)
	if not ok then
		vim.api.nvim_set_current_buf(buf)
		vim.api.nvim_err_writeln(err:match("Vim%(.-%):(.*)") or err)
	end
end)

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

-- diagnostics list, toggle with <leader>d
local function qf_is_open()
	return #vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix") > 0
end

vim.keymap.set("n", "<leader>d", function()
	if qf_is_open() then
		vim.cmd("cclose")
	else
		vim.diagnostic.setqflist()
	end
end)

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		if qf_is_open() then
			vim.diagnostic.setqflist({ open = false })
		end
	end,
})

-- statusline
local function statusline()
	local winid = vim.g.statusline_winid
	local bufnr = vim.api.nvim_win_get_buf(winid)

	local path = vim.fn.bufname(bufnr)
	path = path ~= "" and vim.fn.fnamemodify(path, ":~:.") or "[No Name]"
	local modified = vim.bo[bufnr].modified and " [+]" or ""

	-- diagnostics (colorised, right side)
	local diag = ""
	local errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })
	if errors > 0 then diag = diag .. "%#StlError# E:" .. errors end
	if warnings > 0 then diag = diag .. "%#StlWarn# W:" .. warnings end
	if info > 0 then diag = diag .. "%#StlInfo# I:" .. info end
	if hints > 0 then diag = diag .. "%#StlHint# H:" .. hints end
	if diag ~= "" then diag = diag .. "%#StatusLine# " end

	-- lsp server names + capabilities
	local lsp = ""
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local parts = {}
	for _, c in ipairs(clients) do
		local caps = {}
		if c:supports_method("textDocument/formatting") then caps[#caps + 1] = "f" end
		if c:supports_method("textDocument/publishDiagnostics") then caps[#caps + 1] = "d" end
		if c:supports_method("textDocument/codeAction") then caps[#caps + 1] = "a" end
		if c:supports_method("textDocument/rename") then caps[#caps + 1] = "r" end
		if c:supports_method("textDocument/completion") then caps[#caps + 1] = "c" end
		local name = c.name
		if #caps > 0 then name = name .. "[" .. table.concat(caps) .. "]" end
		parts[#parts + 1] = name
	end
	lsp = table.concat(parts, " ")

	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	local pct = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)

	return " " .. path .. modified
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
		"── Splits ───────────────────────────────",
		"SPC h/j/k/l open split in direction",
		"C-h/j/k/l  navigate between splits",
		"SPC c       close split",
		"SPC m       maximise (close others)",
		"SPC =       equalize split sizes",
		"",
		"── Buffers ──────────────────────────────",
		"S-h / S-l   prev / next buffer",
		"SPC b       jump to buffer by name",
		"SPC x       close buffer (keep split)",
		"",
		"── LSP ──────────────────────────────────",
		"gd          go to definition",
		"gr          references",
		"K           hover docs",
		"grn         rename symbol",
		"SPC f       code action (fix)",
		"SPC L       show LSP capabilities",
		"",
		"── Diagnostics ──────────────────────────",
		"]d / [d     next / prev diagnostic",
		"]e / [e     next / prev error",
		"]w / [w     next / prev warning",
		"SPC i       toggle inline diagnostics",
		"SPC d       toggle diagnostics list",
		"SPC F       toggle auto-format on save",
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
