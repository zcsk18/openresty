
local data = ngx.req.get_body_data()
ngx.say("hello", data)


local arg = ngx.req.get_uri_args()
for k,v in pairs(arg) do
    ngx.say("[GET ] key:", k, " v:", v)
end

local file = io.popen("curl zcsk18.cn", 'r')
local str = file:read("*a")
file:close()
ngx.say(str)
