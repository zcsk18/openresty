
local subscribe = require "channel.Subscribe"
local websocket = require 'net.Websocket'

local sock = websocket:new()

local co = subscribe:subscribe(sock.wb, "zcs")

sock:loop()
sock:close()
ngx.thread.wait(co)


