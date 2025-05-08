if not vim.g.vscode then
  local wk = require('which-key')

  wk.add {
    { '<leader>f', group = 'Find' },
    { '<leader>g', group = 'Git' },
    { '<leader>s', group = 'Search' },
    { 'g', group = 'Goto/LSP' },
    { '<leader>u', group = 'Toggle' },
    { '<leader>h', group = 'Harpoon' },
    { '<leader>c', group = 'Code' },
  }
end
