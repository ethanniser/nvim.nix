if vim.fn.executable('tsserver') ~= 1 then
  vim.notify("Language server for 'typescript' - `tsserver` not found.", vim.log.levels.WARN)
end