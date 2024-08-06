vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.test = 1

if vim.g.neovide then
  require('neovide')
end

require('options')
require('keymaps')
require('commands')
