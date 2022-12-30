--[[
Read more about this config: https://roobert.github.io/2022/12/03/Extending-Neovim/

# Reset the state
rm -rf ~/.local/share/lunarvim
]]

reload("user.globals")
reload("user.plugins")
reload("user.options")
reload("user.bindings")
reload("user.formatters")
reload("user.linters")
reload("user.treesitter")
reload("user.lsp")
