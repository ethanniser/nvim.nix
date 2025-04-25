require('nvim-treesitter.configs').setup {
  -- Nix installs everything
  ensure_installed = {},
  sync_install = false,
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true },
}
require('treesitter-context').setup {
  enable = false,
  max_lines = 1,
  trim_scope = 'inner',
}
