local dashboard = require('alpha.themes.dashboard')
local alpha = require('alpha')
local logo = [[

   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 

    ]]

local function getGreeting(name)
  local tableTime = os.date('*t')
  local datetime = os.date(' %Y-%m-%d   %H:%M')
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = '  Good morning',
    [2] = '  Good afternoon',
    [3] = '󰖔  Good evening',
  }
  local greetingIndex = 0
  if hour >= 3 and hour < 12 then
    greetingIndex = 1
  elseif hour >= 12 and hour < 18 then
    greetingIndex = 2
  elseif hour >= 18 or hour < 3 then
    greetingIndex = 3
  end
  return datetime .. '\t' .. greetingsTable[greetingIndex] .. ', ' .. name
end

local userName = 'Ethan'
local greeting = getGreeting(userName)
local seperator_height = 2

-- Define and set highlight groups for each logo line
vim.api.nvim_set_hl(0, 'AlphaHeaderLogo', { fg = '#7AA2F7' }) -- Light blue
vim.api.nvim_set_hl(0, 'AlphaHeaderName', { fg = '#7AA2F7' }) -- Light blue
dashboard.section.header.type = 'group'
dashboard.section.header.val = {
  {
    type = 'text',
    val = '   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
    opts = { hl = 'AlphaHeaderLogo', shrink_margin = false, position = 'center' },
  },
  {
    type = 'text',
    val = '   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
    opts = { hl = 'AlphaHeaderLogo', shrink_margin = false, position = 'center' },
  },
  {
    type = 'text',
    val = '   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
    opts = { hl = 'AlphaHeaderLogo', shrink_margin = false, position = 'center' },
  },
  {
    type = 'text',
    val = '   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
    opts = { hl = 'AlphaHeaderLogo', shrink_margin = false, position = 'center' },
  },
  {
    type = 'text',
    val = '   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
    opts = { hl = 'AlphaHeaderLogo', shrink_margin = false, position = 'center' },
  },
  {
    type = 'text',
    val = '   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
    opts = { hl = 'AlphaHeaderLogo', shrink_margin = false, position = 'center' },
  },
  {
    type = 'padding',
    val = seperator_height,
  },
  {
    type = 'text',
    val = greeting,
    opts = { hl = 'AlphaHeaderName', shrink_margin = false, position = 'center' },
  },
}
dashboard.section.buttons.val = {}
dashboard.section.footer.val = {}

-- Calculate padding for vertical centering
local footer_height = 1
local header_height = #vim.split(logo, '\n')
local padding = math.floor((vim.o.lines - (footer_height + header_height + seperator_height)) / 2)

-- Add padding elements
dashboard.config.layout = {
  { type = 'padding', val = padding },
  dashboard.section.header,
  { type = 'padding', val = padding },
}

alpha.setup(dashboard.opts)
