-- Authors: Randall Wald <randy@rwald.com>
-- License: GPL
-- Last Changed: Unknown
--
-- statusd_volume2.lua
-- Volume level and state information script
-- Written by Randall Wald
-- email: randy@rwald.com
-- Released under the GPL
-- 
-- Based on a public domain script written by Benjamin Sigonneau
-- 
-- This script uses "amixer" to find volume information. If you don't have
-- "amixer," this script will fail. Sorry.
-- Though this is labeled "statusd_volume2.lua", rename it to
-- "statusd_volume.lua" to make it work.
--
-- Available monitors:
--  %volume_levelVolume level, as a percentage from 0% to 100%
--  %volume_  stateThe string "" if unmuted, "MUTE " if muted
--
-- Example use:
--    template="[ %date || <other stuff> || vol: %volume_level %volume state]"
--  (note space between monitors but lack of space after %volume_state)
-- This will print
--  [ <Date> || <other stuff> || vol: 54% ]
-- when unmuted but
--  [ <Date> || <other stuff> || vol: 54% MUTE ]
-- when muted.

local function get_volume()
   local f=io.popen('amixer sget Master','r')
   local s=f:read('*all')

   f:close()

   local _, _, master_level, master_state = string.find(s, "%[(%d*%%)%] %[.%d*...dB%] %[(%a*)%]")
   local sound_state = ""

   if master_state == "off" then
      sound_state = "critical"
   else
      sound_state = "normal"
   end

   return master_level.."", sound_state..""
end

local function inform_volume(name, value)
   if statusd ~= nil then
      statusd.inform(name, value)
   else
      io.stdout:write(name..": "..value.."\n")
   end
end

if statusd ~= nil then
   volume_timer = statusd.create_timer()
end

local function update_volume()

   local master_level, sound_state = get_volume()

   inform_volume("volume_level", master_level)
   inform_volume("volume_level_hint", sound_state)

   if statusd ~= nil then
      volume_timer:set(100, update_volume)
   end
end

update_volume()