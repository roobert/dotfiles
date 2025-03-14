-- Mason ensures dependencies are installed
return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      --"alex",
      "awk-language-server",
      "bash-language-server",
      "black",
      --"codespell",
      "dockerfile-language-server",
      "dot-language-server",
      "eslint-lsp",
      "html-lsp",
      "htmlbeautifier",
      "isort",
      "jq",
      "jq-lsp",
      "markdownlint",
      --"misspell",
      "prettier",
      --"proselint",
      -- prefer ruff and pyright
      -- "python-lsp-server",
      "shellcheck",
      "shfmt",
      "sql-formatter",
      "sqlfluff",
      "sqlfmt",
      "sqlls",
      "stylua",
      "svelte-language-server",
      "vue-language-server",
      --"write-good",
      "yq",
    },
  },
}
