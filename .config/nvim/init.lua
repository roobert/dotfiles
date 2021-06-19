-- FIXME: move these to shared file
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

g['python3_host_prog'] = os.getenv('HOME')..'/.pyenv/versions/3.9.5/bin/python'

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  api.nvim_command 'packadd packer.nvim'
  require('plugins')

  -- FIXME: what is the point of compile?
  --cmd 'PackerCompile'
  cmd 'PackerInstall'
end

require('plugins')
require('options')
require('colorscheme')
require('bars')
require('commenting')
require('font')
require('highlighting')
require('lsp')
require('mappings')
require('nvim-compe')
require('signature')

-- FIXME this fails if it's in lua/colorize.lua, why?
require'colorizer'.setup()
