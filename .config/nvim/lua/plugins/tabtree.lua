-- tab navigation jumping between significant code elements, such as brackets, quotes, etc.
return {
  "roobert/tabtree.nvim",
  config = function()
    require("tabtree").setup()
  end,
}
