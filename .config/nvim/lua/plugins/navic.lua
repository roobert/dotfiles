-- FIXME:
-- * replace with: https://github.com/Bekaboo/dropbar.nvim
return {
  "SmiteshP/nvim-navic",
  lazy = true,
  init = function()
    vim.g.navic_silence = true
    require("lazyvim.util").lsp.on_attach(function(client, buffer)
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, buffer)
      end
    end)
  end,
  opts = function()
    return {
      separator = " ",
      highlight = true,
      depth_limit = 0,
      icons = require("lazyvim.config").icons.kinds,
    }
  end,
}
