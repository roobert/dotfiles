--defwinprop {class="stalonetray", statusbar="systray"}
--defwinprop {class="Docker", statusbar="systray"}
--
--defwinprop {
--  --is_dockapp = true,
--  statusbar = "systray",
--  class = "Xfce4-panel",
--  --float = true,
--  --userpos = true,
--  --switchto = false,
--  --max_size = { w = 900, h = 30},
--  --min_size = { w = 0, h = 30},
--}


--defwinprop{class="stalonetray",instance="stalonetray",target="*dock*"}
--defwinprop{instance="stalonetray",target="*dock*"}
--defwinprop{class="stalonetray",target="*dock*"}
--defwinprop{is_dockapp=true,target="*dock*"}

--- this was enabled
defwinprop {class="stalonetray", statusbar="systray_dock"}
