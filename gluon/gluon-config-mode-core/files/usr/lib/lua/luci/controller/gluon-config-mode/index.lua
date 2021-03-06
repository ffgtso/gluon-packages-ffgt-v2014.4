--[[
Copyright 2013 Nils Schneider <nils@nilsschneider.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.gluon-config-mode.index", package.seeall)

function index()
  local uci_state = luci.model.uci.cursor_state()

  if uci_state:get_first("gluon-setup-mode", "setup_mode", "running", "0") == "1" then
    local root = node()
    if not root.target then
      root.target = alias("gluon-config-mode")
      root.index = true
    end

    page          = node()
    page.lock     = true
    page.target   = alias("gluon-config-mode")
    page.subindex = true
    page.index    = false

    page          = node("gluon-config-mode")
    page.title    = _("Wizard")
    page.target   = alias("gluon-config-mode", "wizard")
    page.order    = 5
    page.setuser  = "root"
    page.setgroup = "root"
    page.index    = true

    entry({"gluon-config-mode", "wizard"}, form("gluon-config-mode/wizard")).index = true
    entry({"gluon-config-mode", "reboot"}, call("action_reboot"))
  end
end

function action_reboot()
  local uci = luci.model.uci.cursor()
  local pubkey

  uci:set("gluon-setup-mode", uci:get_first("gluon-setup-mode", "setup_mode"), "configured", "1")
  uci:save("gluon-setup-mode")
  uci:commit("gluon-setup-mode")

  if nixio.fork() ~= 0 then
    local fs = require "luci.fs"

    local parts_dir = "/lib/gluon/config-mode/reboot/"
    local files = fs.dir(parts_dir)

    table.sort(files)

    local parts = {}

    for _, entry in ipairs(files) do
      if entry:sub(1, 1) ~= '.' then
        local f = dofile(parts_dir .. '/' .. entry)
        if f ~= nil then
          table.insert(parts, f)
        end
      end
    end

    local meshvpn_enabled = uci:get("fastd", meshvpn_name, "enabled", "0")
    local sysconfig = require 'gluon.sysconfig'
    if meshvpn_enabled == "1" then
      pubkey = configmode.get_fastd_pubkey(meshvpn_name)
    end

    local hostname = uci:get_first("system", "system", "hostname")
    local location
    local lat = uci:get_first("gluon-node-info", "location", "latitude")
    local lon = uci:get_first("gluon-node-info", "location", "longitude")
    if lat ~= nil and lon ~= nil then
      location = lat .. " " .. lon
    else
      location = ""
    end

    luci.template.render("gluon-config-mode/reboot", { parts=parts
                                                     , hostname=hostname
                                                     , pubkey=pubkey
                                                     , sysconfig=sysconfig
                                                     , location=location
                                                     })
  else
    debug.setfenv(io.stdout, debug.getfenv(io.open '/dev/null'))
    io.stdout:close()

    -- Sleep a little so the browser can fetch everything required to
    -- display the reboot page, then reboot the device.
    nixio.nanosleep(2)

    -- Run reboot with popen so it gets its own std filehandles.
    io.popen("reboot")

    -- Prevent any further execution in this child.
    os.exit()
  end
end
