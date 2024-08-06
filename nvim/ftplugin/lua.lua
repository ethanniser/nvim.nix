if vim.fn.executable('lua-language-server') ~= 1 then
  vim.notify("Language server for 'lua' - `lua-language-server` not found.", vim.log.levels.WARN)
end
