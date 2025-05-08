if not vim.g.vscode then
  local dap = require('dap')
  local dapui = require('dapui')

  dapui.setup()

  -- Set Breakpoint 'sign' to bright red B
  vim.fn.sign_define('DapBreakpoint', { text = 'B', texthl = 'ErrorMsg', linehl = '', numhl = '' })

  -- Basic debugging keymaps, feel free to change to your liking!
  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
  end, { desc = 'Debug: Set Breakpoint' })
  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
end
