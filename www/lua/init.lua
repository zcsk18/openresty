require 'zcs'


local update
update = function() 
    --zcs()
end

ngx.timer.every(10, update)
