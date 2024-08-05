vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if vim.g.neovide then
  require('neovide')
end

require('options')
require('keymaps')
require('commands')
