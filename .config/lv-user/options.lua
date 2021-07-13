-- FIXME: these are ignored

vim.opt.listchars = {
  tab = "→ ",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
  space = "␣",
}

-- Undo setting from lunarvim - wrapping cursor movement across lines
vim.cmd "set whichwrap=b,s"
vim.cmd "set iskeyword+=_"
