-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of help_tags options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

local t = require('telescope')
-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')

local add_zoxide = function(file_path)
  vim.fn.system { 'zoxide', 'add', file_path }
end

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
t.setup {
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  --
  -- defaults = {
  --   mappings = {
  --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --   },
  -- },
  -- pickers = {}
  extensions = {
    zoxide = {
      mappings = {
        default = {
          action = function(selection)
            vim.cmd.edit(selection.path)
            add_zoxide(selection.path)
          end,
          after_action = function(selection)
            print('Directory changed to ' .. selection.path)
          end,
        },
        ['<C-s>'] = {
          action = function(selection)
            vim.cmd.split(selection.path)
            add_zoxide(selection.path)
          end,
        },
        ['<C-v>'] = {
          action = function(selection)
            vim.cmd.vsplit(selection.path)
            add_zoxide(selection.path)
          end,
        },
        ['<C-e>'] = {
          action = function(selection)
            vim.cmd.edit(selection.path)
            add_zoxide(selection.path)
          end,
        },
        ['<C-b>'] = {
          keepinsert = true,
          action = function(selection)
            vim.cmd('e ' .. selection.path)
            add_zoxide(selection.path)
          end,
        },
        ['<C-f>'] = {
          keepinsert = true,
          action = function(selection)
            builtin.find_files { cwd = selection.path }
            add_zoxide(selection.path)
          end,
        },
        ['<C-t>'] = {
          action = function(selection)
            vim.cmd.tcd(selection.path)
            add_zoxide(selection.path)
          end,
        },
      },
    },
  },
}

-- Enable telescope extensions, if they are installed
pcall(t.load_extension, 'fzf') -- telescope-fzf-native.nvim
pcall(t.load_extension, 'ui-select') -- telescope-ui-select.nvim
pcall(t.load_extension, 'helpgrep') -- telescope-helpgrep.nvim
pcall(t.load_extension, 'lazygit') -- lazygit.nvim
pcall(t.load_extension, 'zoxide') -- telescope-zoxide

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>shg', require('telescope-helpgrep').live_grep, { desc = '[S]earch [H]elp [G]rep' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sr', t.extensions.lazygit.lazygit, { desc = '[S]earch [R]epositories' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- Also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-- Shortcut for searching your neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath('config') }
end, { desc = '[S]earch [N]eovim files' })

-- zoxide
vim.keymap.set('n', '<leader>cd', t.extensions.zoxide.list, { desc = '[C]hange [D]irectory' })
