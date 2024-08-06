require('mini.notify').setup {
  window = {
    -- Move window to bottom right
    config = function()
      local cols = vim.o.columns
      local lines = vim.o.lines
      return {
        width = math.floor(cols * 0.382),
        height = 3, -- You can adjust this value as needed
        anchor = 'SE',
        col = cols - 1,
        row = lines - 2,
        border = 'single',
        zindex = 999,
        style = 'minimal',
      }
    end,
  },
}
