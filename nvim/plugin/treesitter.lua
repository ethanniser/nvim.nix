if not vim.g.vscode then
  -- nvim-treesitter rewrite for Neovim 0.11+
  -- Parsers are installed via Nix, no need for ensure_installed

  -- Enable treesitter highlighting and indentation for all filetypes
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      -- Check if parser exists for this filetype
      local ok = pcall(vim.treesitter.start)
      if ok then
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  -- Treesitter context (sticky context lines at top of screen)
  require('treesitter-context').setup {
    max_lines = 10,
  }
end
