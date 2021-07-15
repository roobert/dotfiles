--META="Mod1+"
--MOD1="Mod1+"

--XTERM="kitty"
--BROWSER="google-chrome"

--SCREENLOCK="bash -c 'sleep 1; xset dpms force off'; dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock"

--defbindings("WIonWS", {
--    bdoc("Split current frame vertically."),
--    kpress(MOD1.."V", "WIonWS.split_at(_, _sub, 'bottom', true)"),
--
--    bdoc("Split current frame horizontally."),
--    kpress(MOD1.."H", "WIonWS.split_at(_, _sub, 'right', true)"),
--    
--    bdoc("Destroy current frame."),
--    kpress(MOD1.."Tab", "WIonWS.unsplit_at(_, _sub)"),
--
--    bdoc("Go to frame above/below/right/left of current frame."),
--    kpress(MOD2.."Up", "WIonWS.goto_dir(_, 'above')"),
--    kpress(MOD2.."Down", "WIonWS.goto_dir(_, 'below')"),
--    kpress(MOD2.."Right", "WIonWS.goto_dir(_, 'right')"),
--    kpress(MOD2.."Left", "WIonWS.goto_dir(_, 'left')"),
--    submap(MOD1.."K", {
--        bdoc("Split current frame horizontally."),
--        kpress("S", "WIonWS.split_at(_, _sub, 'right', true)"),
--        
--        bdoc("Destroy current frame."),
--        kpress("X", "WIonWS.unsplit_at(_, _sub)"),
--    }),
--})
--
--
--defbindings("WScreen", {
--    kpress(META.."t", "notioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),
--    kpress(META.."Tab", "ioncore.goto_next()"),
--    --kpress("K", "ioncore.goto_previous()"),
--    kpress(META.."N", "ioncore.create_ws(_)"),
--})
--
--defbindings("WFrame", {
--    submap(META.."k", {
--      kpress(META.."n", "_:switch_next()"),
--      kpress(META.."p", "_:switch_prev()"),
--    }),
----    kpress(META.."t", "notioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),
----    submap(META.."k", {
----      kpress(META.."p", "_:switch_prev()"),
----      kpress(META.."r", "ioncore.restart()"),
----      kpress(META.."n", "_:switch_next()"),
----    }),
--})
--
--defbindings("WMPlex.toplevel", {
--    kpress(META.."c", "WClientWin.kill(_sub)"),
--    --submap(META.."k", {
--        --kpress(META.."c", "WClientWin.kill(_sub)", "_sub:WClientWin"),
--    --})
--})
--
----defbindings("WMPlex.toplevel", {
----    kpress(META.."F1", nil),
----    kpress(META.."F2", nil),
----    kpress(META.."F3", nil),
----    kpress(META.."F4", nil),
----    kpress(META.."F5", nil),
----    kpress(META.."F6", nil),
----    kpress(META.."F7", nil),
----    kpress(META.."F8", nil),
----    kpress(META.."F9", nil),
----    kpress(META.."F10", nil),
----    kpress(META.."F11", nil),
----    kpress(META.."F12", nil),
----    kpress(META.."L", nil),
----})
--
--defbindings("WScreen", {
--    kpress(META.."F2", "notioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),
--    kpress(META.."F3", "mod_query.query_exec(_)"),
--    kpress(META.."F4", "notioncore.exec_on(_, BROWSER or 'x-browser')"),
--    kpress(META.."F5", "notioncore.exec_on(_, BROWSER_SECRET or 'x-browser-secret')"),
--    --kpress(META.."F6", "notioncore.exec_on(_, MUSIC or 'x-music')"),
--    kpress(META.."F10", "ioncore.create_ws(_)"),
--    kpress(META.."F11", "ioncore.restart()"),
--    kpress(META.."F12", "mod_query.query_menu(_, _sub, 'mainmenu', 'Main menu:')"),
--  --bdoc("Lock screen"),
--
--    --kpress(META.."F7", "notioncore.exec_on(_, SCREENLOCK)"),
--
--    --kpress("XF86AudioPlay", "notioncore.exec('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause')"),
--    --kpress("XF86AudioNext", "notioncore.exec('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next')"),
--    --kpress("XF86AudioPrev", "notioncore.exec('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous')"),
--    --kpress("XF86AudioLowerVolume", "notioncore.exec('$HOME/.zsh/robs/bin/volume down')"),
--    --kpress("XF86AudioRaiseVolume", "notioncore.exec('$HOME/.zsh/robs/bin/volume up')"),
--    --kpress("XF86AudioMute", "notioncore.exec('$HOME/.zsh/robs/bin/volume mute')"),
--})

if not gr.select_engine("de") then return end

de.reset()

local bg_active = "#1f304d"
local bg = "#1f304d"
local fg = "#999999"

de.defstyle("*", {
	background_colour = bg,
	foreground_colour = fg,
	shadow_pixels     = 0,
	highlight_pixels  = 0,
	padding_pixels    = 0,
	spacing           = 0,
  font              = "-*-lucidia-*-r-*--14-*-*-*-*-*-*-*",
	text_align        = "center",
})

de.defstyle("tab", {
    de.substyle("inactive-selected", {
		background_colour = bg,
    }),
    de.substyle("inactive-unselected", {
		background_colour = bg,
    }),
    de.substyle("active-unselected", {
		background_colour = bg,
    }),

	de.substyle("active-selected", {
		foreground_colour = "#fff",
		background_colour = bg_active,
	}),
    text_align = "center",
})

de.defstyle("frame", {
	transparent_background = true,

	padding_pixels   = 0,
	shadow_pixels    = 1,
	highlight_pixels = 1,

	de.substyle("inactive", {
		highlight_colour = bg,
		shadow_colour    = bg,
	}),

	de.substyle("active", {
		highlight_colour = bg_active,
		shadow_colour    = bg_active,
	}),
})

de.defstyle("stdisp-statusbar", {
  font = "-*-lucidia-*-r-*--32-*-*-*-*-*-*-*",
})

-- statusbar stuff
de.defstyle("stdisp", {
    de.substyle("normal", {
        foreground_colour = "#999",
        font = "-*-lucidia-*-r-*--32-*-*-*-*-*-*-*",
    }),

    de.substyle("important", {
        foreground_colour = "green",
        font = "-*-lucidia-*-r-*--32-*-*-*-*-*-*-*",
    }),

    de.substyle("critical", {
        foreground_colour = "red",
        font = "-*-lucidia-*-r-*--32-*-*-*-*-*-*-*",
    }),
})

-- Define some additional title shortening rules to use when the full
-- title doesn't fit in the available space. The first-defined matching
-- rule that succeeds in making the title short enough is used.
ioncore.defshortening("[^:]+: (.*)(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("[^:]+: (.*)", "$1$|$1$<...")
ioncore.defshortening("(.*)(<[0-9]+>)", "$1$2$|$1$<...$2")
ioncore.defshortening("(.*)", "$1$|$1$<...")

-- to improve hide_tabs
de.defstyle("frame-tiled-alt", {
    bar = "none",
})

de.defstyle("frame-unknown-alt", {
    bar = "none",
})

de.defstyle("frame-floating-alt", {
    bar = "none",
})

de.defstyle("frame-transient-alt", {
    bar = "none",
})

-- Refresh objects' brushes.
gr.refresh()

