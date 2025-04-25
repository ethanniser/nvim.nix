require('nvim-treesitter.configs').setup {
  -- Nix installs everything
  ensure_installed = {},
  sync_install = false,
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true },
}
