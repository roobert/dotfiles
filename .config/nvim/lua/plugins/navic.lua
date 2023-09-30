return {
  "SmiteshP/nvim-navic",
  -- NOTE: disabled!
  enabled = false,
  lazy = true,
  init = function()
    vim.g.navic_silence = true
    require("lazyvim.util").on_attach(function(client, buffer)
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, buffer)
      end
    end)
  end,
  opts = function()
    return {
      separator = " ",
      highlight = true,
      -- FIXME: this doesn't work properly..
      -- NOTE: change to 1 so we only see filename.
      -- use treesitter-context instead for breadcrumbs..
      depth_limit = 1,
      icons = require("lazyvim.config").icons.kinds,
    }
  end,
}
