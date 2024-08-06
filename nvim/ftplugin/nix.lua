if vim.fn.executable('nil') ~= 1 then
  vim.notify("Language server for 'nix' - `nil` not found.", vim.log.levels.WARN)
end
