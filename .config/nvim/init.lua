-- NOTE
-- run:
-- :LspInstall bash css dockerfile go html java json lua python ruby rust terraform typescript vim vue yaml
--
-- set these globals so they can be used throughout our config as shorthand..
api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
opt, wo = vim.opt, vim.wo
fmt = string.format

function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Specify location of python for use with NeoVim
g['python3_host_prog'] = os.getenv('HOME') .. '/.pyenv/versions/3.9.5/bin/python'

-- auto install Packer if it doesn't exist..
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    api.nvim_command 'packadd packer.nvim'
    require('plugins')
    cmd 'PackerInstall'
end

require('spelling')
require('plugins')
require('options')
require('colorscheme')
require('bars')
--require('commenting')
require('font')
require('highlighting')
require('lsp')
require('mappings')
require('completion')
require('signature')
require('lightbulb')
require('tags')
require('linenumbers')

-- FIXME this fails if it's in lua/colorize.lua, why?
require'colorizer'.setup()
