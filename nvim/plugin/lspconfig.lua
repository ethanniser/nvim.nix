if not vim.g.vscode then
  vim.diagnostic.config { update_in_insert = false }

  local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
      return vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs { '*', '.*' } do
      local match = vim.fn.glob(vim.fs.joinpath(workspace or '', pattern, 'pyvenv.cfg'))
      if match ~= '' then
        return vim.fs.joinpath(vim.fs.dirname(match), 'bin', 'python')
      end
    end

    -- Fallback to system Python.
    return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
  end

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP Specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

  -- Default configuration for all LSP servers (merged with nvim-lspconfig's lsp/*.lua configs)
  vim.lsp.config('*', {
    capabilities = capabilities,
    root_markers = { '.git' },
  })

  -- Server-specific overrides (nvim-lspconfig provides base configs in lsp/ directory)
  -- Only need to specify settings/overrides here, not cmd/filetypes/root_markers

  -- Lua - custom settings for Neovim development
  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = true,
        },
        format = {
          enable = false,
        },
      },
    },
  })

  -- Python - custom pythonPath resolution
  vim.lsp.config('pyright', {
    before_init = function(_, config)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = get_python_path(config.root_dir)
    end,
  })

  -- Haskell - extensive HLS settings
  vim.lsp.config('hls', {
    settings = {
      haskell = {
        formattingProvider = 'fourmolu',
        maxCompletions = 40,
        plugin = {
          alternateNumberFormat = {
            globalOn = true,
          },
          cabal = {
            codeActionsOn = true,
            completionOn = true,
            diagnosticsOn = true,
          },
          cabalFmt = {
            config = {
              path = 'cabal-fmt',
            },
          },
          cabalGild = {
            config = {
              path = 'cabal-gild',
            },
          },
          callHierarchy = {
            globalOn = true,
          },
          changeTypeSignature = {
            globalOn = true,
          },
          class = {
            codeActionsOn = true,
            codeLensOn = true,
          },
          eval = {
            globalOn = true,
            config = {
              diff = true,
              exception = false,
            },
          },
          explicitFields = {
            globalOn = true,
          },
          explicitFixity = {
            globalOn = true,
          },
          fourmolu = {
            config = {
              external = true,
              path = '/Users/ethan/.cabal/bin/fourmolu',
            },
          },
          gadt = {
            globalOn = true,
          },
          ghcideCodeActionsBindings = {
            globalOn = true,
          },
          ghcideCodeActionsFillHoles = {
            globalOn = true,
          },
          ghcideCodeActionsImportsExports = {
            globalOn = true,
          },
          ghcideCodeActionsTypeSignatures = {
            globalOn = true,
          },
          ghcideCompletions = {
            globalOn = true,
            config = {
              autoExtendOn = true,
              snippetsOn = true,
            },
          },
          ghcideHoverAndSymbols = {
            hoverOn = true,
            symbolsOn = true,
          },
          ghcideTypeLenses = {
            globalOn = true,
            config = {
              mode = 'always',
            },
          },
          hlint = {
            codeActionsOn = true,
            diagnosticsOn = true,
            config = {
              flags = {},
            },
          },
          importLens = {
            codeActionsOn = true,
            codeLensOn = true,
          },
          moduleName = {
            globalOn = true,
          },
          ormolu = {
            config = {
              external = false,
            },
          },
          overloadedRecordDot = {
            globalOn = true,
          },
          pragmasCompletion = {
            globalOn = true,
          },
          pragmasDisable = {
            globalOn = true,
          },
          pragmasSuggest = {
            globalOn = true,
          },
          qualifyImportedNames = {
            globalOn = true,
          },
          rename = {
            globalOn = true,
            config = {
              crossModule = false,
            },
          },
          retrie = {
            globalOn = true,
          },
          semanticTokens = {
            globalOn = false,
            config = {
              classMethodToken = 'method',
              classToken = 'class',
              dataConstructorToken = 'enumMember',
              functionToken = 'function',
              moduleToken = 'namespace',
              operatorToken = 'operator',
              patternSynonymToken = 'macro',
              recordFieldToken = 'property',
              typeConstructorToken = 'enum',
              typeFamilyToken = 'interface',
              typeSynonymToken = 'type',
              typeVariableToken = 'typeParameter',
              variableToken = 'variable',
            },
          },
          splice = {
            globalOn = true,
          },
          stan = {
            globalOn = false,
          },
        },
      },
    },
  })

  -- Enable all LSP servers (nvim-lspconfig provides configs in lsp/ directory)
  vim.lsp.enable({
    'vtsls',
    'biome',
    'eslint',
    'lua_ls',
    'nil_ls',
    'rust_analyzer',
    'zls',
    'astro',
    'pyright',
    'tailwindcss',
    'clangd',
    'hls',
  })

  -- Bind the `lsp_signature` to the LSP servers. This has to be called after the
  -- setup of LSPs.
  local signature_opts = {
    bind = true,
    floating_window = true,
    handler_opts = { border = 'rounded' },
    hint_enable = false,
    wrap = false,
    hi_parameter = 'Search',
  }
  require('lsp_signature').setup(signature_opts)

  -- Toggle diagnostics. We keep track of the toggling state.
  local show_diagnostics = true
  local function toggle_diagnostics()
    show_diagnostics = not show_diagnostics
    vim.diagnostic.enable(show_diagnostics)

    if show_diagnostics then
      vim.notify('Diagnostics activated.')
    else
      vim.notify('Diagnostics hidden.')
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

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      -- Opens a popup that displays documentation about the word under your cursor
      --  See `:help K` for why this keymap
      map('K', vim.lsp.buf.hover, 'Hover Documentation')

      -- THE FOLLOWING ARE ALL SET IN SNACK FILE
      -- -- Rename the variable under your cursor
      -- --  Most Language Servers support renaming across files, etc.
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- -- Toggle diagnostics
      -- map('<leader>ld', toggle_diagnostics, 'Toggle [D]iagnostics')
      --
      -- -- Jump to the type of the word under your cursor.
      -- --  Useful when you're not sure what type a variable is and you want to see
      -- --  the definition of its *type*, not where it was *defined*.
      -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      --
      -- -- Jump to the definition of the word under your cursor.
      -- --  This is where a variable was first declared, or where a function is defined, etc.
      -- --  To jump back, press <C-T>.
      -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      --
      -- -- Find references for the word under your cursor.
      -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      --
      -- -- Jump to the implementation of the word under your cursor.
      -- --  Useful when your language has ways of declaring types without an actual implementation.
      -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      --
      -- -- Fuzzy find all the symbols in your current document.
      -- --  Symbols are things like variables, functions, types, etc.
      -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      --
      -- -- Fuzzy find all the symbols in your current workspace
      -- --  Similar to document symbols, except searches over your whole project.
      -- --  TODO: blocked by leader w for save
      -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
      --
      --
      -- -- WARN: This is not Goto Definition, this is Goto Declaration.
      -- --  For example, in C this would take you to the header
      -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

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
end
