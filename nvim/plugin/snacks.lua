local snacks = require('snacks')

snacks.setup {
  bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  -- explorer = { enabled = true },
  indent = { enabled = true, animate = { enabled = false } },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  -- scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = {
    notification = {
      -- wo = { wrap = true } -- Wrap notifications
    },
  },
}

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' '
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Top Pickers & Explorer
vim.keymap.set('n', '<leader><space>', function()
  snacks.picker.smart()
end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>,', function()
  snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function()
  snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>:', function()
  snacks.picker.command_history()
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>n', function()
  snacks.picker.notifications()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>e', function()
  snacks.explorer()
end, { desc = 'File Explorer' })

-- find
vim.keymap.set('n', '<leader>fb', function()
  snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fc', function()
  snacks.picker.files { cwd = vim.fn.stdpath('config') }
end, { desc = 'Find Config File' })
vim.keymap.set('n', '<leader>ff', function()
  snacks.picker.files()
end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', function()
  snacks.picker.git_files()
end, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fp', function()
  snacks.picker.projects()
end, { desc = 'Projects' })
vim.keymap.set('n', '<leader>fr', function()
  snacks.picker.recent()
end, { desc = 'Recent' })

-- git
vim.keymap.set('n', '<leader>gb', function()
  snacks.picker.git_branches()
end, { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gl', function()
  snacks.picker.git_log()
end, { desc = 'Git Log' })
vim.keymap.set('n', '<leader>gL', function()
  snacks.picker.git_log_line()
end, { desc = 'Git Log Line' })
vim.keymap.set('n', '<leader>gs', function()
  snacks.picker.git_status()
end, { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gS', function()
  snacks.picker.git_stash()
end, { desc = 'Git Stash' })
vim.keymap.set('n', '<leader>gd', function()
  snacks.picker.git_diff()
end, { desc = 'Git Diff (Hunks)' })
vim.keymap.set('n', '<leader>gf', function()
  snacks.picker.git_log_file()
end, { desc = 'Git Log File' })

-- Grep
vim.keymap.set('n', '<leader>sb', function()
  snacks.picker.lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sB', function()
  snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
vim.keymap.set('n', '<leader>sg', function()
  snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function()
  snacks.picker.grep_word()
end, { desc = 'Visual selection or word' })

-- search
vim.keymap.set('n', '<leader>s"', function()
  snacks.picker.registers()
end, { desc = 'Registers' })
vim.keymap.set('n', '<leader>s/', function()
  snacks.picker.search_history()
end, { desc = 'Search History' })
vim.keymap.set('n', '<leader>sa', function()
  snacks.picker.autocmds()
end, { desc = 'Autocmds' })
vim.keymap.set('n', '<leader>sb', function()
  snacks.picker.lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sc', function()
  snacks.picker.command_history()
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>sC', function()
  snacks.picker.commands()
end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>sd', function()
  snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sD', function()
  snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sh', function()
  snacks.picker.help()
end, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sH', function()
  snacks.picker.highlights()
end, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>si', function()
  snacks.picker.icons()
end, { desc = 'Icons' })
vim.keymap.set('n', '<leader>sj', function()
  snacks.picker.jumps()
end, { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sk', function()
  snacks.picker.keymaps()
end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sl', function()
  snacks.picker.loclist()
end, { desc = 'Location List' })
vim.keymap.set('n', '<leader>sm', function()
  snacks.picker.marks()
end, { desc = 'Marks' })
vim.keymap.set('n', '<leader>sM', function()
  snacks.picker.man()
end, { desc = 'Man Pages' })
vim.keymap.set('n', '<leader>sp', function()
  snacks.picker.lazy()
end, { desc = 'Search for Plugin Spec' })
vim.keymap.set('n', '<leader>sq', function()
  snacks.picker.qflist()
end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>sR', function()
  snacks.picker.resume()
end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>su', function()
  snacks.picker.undo()
end, { desc = 'Undo History' })
vim.keymap.set('n', '<leader>uC', function()
  snacks.picker.colorschemes()
end, { desc = 'Colorschemes' })

-- LSP
vim.keymap.set('n', 'gd', function()
  snacks.picker.lsp_definitions()
end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function()
  snacks.picker.lsp_declarations()
end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function()
  snacks.picker.lsp_references()
end, { nowait = true, desc = 'References' })
vim.keymap.set('n', 'gI', function()
  snacks.picker.lsp_implementations()
end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function()
  snacks.picker.lsp_type_definitions()
end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', '<leader>ss', function()
  snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function()
  snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })

-- Other
vim.keymap.set('n', '<leader>z', function()
  snacks.zen()
end, { desc = 'Toggle Zen Mode' })
vim.keymap.set('n', '<leader>Z', function()
  snacks.zen.zoom()
end, { desc = 'Toggle Zoom' })
vim.keymap.set('n', '<leader>.', function()
  snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function()
  snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>n', function()
  snacks.notifier.show_history()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>bd', function()
  snacks.bufdelete()
end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>cR', function()
  snacks.rename.rename_file()
end, { desc = 'Rename File' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function()
  snacks.gitbrowse()
end, { desc = 'Git Browse' })
vim.keymap.set('n', '<leader>gg', function()
  snacks.lazygit()
end, { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>un', function()
  snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })
vim.keymap.set('n', '<c-/>', function()
  snacks.terminal()
end, { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<c-_>', function()
  snacks.terminal()
end, { desc = 'which_key_ignore' })
vim.keymap.set({ 'n', 't' }, ']]', function()
  snacks.words.jump(vim.v.count1)
end, { desc = 'Next Reference' })
vim.keymap.set({ 'n', 't' }, '[[', function()
  snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev Reference' })
vim.keymap.set('n', '<leader>N', function()
  snacks.win {
    file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = 'yes',
      statuscolumn = ' ',
      conceallevel = 3,
    },
  }
end, { desc = 'Neovim News' })

-- Setup some globals for debugging (lazy-loaded)
_G.dd = function(...)
  snacks.debug.inspect(...)
end
_G.bt = function()
  snacks.debug.backtrace()
end
vim.print = _G.dd -- Override print to use snacks for `:=` command

-- Create some toggle mappings
snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
snacks.toggle.diagnostics():map('<leader>ud')
snacks.toggle.line_number():map('<leader>ul')
snacks.toggle
  .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
  :map('<leader>uc')
snacks.toggle.treesitter():map('<leader>uT')
snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
snacks.toggle.inlay_hints():map('<leader>uih')
snacks.toggle.indent():map('<leader>ug')
snacks.toggle.dim():map('<leader>uD')

snacks
  .toggle({
    name = 'Treesitter Context',
    get = function()
      local tsc = require('treesitter-context')
      return tsc.enabled
    end,
    set = function(state)
      local tsc = require('treesitter-context')
      if state then
        tsc.enable()
      else
        tsc.disable()
      end
    end,
  })
  :map('<leader>ut', { desc = 'Toggle Treesitter Context' })

snacks
  .toggle({
    name = 'Highlight Colors',
    get = function()
      local hc = require('nvim-highlight-colors')
      return hc.is_active()
    end,
    set = function(state)
      local hc = require('nvim-highlight-colors')
      if state then
        hc.turnOn()
      else
        hc.turnOff()
      end
    end,
  })
  :map('<leader>uh', { desc = 'Toggle Highlight Colors' })
