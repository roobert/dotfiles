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

-- urxvt is broken on my work machine..? https://bugs.launchpad.net/ubuntu/+source/compiz/+bug/861268
XTERM="xterm"
BROWSER="chromium-browser"
BROWSER_SECRET="chromium-browser --user-data-dir=~/.chromium-noproxy --incognito"
MUSIC="spotify"

-- for some reason need this as well as the stuff below to disable F12..
defbindings("WScreen", {
    kpress(ALTMETA.."F12", nil),
})

defbindings("WMPlex.toplevel", {
    kpress(ALTMETA.."F1", nil),
    kpress(ALTMETA.."F2", nil),
    kpress(ALTMETA.."F3", nil),
    kpress(ALTMETA.."F4", nil),
    kpress(ALTMETA.."F5", nil),
    kpress(ALTMETA.."F6", nil),
    kpress(ALTMETA.."F7", nil),
    kpress(ALTMETA.."F8", nil),
    kpress(ALTMETA.."F9", nil),
    kpress(ALTMETA.."F10", nil),
    kpress(ALTMETA.."F11", nil),
    kpress(META.."F1", nil),
    kpress(META.."F2", nil),
    kpress(META.."F3", nil),
    kpress(META.."F4", nil),
    kpress(META.."F5", nil),
    kpress(META.."F6", nil),
    kpress(META.."F7", nil),
    kpress(META.."F8", nil),
    kpress(META.."F9", nil),
    kpress(META.."F10", nil),
    kpress(META.."F11", nil),
    kpress(META.."F12", nil),
    kpress(ALTMETA.."L", nil),
    kpress(META.."L", nil),
})

defbindings("WScreen", {
    kpress(META.."F2", "notioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),
    kpress(META.."F3", "mod_query.query_exec(_)"),
    kpress(META.."F4", "notioncore.exec_on(_, MUSIC or 'x-music')"),
    kpress(META.."F5", "notioncore.exec_on(_, BROWSER or 'x-browser')"),
    kpress(META.."F6", "notioncore.exec_on(_, BROWSER_SECRET or 'x-browser-secret')"),
    kpress(META.."F9", "ioncore.create_ws(_)"),
    kpress(META.."F11", "ioncore.restart()"),
    kpress(META.."F12", "mod_query.query_menu(_, _sub, 'mainmenu', 'Main menu:')"),

    bdoc("Lock screen"),
    kpress(META.."F7", "notioncore.exec_on(_, notioncore.lookup_script('notion-lock'))"),

    kpress("XF86AudioPlay", "notioncore.exec('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause')"),
    kpress("XF86AudioNext", "notioncore.exec('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next')"),
    kpress("XF86AudioPrev", "notioncore.exec('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous')"),

    --kpress("XF86AudioRaiseVolume", "notioncore.exec('amixer set Master 5%+')"),
    --kpress("XF86AudioLowerVolume", "notioncore.exec('amixer set Master 5%-')"),
    kpress("XF86AudioRaiseVolume", "notioncore.exec('~/bin/pavol.sh plus')"),
    kpress("XF86AudioLowerVolume", "notioncore.exec('~/bin/pavol.sh minus')"),

    kpress("XF86AudioMute", "notioncore.exec('amixer -D pulse set Master 1+ toggle')"),
})

if not gr.select_engine("de") then return end

de.reset()

de.defstyle("*", {
	background_colour = "#222",
	foreground_colour = "#777",
	shadow_pixels     = 0,
	highlight_pixels  = 0,
	padding_pixels    = 0,
	spacing           = 0,
  font              = "-misc-ubuntu-medium-r-normal--12-0-0-0-p-0-iso10646-1",
	font              = "xft: ubuntu mono-12",
	text_align        = "center",
})

de.defstyle("tab", {
    de.substyle("inactive-selected", {
		background_colour = "#222",
    }),
    de.substyle("inactive-unselected", {
		background_colour = "#222",
    }),
    de.substyle("active-unselected", {
		background_colour = "#222",
    }),

	de.substyle("active-selected", {
		foreground_colour = "#fff",
		background_colour = "#333",
	}),
    text_align = "center",
})

de.defstyle("frame", {
	transparent_background = false,

	padding_pixels   = 2,
	shadow_pixels    = 1,
	highlight_pixels = 1,

	de.substyle("inactive", {
		highlight_colour = "#222",
		shadow_colour    = "#222",
	}),

	de.substyle("active", {
		highlight_colour = "#333",
		shadow_colour    = "#333",
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
ioncore.defshortening("[^:]+: (.*)(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("[^:]+: (.*)", "$1$|$1$<...")
ioncore.defshortening("(.*)(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("(.*)", "$1$|$1$<...")

-- Refresh objects' brushes.
gr.refresh()
