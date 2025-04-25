local luasnip = require('luasnip')
luasnip.config.setup {}
require('luasnip.loaders.from_vscode').lazy_load()

local init_lua_path = vim.api.nvim_get_runtime_file('init.lua', true)[0]
local init_lua_absolute_path = vim.fn.fnamemodify(init_lua_path, ':p') -- Get absolute path
local init_lua_dir = vim.fn.fnamemodify(init_lua_absolute_path, ':h') -- Get the directory
local snippet_dir = init_lua_dir .. '/nvim/snippets'
print(snippet_dir)

require('luasnip.loaders.from_vscode').lazy_load {
  paths = { snippet_dir },
}
