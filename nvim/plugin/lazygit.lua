vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Open lazygit' })

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Set lazygit project root when opening a new buffer',
  group = vim.api.nvim_create_augroup('lazygit-set-root', { clear = true }),
  callback = function()
    require('lazygit.utils').project_root_dir()
  end,
})
