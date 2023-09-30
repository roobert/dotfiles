return {
  dir = "/Users/rw/git/palette.nvim",
  name = "palette",
  lazy = false,
  priority = 1000,
  config = function()
    require("palette").setup({
      caching = true,
      palettes = {
        -- main = "dark",
        -- main = "light",
        -- main = "desert",
        -- main = "forest",
        --
        -- built in accents: pastel, bright, dark
        accent = "pastel",
        -- accent = "dark",
        -- accent = "bright",
        state = "pastel",
        -- state = "dark",
        -- state = "bright",
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

          -- FIXME:
          desert = {
            color0 = "#2b2a2a",
            color1 = "#454545",
            color2 = "#3E372A",
            color3 = "#8A794D",
            color4 = "#CCB488",
            color5 = "#DFE5F1",
            color6 = "#91939F",
            color7 = "#959795",
            color8 = "#F4F5F7",
          },

          forest = {
            color0 = "#2b2a2a",
            color1 = "#454545",
            color2 = "#3c5f2a",
            color3 = "#678359",
            color4 = "#93a689",
            color5 = "#DFE5F1",
            color6 = "#91939F",
            color7 = "#bec9b8",
            color8 = "#F4F5F7",
          },

          ocean = {
            color0 = "#070f03",
            color1 = "#0f1f07",
            color2 = "#3c5f2a",
            color3 = "#678359",
            color4 = "#93a689",
            color5 = "#DFE5F1",
            color6 = "#91939F",
            color7 = "#bec9b8",
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
        accent = {},
        state = {},
      },
      custom_highlights = {
        {
          "LineNr",
          "#454545",
          nil,
        },
      },
    })
    vim.cmd([[colorscheme palette]])
  end,
}
