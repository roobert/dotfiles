-- this is too tightly integrated with telescope..
return {
  "gbprod/yanky.nvim",
  enabled = false,
  dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
  opts = function()
    -- local mapping = require("yanky.telescope.mapping")
    -- local mappings = mapping.get_defaults()
    -- mappings.i["<c-p>"] = nil
    return {
      highlight = { timer = 200 },
      ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
      picker = {
        telescope = {
          use_default_mappings = false,
          -- mappings = mappings,
        },
      },
    }
  end,
}
