local defaults = { update_interval=1000, }
local settings = table.join(statusd.get_config("exec"), defaults)

--statusd.inform("exec_template", "000")

local exec_timer=statusd.create_timer()

local function update_exec()

  local exec   = assert(io.popen("$HOME/.notion/statusbar/exec.sh", 'r'))
  local string = assert(exec:read('*a'))
  exec:close()

  statusd.inform("exec", tostring(string))

  exec_timer:set(settings.update_interval, update_exec)
end

update_exec()
