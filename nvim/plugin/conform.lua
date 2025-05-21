if not vim.g.vscode then
  require('conform').setup {
    -- notify_on_error = false,
    format_on_save = function(bufnr)
      -- disabled with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier', 'biome' },
      typescript = { 'prettierd', 'prettier', 'biome' },
      javascriptreact = { 'prettierd', 'prettier', 'biome' },
      typescriptreact = { 'prettierd', 'prettier', 'biome' },
      json = { 'prettier' },
      nix = { 'alejandra' },
      just = { 'just' },
      python = { 'ruff_format' },
      haskell = { 'fourmolu' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
    },
  }
end
