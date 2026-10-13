local M = {}

local RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, MUTED = 1, 2, 3, 4, 5, 6, 8

local function slots()
  local light = vim.o.background == 'light'
  return {
    base = light and 15 or 0,
    surface = light and 7 or 0,
  }
end

local function highlights()
  local s = slots()
  return {
    Normal = {},
    NormalFloat = {},
    FloatBorder = { ctermfg = MUTED },
    FloatTitle = { bold = true },
    Cursor = { reverse = true },
    CursorLine = { ctermbg = s.surface },
    CursorColumn = { ctermbg = s.surface },
    ColorColumn = { ctermbg = s.surface },
    CursorLineNr = { bold = true },
    LineNr = { ctermfg = MUTED },
    SignColumn = {},
    FoldColumn = { ctermfg = MUTED },
    Folded = { ctermfg = MUTED, ctermbg = s.surface },
    NonText = { ctermfg = MUTED },
    EndOfBuffer = { ctermfg = s.base },
    Whitespace = { ctermfg = MUTED },
    WinSeparator = { ctermfg = MUTED },
    StatusLine = {},
    StatusLineNC = { ctermfg = MUTED },
    TabLine = { ctermfg = MUTED, ctermbg = s.surface },
    TabLineFill = { ctermbg = s.surface },
    TabLineSel = { bold = true },
    WinBar = { bold = true },
    WinBarNC = { ctermfg = MUTED },
    Visual = { ctermfg = s.base, ctermbg = BLUE },
    Search = { ctermfg = s.base, ctermbg = YELLOW },
    IncSearch = { ctermfg = s.base, ctermbg = MAGENTA },
    CurSearch = { link = 'IncSearch' },
    Substitute = { link = 'IncSearch' },
    MatchParen = { ctermbg = s.surface, bold = true },
    Pmenu = { ctermbg = s.surface },
    PmenuSel = { ctermfg = s.base, ctermbg = BLUE },
    PmenuSbar = { ctermbg = s.surface },
    PmenuThumb = { ctermbg = MUTED },
    PmenuMatch = { ctermfg = BLUE, bold = true },
    QuickFixLine = { ctermbg = s.surface, bold = true },
    Directory = { ctermfg = BLUE },
    Title = { ctermfg = YELLOW, bold = true },
    ErrorMsg = { ctermfg = RED },
    WarningMsg = { ctermfg = YELLOW },
    ModeMsg = { bold = true },
    MoreMsg = { ctermfg = GREEN },
    Question = { ctermfg = GREEN },
    SpellBad = { undercurl = true },
    SpellCap = { undercurl = true },
    SpellLocal = { undercurl = true },
    SpellRare = { undercurl = true },

    Comment = { ctermfg = MUTED },
    Constant = { ctermfg = MAGENTA },
    String = { ctermfg = GREEN },
    Character = { link = 'String' },
    Number = { link = 'Constant' },
    Boolean = { link = 'Constant' },
    Float = { link = 'Constant' },
    Identifier = {},
    Function = { ctermfg = YELLOW },
    Statement = { ctermfg = BLUE },
    Keyword = { ctermfg = BLUE },
    Operator = {},
    PreProc = { ctermfg = BLUE },
    Type = { ctermfg = MAGENTA },
    Special = { ctermfg = CYAN },
    Delimiter = {},
    Underlined = { ctermfg = BLUE, underline = true },
    Todo = { ctermfg = YELLOW, bold = true },
    Error = { ctermfg = RED },
    ['@variable'] = {},
    ['@markup.heading'] = { link = 'Title' },
    ['@markup.link.url'] = { ctermfg = BLUE, underline = true },
    ['@markup.raw'] = { ctermfg = MAGENTA },

    DiffAdd = { ctermfg = GREEN },
    DiffDelete = { ctermfg = RED },
    DiffChange = { ctermbg = s.surface },
    DiffText = { ctermfg = YELLOW, ctermbg = s.surface, bold = true },
    Added = { ctermfg = GREEN },
    Removed = { ctermfg = RED },
    Changed = { ctermfg = YELLOW },
    GitSignsAdd = { ctermfg = GREEN },
    GitSignsDelete = { ctermfg = RED },
    GitSignsChange = { ctermfg = YELLOW },
    GitSignsStagedAdd = { ctermfg = GREEN },
    GitSignsStagedDelete = { ctermfg = RED },
    GitSignsStagedChange = { ctermfg = YELLOW },

    DiagnosticError = { ctermfg = RED },
    DiagnosticWarn = { ctermfg = YELLOW },
    DiagnosticInfo = { ctermfg = BLUE },
    DiagnosticHint = { ctermfg = CYAN },
    DiagnosticOk = { ctermfg = GREEN },
    DiagnosticUnderlineError = { undercurl = true },
    DiagnosticUnderlineWarn = { undercurl = true },
    DiagnosticUnderlineInfo = { undercurl = true },
    DiagnosticUnderlineHint = { undercurl = true },
    LspInlayHint = { ctermfg = MUTED },
    LspReferenceText = { ctermbg = s.surface },
    LspReferenceRead = { ctermbg = s.surface },
    LspReferenceWrite = { ctermbg = s.surface },

    TelescopeNormal = { link = 'NormalFloat' },
    TelescopeBorder = { link = 'FloatBorder' },
    TelescopeTitle = { bold = true },
    TelescopePromptCounter = { ctermfg = MUTED },
    TelescopeSelection = { ctermbg = s.surface, bold = true },
    TelescopeSelectionCaret = { link = 'TelescopeSelection' },
    TelescopeMatching = { ctermfg = BLUE, bold = true },
  }
end

function M.apply()
  vim.cmd.highlight('clear')
  if vim.g.syntax_on == 1 then
    vim.cmd.syntax('reset')
  end
  vim.g.colors_name = 'terminal'
  for group, spec in pairs(highlights()) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  for i = 0, 15 do
    vim.g['terminal_color_' .. i] = nil
  end
end

function M.lualine()
  local section = { fg = 'NONE', bg = 'NONE' }
  local mode = { a = section, b = section, c = section, x = section, y = section, z = section }
  return { normal = mode, insert = mode, visual = mode, replace = mode, command = mode, inactive = mode }
end

function M.setup()
  vim.o.termguicolors = false
  vim.cmd.colorscheme('terminal')
end

return M
