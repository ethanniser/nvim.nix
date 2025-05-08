if not vim.g.vscode then
  require('lsp_signature').setup {
    toggle_key = '<M-x>',
  }
end
