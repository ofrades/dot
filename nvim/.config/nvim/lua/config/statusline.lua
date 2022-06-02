-- one statusline to rule them all
-- vim.opt.laststatus = 3

-- vim.opt.statusline = '%#Pmenu#    %m %r %w %= %< %{FugitiveHead()} |  Ln %l, Col %c  %{&fileencoding?&fileencoding:&encoding}  '
--
-- %<                                             trim from here
-- %{fugitive#head()}                             name of the current branch (needs fugitive.vim)
-- %f                                             path+filename
-- %m                                             check modifi{ed,able}
-- %r                                             check readonly
-- %w                                             check preview window
-- %=                                             left/right separator
-- %l/%L,%c                                       rownumber/total,colnumber
-- %{&fileencoding?&fileencoding:&encoding}       file encoding

local function lsp()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError# " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation# " .. count["info"]
  end

  return errors .. warnings .. hints .. info
end

local function getfilename()
  if vim.api.nvim_win_get_width(0) < 100 then
    return " %<%t "
  end
  return " %<%f "
end

local function getBranch()
  if vim.api.nvim_win_get_width(0) < 160 then
    return ""
  end
  return " %{FugitiveHead()} "
end

Statusline = {}

local function holidays()
  -- return "🔥" -- winter
  -- return "🐰" -- easter
  -- return "🌼" -- spring
  return "🌻" -- summer
  -- return "🍁" -- autumn
  -- return "🎄" -- christmas
end

Statusline.active = function()
  return table.concat {
    holidays(),
    " %#PmenuSel# ",
    " ",
    getfilename(),
    "%m",
    "%#Normal#",
    "%=",
    lsp(),
    getBranch()
  }
end


function Statusline.inactive()
  return table.concat {
    "%#Pmenu# ",
    " ",
    getfilename(),
  }
end

vim.api.nvim_exec([[
	augroup Statusline
	au!
	au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
	au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
	augroup END
]], false)
