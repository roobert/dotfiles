-- {
--   "lukas-reineke/indent-blankline.nvim",
--   branch = "v3",
--   event = { "BufReadPost", "BufNewFile" },
--   config = function()
--     require("ibl").setup({
--       indent = { char = "│" },
--       scope = {
--         exclude = {
--           "help",
--           "alpha",
--           "dashboard",
--           "neo-tree",
--           "Trouble",
--           "lazy",
--           "mason",
--           "notify",
--           "toggleterm",
--           "lazyterm",
--         },
--       },
--       whitespace = {
--         remove_blankline_trail = false,
--       },
--     })
--   end,
-- },
return {}