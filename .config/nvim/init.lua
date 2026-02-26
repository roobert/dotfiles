-- transparent background
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  end,
})
vim.cmd.colorscheme("default")

-- plugins
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- treesitter parsers
local ts_parsers = {
  "typescript", "tsx", "javascript", "go", "gomod", "gosum",
  "java", "json", "yaml", "toml",
}
local nts = require("nvim-treesitter")
nts.install({ parsers = ts_parsers, quiet = true })

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function()
    nts.update()
  end,
})

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
