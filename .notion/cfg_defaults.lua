--
-- Notion default settings
--

dopath("cfg_notioncore")
dopath("cfg_kludges")
dopath("cfg_layouts")

dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
dopath("mod_statusbar")
dopath("mod_sp")
dopath("mod_xrandr")

-- refresh xinerama on screen layout updates
function screenlayoutupdated()
    mod_xinerama.refresh()
end

randr_screen_change_notify_hook = ioncore.get_hook('randr_screen_change_notify')

if randr_screen_change_notify_hook ~= nil then
    randr_screen_change_notify_hook:add(screenlayoutupdated)
end
-- $Id$

XTERM="xterm"
--XTERM="mlterm"
--XTERM="urxvt"

-- TODO: trim and inline these
--dopath("cfg_notioncore")
--dopath("mod_tiling")






if not gr.select_engine("de") then
	return
end

de.reset()


-- font = "xft: Sans-8"

-- mainfont = "xft: Sans-8"
-- boldfont = "xft: Sans-8:weight=bold"
-- bigfont = "xft: Sans-14"
-- bigboldfont = "xft: Sans-14:weight=bold"

de.defstyle("*", {
	background_colour = "#000",
	foreground_colour = "#777",
	
	shadow_pixels = 0,
	highlight_pixels = 0,
	padding_pixels = 0,
	spacing = 0,
	
--	font = "-*-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*",
-- font = "fixed",
--font = "Ubuntu Mono",

font = "-misc-ubuntu-medium-r-normal--12-0-0-0-p-0-iso10646-1",

--	font = "xft: Ubuntu-14",
	font = "xft: ubuntu mono-12",

	text_align = "center",
})

de.defstyle("tab", {
	de.substyle("inactive-selected", {
--		foreground_colour = "#666",
	}),

	de.substyle("active-selected", {
		foreground_colour = "#fff",
	}),
})

de.defstyle("frame", {
	transparent_background = false,

	padding_pixels = 2,
	shadow_pixels = 1,
	highlight_pixels = 1,

	de.substyle("inactive", {
		highlight_colour = "#222",
		shadow_colour    = "#222",
	}),

	de.substyle("active", {
		highlight_colour = "#fff",
		shadow_colour    = "#fff",
	}),
})

-- statusbar stuff
de.defstyle("stdisp", {
    de.substyle("normal", {
        foreground_colour = "#777",
    }),

    de.substyle("important", {
        foreground_colour = "green",
    }),

    de.substyle("critical", {
        foreground_colour = "red",
    }),
})

-- Define some additional title shortening rules to use when the full
-- title doesn't fit in the available space. The first-defined matching 
-- rule that succeeds in making the title short enough is used.
ioncore.defshortening("(.*) - Mozilla(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("(.*) - Mozilla", "$1$|$1$<...")
ioncore.defshortening("XMMS - (.*)", "$1$|...$>$1")
ioncore.defshortening("[^:]+: (.*)(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("[^:]+: (.*)", "$1$|$1$<...")
ioncore.defshortening("(.*)(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("(.*)", "$1$|$1$<...")

-- Refresh objects' brushes.
gr.refresh()

