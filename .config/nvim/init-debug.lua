local root = vim.fn.expand("$HOME") .. "/.config/nvim/debug/install-root"
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

local plugins = {
  {
    --"roobert/action-hints.nvim",
    dir = root .. "/data/nvim/lazy/action-hints.nvim",
    config = function()
      require("action-hints").setup({
        use_virtual_text = true,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", opts = true },
    opts = { ensure_installed = { "pyright" } },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      require("lspconfig")["pyright"].setup({})
    end,
  },
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup(plugins)

vim.lsp.set_log_level("debug")
