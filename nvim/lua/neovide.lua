-- Config
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.4
vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

vim.o.guifont = 'MesloLGS Nerd Font:h14'
-- General clipboard mappings using Command key
vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save file in normal mode
vim.keymap.set('v', '<D-c>', '"+y') -- Copy selection to system clipboard in visual mode

-- Paste from system clipboard using Command key across different modes
vim.keymap.set('n', '<D-v>', '"+P') -- Paste after cursor in normal mode
vim.keymap.set('v', '<D-v>', '"+P') -- Paste after selection in visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste into command-line
vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste into insert mode, maintaining position
vim.keymap.set('', '<D-v>', '+p<CR>', { noremap = true, silent = true }) -- Paste in modes not explicitly mapped
vim.keymap.set('!', '<D-v>', '<C-R>+', { noremap = true, silent = true }) -- Paste in command-line mode (alternative/redundant but kept)
vim.keymap.set('t', '<D-v>', '<C-R>+', { noremap = true, silent = true }) -- Paste into terminal mode

-- Dynamically change scale
vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set('n', '<C-=>', function()
  change_scale_factor(1.10)
end)
vim.keymap.set('n', '<C-->', function()
  change_scale_factor(1 / 1.10)
end)
