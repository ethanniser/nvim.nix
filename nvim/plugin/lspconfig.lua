local lspconfig = require("lspconfig")

vim.diagnostic.config({ update_in_insert = false })

-- Load LSP servers. Only load them if they're available.


-- Typescript
if vim.fn.executable("tsserver") == 1 then
	lspconfig["tsserver"].setup({})
end


-- Lua
if vim.fn.executable("lua-language-server") then
	lspconfig["lua_ls"].setup({
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim).
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global.
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
					-- Remove annoying popup when editing standalone lua files.
					checkThirdParty = false,
				},
				telemetry = {
					enable = true, -- That's fine.
				},
				format = {
					enable = false,
				},
			},
		},
	})
end


-- Nix
if vim.fn.executable("nil") == 1 then
	lspconfig["nil_ls"].setup({})
end

-- Bind the `lsp_signature` to the LSP servers. This has to be called after the
-- setup of LSPs.
local signature_opts = {
	bind = true,
	floating_window = true,
	handler_opts = { border = "rounded" },
	hint_enable = false,
	wrap = false,
	hi_parameter = "Search",
}
require("lsp_signature").setup(signature_opts)

-- Toggle diagnostics. We keep track of the toggling state.
local show_diagnostics = true
local function toggle_diagnostics()
	show_diagnostics = not show_diagnostics
	vim.diagnostic.enable(show_diagnostics)

	if show_diagnostics then
		vim.notify("Diagnostics activated.")
	else
		vim.notify("Diagnostics hidden.")
	end
end

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-T>.
      map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

      -- Find references for the word under your cursor.
      map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

      -- Fuzzy find all the symbols in your current workspace
      --  Similar to document symbols, except searches over your whole project.
      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- Rename the variable under your cursor
      --  Most Language Servers support renaming across files, etc.
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      -- Opens a popup that displays documentation about the word under your cursor
      --  See `:help K` for why this keymap
      map('K', vim.lsp.buf.hover, 'Hover Documentation')

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Toggle diagnostics
      map('<leader>ld', toggle_diagnostics, 'Toggle [D]iagnostics')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })