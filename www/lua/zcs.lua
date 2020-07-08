

local file_name = "/data/www/lua/log.log"
local function write(str)
    local file = io.open(file_name,'a')
    file:write(tostring(str).."\n")
    file:close()
end

local print = write

local function http_get(url)
    local http = require "resty.http"
    local httpc = http.new()
    local res, err = httpc:request_uri("http://zcsk18.cn")
    if res then
	print(string.len(res.body))
    end 
    print(err)
end

function zcs() 
    print(ngx.worker.id().." "..os.time())
    if tonumber(ngx.worker.id()) == 0 then
       print("http_get")
	http_get("http://zcsk18.cn")
    end    
end
