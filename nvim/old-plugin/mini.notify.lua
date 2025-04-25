require('mini.notify').setup {
  window = {
    -- Move window to bottom right
    config = function()
      local lines = vim.o.lines
      return {
        anchor = 'SE',
        row = lines - 2,
      }
    end,
  },
}
