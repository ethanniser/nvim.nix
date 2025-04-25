require('oil').setup {
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
    is_always_hidden = function(name, _)
      return name == '..' or name == '.git'
    end,
  },
  win_options = {
    wrap = true,
  },
  float = {
    padding = 5,
  },
}

vim.keymap.set('n', '-', '<cmd>Oil --float<cr>', { desc = 'Open parent directory' })

vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions.type == 'move' then
      require('snacks').rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})
