-- NOTE
-- * to debug, run :LspInfo and check ~/.cache/nvim/lsp.log
-- * if anything in this file doesn't work, it breaks everything else..

-- This helps install language servers
require'lspinstall'.setup()

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end

require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"python", "tf", "sh", "asm"},
    settings = {
        languages = {
            asm = {
                {formatCommand = "asmfmt", formatStdin = true}
            },
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

-- FIXME: need some way to toggle diagnostics
--
-- multiple lsps dont play well together..
--require 'lspconfig'.terraformls.setup {
--    cmd = {"terraform-ls", "serve"},
--    filetypes = {"tf"}
--}

-- FIXME: tell lsp to not complain about vim keyword..
--require'lspconfig'.sumneko_lua.setup {
--    -- ... other configs
--    settings = {
--        Lua = {
--            diagnostics = {
--                globals = { 'vim' }
--            }
--        }
--    }
--}

--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--    vim.lsp.diagnostic.on_publish_diagnostics, {
--      -- disable virtual text
--      virtual_text = false;
--
--      -- disable underline
--      underline = false,
--
--      -- disable signs
--       signs = false,
-- 
--      --display_diagnostics = false,
--    }
--  )
--
---- shows on BufWrite for all clients attached to current buffer, where virtual_text is false, but underline and signs default true
--vim.cmd[[autocmd BufWrite <buffer> lua vim.lsp.diagnostic.show_buffer_diagnostics({virtual_text = true})]]

