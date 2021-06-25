-- NOTE
-- * to debug, run :LspInfo and check ~/.cache/nvim/lsp.log
-- * if anything in this file doesn't work, it breaks everything else..

require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"python", "tf", "sh"},
    settings = {
        languages = {
            python = {
                {formatCommand = "black -q -", formatStdin = true}
            },
            python = {
                {formatCommand = "isort -q -", formatStdin = true}
            },
            tf = {
                {formatCommand = "terraform fmt -", formatStdin = true}
            },
            -- FIXME: this doesn't work..
            --sh = {
            --      lintCommand = "shellcheck -f gcc -x -",
            --      lintStdin = true,
            --      lintFormats = {"%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m"},
            --      lintSource = "shellcheck"
            --}
        }
    }
}

vim.cmd [[autocmd BufRead,BufNewFile *.tf set filetype=tf | set commentstring=#\ %s]]

-- FIXME this seems to be ignored, sometimes??
vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()"

require'lspconfig'.bashls.setup{}
require'lspconfig'.pyright.setup{}


-- multiple lsps dont play well together..
--require 'lspconfig'.terraformls.setup {
--    cmd = {"terraform-ls", "serve"},
--    filetypes = {"tf"}
--}

