local server = require "resty.websocket.server"

local _M = {}
local index = 0;


function _M:new()
	local wb, err = server:new{
	    timeout = 30000,  -- in milliseconds
    	max_payload_len = 65535,
	}
	if not wb then
    	ngx.log(ngx.ERR, "failed to new websocket: ", err)
    	return ngx.exit(444)
	end

	local obj = setmetatable({},{__index=self})
	obj.wb = wb

	return obj
end

function _M:send(text)
	return self.wb:send_text(text)
end

function _M:close() 
	return self.wb:send_close()
end

function _M:loop()
	while true do
	    local data, typ, err = self.wb:recv_frame()

    	if not data then
        	if not string.find(err, "timeout", 1, true) then
            	ngx.log(ngx.ERR, "failed to receive a frame: ", err)
            	return ngx.exit(444)
        	end
    	end

    	if typ == "close" then
        	local code = err

        	local bytes, err = self.wb:send_close(1000, "enough, enough!")
        	if not bytes then
            	ngx.log(ngx.ERR, "failed to send the close frame: ", err)
            	return
        	end
        	ngx.log(ngx.INFO, "closing with status code ", code, " and message ", data)
        	return
    	end
		
		if typ == "ping" then
	        local bytes, err = self.wb:send_pong(data)
    	    if not bytes then
        	    ngx.log(ngx.ERR, "failed to send frame: ", err)
            	return
        	end
    	elseif typ == "pong" then

    	else
        	ngx.log(ngx.INFO, "received a frame of type ", typ, " and payload ", data)
    	end

		if typ == "text" then
			index = index + 1
        	bytes, err = self:send(data..":"..index)
        	if not bytes then
            	ngx.log(ngx.ERR, "failed to send a text frame: ", err)
            	return ngx.exit(444)
        	end
    	end
	end
end



return _M;
