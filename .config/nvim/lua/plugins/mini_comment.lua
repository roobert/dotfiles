return {
  "echasnovski/mini.comment",
  -- set priority to ensure <leader>/ overrides telescope live_grep binding..
  priority = 100,
  event = "VeryLazy",
  opts = {
    options = {
      custom_commentstring = function()
        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      end,
    },
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = "<leader>/",

      -- Toggle comment on current line
      comment_line = "<leader>/",

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      textobject = "gc",
    },
  },
}
