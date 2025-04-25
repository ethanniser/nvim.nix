-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- [[ General UI and Appearance ]]

-- Make line numbers default
vim.opt.number = true
-- Show relative line numbers next to the current line number
vim.opt.relativenumber = true

-- Don't show the current mode (like INSERT or NORMAL)
vim.opt.showmode = false

-- Always show the signcolumn, even if there are no signs (like diagnostics or git indicators)
vim.opt.signcolumn = 'yes'

-- Enable 24-bit color support for richer syntax highlighting and UI
vim.opt.termguicolors = true

-- Show visual indicators for certain whitespace characters
vim.opt.list = true
-- Define the characters to use for visualizing tabs, trailing spaces, and non-breaking spaces
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Highlight the line where the cursor is currently positioned
vim.opt.cursorline = true

-- Set the minimum number of lines to keep visible above and below the cursor when scrolling
vim.opt.scrolloff = 10

-- [[ Editing Behavior ]]

-- Maintain the indentation of the previous line when inserting a new line
vim.opt.breakindent = true

-- Enable saving the undo history to a file so it persists between Neovim sessions
vim.opt.undofile = true

-- Decrease the time in milliseconds before swap files are written to disk
vim.opt.updatetime = 250
-- Set the time in milliseconds to wait for a key sequence to complete a mapped command
vim.opt.timeoutlen = 300

-- Show the results of a substitution command (like `:s`) in real-time as you type
vim.opt.inccommand = 'split'

-- [[ Tabs ]]

-- Set the number of spaces displayed for a tab character
vim.opt.tabstop = 2
-- Set the number of spaces used for a soft tab (when pressing Tab in Insert mode)
vim.opt.softtabstop = 2
-- Convert tabs to spaces when inserting them
vim.opt.expandtab = true
-- Automatically indent new lines based on the indentation of the previous line
vim.opt.smartindent = true
-- Set the number of spaces used for each step of indentation
vim.opt.shiftwidth = 2
-- Maintain the indentation of the previous line when inserting a new line (duplicate of breakindent)
vim.opt.breakindent = true
-- Set the string to display at the beginning of a wrapped line when breakindent is used
vim.opt.showbreak = '>>>>>'

-- [[ Navigation and Interaction ]]

-- Enable mouse support for interacting with Neovim, including resizing windows and selecting text
vim.opt.mouse = 'a'

-- Open new vertical splits to the right of the current window
vim.opt.splitright = true
-- Open new horizontal splits below the current window
vim.opt.splitbelow = true

-- [[ Search ]]

-- Ignore case when searching, unless the search pattern contains an uppercase letter or `\C`
vim.opt.ignorecase = true
-- Use case-sensitive searching if the search pattern contains an uppercase letter
vim.opt.smartcase = true

-- Highlight search matches as you type the search pattern
vim.opt.incsearch = true
-- Highlight all occurrences of the last search pattern
vim.opt.hlsearch = true

-- Configure how the completion menu is displayed (show menu, show only one if possible, don't pre-select an option)
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- [[ Clipboard ]]

-- Sync Neovim's unnamed registers with the system clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Set fold settings
-- These options were reccommended by nvim-ufo
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration

-- Set the width of the foldcolumn (where fold indicators are shown) to 0, effectively hiding it
vim.opt.foldcolumn = '0'
-- Enable code folding
vim.opt.foldenable = true
-- Set the default fold level (higher means more folds are open by default)
vim.opt.foldlevel = 99
-- Set the fold level when starting to edit a file (higher means more folds are open initially)
vim.opt.foldlevelstart = 99
-- Set the maximum depth of nested folds
vim.opt.foldnestmax = 5
-- Set the text displayed for a closed fold (empty string means no text is displayed)
vim.opt.foldtext = ''

-- Configure the appearance of the cursor in different modes
vim.opt.guicursor = {
  'n-v-c:block', -- Normal, visual, command-line modes: block cursor
  'i-ci-ve:ver25', -- Insert, command-line insert, visual-exclude modes: vertical bar cursor with 25% width
  'r-cr:hor20', -- Replace, command-line replace modes: horizontal bar cursor with 20% height
  'o:hor50', -- Operator-pending mode: horizontal bar cursor with 50% height
  'a:blinkwait700-blinkoff400-blinkon250', -- All modes: blinking settings (wait 700ms, off 400ms, on 250ms)
  'sm:block-blinkwait175-blinkoff150-blinkon175', -- Showmatch mode: block cursor with specific blinking settings (wait 175ms, off 150ms, on 175ms)
}

-- Enable virtual text for diagnostics on the current line
vim.diagnostic.config { virtual_lines = { current_line = true } }
