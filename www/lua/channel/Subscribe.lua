local factory = require"redis.Factory"
local json = require "cjson"
local _M = {}

local pub = function(wb, channel, redis)
	local res, err = redis:subscribe(channel)
	ngx.log(ngx.ERR, "subscribe pub "..channel, err) 
    if not res then
        ngx.log(ngx.ERR, "failed to sub redis: ", err)
        wb:send_close()
        return exit()
    end

    while true do
        local res, err = redis:read_reply()

        if res then
            local bytes, err = wb:send_text(json.encode(res))
            if not bytes then
                wb:send_close()
                ngx.log(ngx.ERR, "failed to send text: ", err)
                return exit()
            end
        end
        ngx.sleep(0.5)
    end
end

function _M:subscribe(wb, channel) 
	local redis = factory:instance('chan')
    if not redis then 
		return 
	end
	local co = ngx.thread.spawn(pub, wb, channel, redis)
	return co
end


return _M;
