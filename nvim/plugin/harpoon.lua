local harpoon = require('harpoon')
harpoon:setup {}

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

-- basic telescope configuration
local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set('n', '<leader>ht', function()
  toggle_telescope(harpoon:list())
end, { desc = 'Open harpoon in telescope' })
