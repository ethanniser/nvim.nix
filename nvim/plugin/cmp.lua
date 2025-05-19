if not vim.g.vscode then
  -- See `:help cmp`
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = { completeopt = 'menu,menuone,noinsert' },
    formatting = {
      format = require('nvim-highlight-colors').format,
    },

    -- For an understanding of why these mappings were
    -- chosen, you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    mapping = cmp.mapping.preset.insert {
      ['<Down>'] = cmp.mapping.select_next_item(),
      ['<Up>'] = cmp.mapping.select_prev_item(),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- scroll up preview
      ['<C-d>'] = cmp.mapping.scroll_docs(4), -- scroll down preview

      --  This will auto-import if your LSP supports it.
      --  This will expand snippets if the LSP sent a snippet.
      ['<Enter>'] = cmp.mapping.confirm { select = true },

      -- Manually trigger a completion from nvim-cmp.
      --  Generally you don't need this, because nvim-cmp will display
      --  completions whenever it has completion options available.
      ['<W-Esc>'] = cmp.mapping.complete {}, -- TODO: this doesnt work...

      -- Think of <c-n> as moving to the right of your snippet expansion.
      --  So if you have a snippet that's like:
      --  function $name($args)
      --    $body
      --  end
      --
      -- <c-n> will move you to the right of each of the expansion locations.
      -- <c-p> is similar, except moving you backwards.
      ['<C-n>'] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { 'i', 's' }),
      ['<C-p>'] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp', group_index = 1 }, -- lsp
      { name = 'buffer', max_item_count = 5, group_index = 2 }, -- text within current buffer
      { name = 'path', max_item_count = 3, group_index = 3 }, -- file system paths
      { name = 'luasnip', max_item_count = 3, group_index = 5 }, -- snippets
    },
  }
end
