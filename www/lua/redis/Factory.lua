local redis = require "resty.redis"

local _M = {}

function _M:instance(key)
	if not key then
        return nil
    end

    if ngx.ctx[key] then
        return ngx.ctx[key]
    end

    local red = redis:new()
    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect redis: ", err)
    end
	red:set_timeout(5000)
    ngx.ctx[key] = red
    return red
end

return _M;
