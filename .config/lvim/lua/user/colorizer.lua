-- from: https://github.com/ChristianChiarulli/lvim/blob/master/lua/user/colorizer.lua
local ok, colorizer = pcall(require, "colorizer")
if not ok then
  return
end

colorizer.setup {
  filetypes = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "css",
    "html",
    "astro",
    "lua",
  },
  user_default_options = {
    rgb_fn = true,
    tailwind = "both",
  },
  buftypes = {
    -- '*', -- seems like this doesn't work with the float window, but works with the other `buftype`s.
    -- Not sure if the window has a `buftype` at all
  },
}
