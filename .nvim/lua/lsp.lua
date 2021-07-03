-- NOTE
-- * run:
--    :LspInstall bash css dockerfile go html java json lua  \
--      python ruby rust terraform typescript vim vue yaml
-- * to debug, run :LspInfo and check ~/.cache/nvim/lsp.log
-- * to print installed language servers:
--    :lua vim.inspect(require'lspinstall'.installed_servers()))
--
-- install language servers
require'lspinstall'.setup()

-- setup all installed language servers
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
    require'lspconfig'[server].setup {}
end

-- this will fail until `:LspInstall lua` has been run
require'lspconfig'.lua.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim', 'api', 'cmd', 'fn', 'map', 'opt', 'wo', 'fmt'},
                disable = {"lowercase-global"}
            }
        }
    }
})

local asmFormat = {formatCommand = "asmfmt", formatStdin = true}

local pythonBlack = {formatCommand = "black -q -", formatStdin = true}
local pythonISort = {formatCommand = "isort -q -", formatStdin = true}

local terraformFormat = {formatCommand = "terraform fmt -", formatStdin = true}

local shellcheck = {
    LintCommand = 'shellcheck -f gcc -x',
    lintFormats = {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'}
}

local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}

local luaFormat = {
    formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-keep-simple-control-block-one-line --column-limit 120",
    formatStdin = true
}

require"lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"python", "tf", "asm", "sh", "lua"},
    settings = {
        languages = {
            asm = {asmFormat},
            python = {pythonBlack, pythonISort},
            tf = {terraformFormat},
            lua = {luaFormat},
            sh = {shellcheck, shfmt}
        }
    }
}

--  Correct filetype for Terraform files..
vim.cmd [[autocmd BufRead,BufNewFile *.tf set filetype=tf | set commentstring=#\ %s]]

-- Format-on-write
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()]]

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--    -- disable virtual text
--    virtual_text = false,
--
--    -- disable underline
--    underline = false,
--
--    -- disable signs
--    signs = false
--
--    -- display_diagnostics = false,
-- })
