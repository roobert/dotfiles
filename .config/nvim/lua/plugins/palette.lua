return {
  dir = "/Users/rw/git/palette.nvim",
  name = "palette",
  lazy = false,
  priority = 1000,
  config = function()
    require("palette").setup({
      caching = true,
      palettes = {
        -- built in colorscheme: grey
        main = "dark",
        -- main = "starfield",
        -- main = "light",
        -- main = "dark",
        -- built in accents: pastel, bright, dark
        -- accent = "dark",
        -- state = "dark",
      },

      italics = true,
      transparent_background = false,

      custom_palettes = {
        main = {
          -- dusk theme taken from roobert/dust.nvim
          dust_dusk = {
            color0 = "#121527",
            color1 = "#1A1E39",
            color2 = "#232A4D",
            color3 = "#3E4D89",
            color4 = "#687BBA",
            color5 = "#A4B1D6",
            color6 = "#bdbfc9",
            color7 = "#DFE5F1",
            color8 = "#e9e9ed",
          },

          starfield = {
            color0 = "#191d33",
            color1 = "#1A1E39",
            color2 = "#2E3453",
            color3 = "#5f78a3",
            color4 = "#D7A64A",
            color5 = "#DFE5F1",
            color6 = "#bdbfc9",
            color7 = "#979ca6",
            color8 = "#F4F5F7",
          },

          -- a dark slate-grey theme, based off the built-in dark palette
          slate_grey = vim.tbl_extend(
            "force",
            require("palette.generator").generate_colors(require("palette.colors").main["dark"], "#232A4D"),
            -- override background and cursor-line
            {
              color0 = "#191d33",
              color1 = "#1A1E39",
            }
          ),

          -- a light grey theme, based off the built-in light palette
          slate_blue_day = vim.tbl_extend(
            "force",
            require("palette.generator").generate_colors(require("palette.colors").main["light"], "#d7dfe5"),
            -- override background and cursor-line
            {
              color0 = "#e9e9ed",
              color1 = "#d3d4db",
            }
          ),

          -- a blue theme, based off the built-in dark palette
          team_zissou = vim.tbl_extend(
            "force",
            require("palette.generator").generate_colors(require("palette.colors").main["dark"], "#04213b"),
            {
              -- override background and cursor-line
              color0 = "#191d33",
              color1 = "#1A1E39",
              -- override most prominent colors (strings, etc.)
              color7 = "#e9e9ed",
              color8 = "#d3d4db",
            }
          ),
        },
        accent = {
          starfield = {
            accent0 = "#C72139",
            accent1 = "#E26137",
            accent2 = "#D7A64A",
            accent3 = "#7ED64A",
            accent4 = "#4A87D7",
            accent5 = "#8B4AD7",
            accent6 = "#A14AD7",
          },
        },
        state = {
          starfield = {
            error = "#C72139",
            warning = "#E26137",
            hint = "#D7A64A",
            ok = "#7ED64A",
            info = "#4A87D7",
          },
        },
      },
    })
    vim.cmd([[colorscheme palette]])
  end,
}
