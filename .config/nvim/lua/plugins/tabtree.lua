-- tab navigation jumping between significant code elements, such as brackets, quotes, etc.
return {
  "roobert/tabtree.nvim",
  -- dir = "/Users/rw/git/tabtree.nvim",
  -- name = "tabtree",
  config = function()
    require("tabtree").setup()
  end,
}
