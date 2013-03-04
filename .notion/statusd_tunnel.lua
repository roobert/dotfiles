local defaults={
    update_interval=10*1000,
}

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local settings=table.join(statusd.get_config("tunnel"), defaults)

local tunnel_timer

ticker = 'on'

local function update_tunnel_status()

  what_is_my_ip_url = "http://ifconfig.me/ip"

  http = require "socket.http"
  content, status, headers = http.request(what_is_my_ip_url)

  ip = trim(content)

  statusd.inform("tunnel", ip)

  if ticker ~= 'on' then
    ticker = 'on'
    statusd.inform("tunnel_ticker_hint", "critical")
  else
    ticker = 'off'
    statusd.inform("tunnel_ticker_hint", "important")
  end

  statusd.inform("tunnel_ticker", os.date('%M', os.time()))

  if ip ~= "176.53.22.152" then
    statusd.inform("tunnel_hint", "critical")
  else
    statusd.inform("tunnel_hint", "important")
  end

  tunnel_timer:set(settings.update_interval, update_tunnel_status)
end

tunnel_timer=statusd.create_timer()
update_tunnel_status()

