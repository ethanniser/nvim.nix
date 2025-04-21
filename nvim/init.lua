vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if vim.g.neovide then
  require('neovide')
end

if vim.g.vscode then
  require('vscode')
end

require('options')
require('keymaps')
require('commands')
