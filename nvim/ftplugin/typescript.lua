-- Exit if the language server isn't available
if vim.fn.executable('tsserver') ~= 1 then
  vim.notify("Language server for 'typescript' - `tsserver` not found.", vim.log.levels.WARN)
  return
end

local root_files = {
  'tsconfig.json',
  'package.json',
  '.git',
}

vim.lsp.start {
  name = 'ts_ls',
  cmd = { 'tsserver' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
}
