local harpoon = require('harpoon')
harpoon:setup {
  settings = {
    key = function()
      local cwd = vim.loop.cwd()
      local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')

      -- If we're not in a git repo or command failed, just use cwd
      if vim.v.shell_error ~= 0 or branch == '' then
        return cwd
      end

      -- Combine cwd and branch for the key
      return cwd .. ':' .. branch
    end,
  },
}

vim.keymap.set('n', '<leader>ha', function()
  harpoon:list():add()
end, { desc = 'Add file to harpoon' })
vim.keymap.set('n', '<leader>hv', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'View harpoon' })

vim.keymap.set('n', '<leader>hh', function()
  harpoon:list():select(1)
end, { desc = 'View harpoon:1' })
vim.keymap.set('n', '<leader>hj', function()
  harpoon:list():select(2)
end, { desc = 'View harpoon:2' })
vim.keymap.set('n', '<leader>hk', function()
  harpoon:list():select(3)
end, { desc = 'View harpoon:3' })
vim.keymap.set('n', '<leader>hl', function()
  harpoon:list():select(4)
end, { desc = 'View harpoon:4' })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<leader>hp', function()
  harpoon:list():prev()
end, { desc = 'View harpoon prev' })
vim.keymap.set('n', '<leader>hn', function()
  harpoon:list():next()
end, { desc = 'View harpoon next' })
