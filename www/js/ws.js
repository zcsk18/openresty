var ws = new WebSocket("ws://" + window.location.host + "/wb/", 'echo')
var index = 0;

ws.onopen = function() {
    ws.connected = true
    ws.ping()
}

ws.onmessage = function(evt) {
    console.info(++index, evt)
}

ws.onclose = function() {
    console.info('close')
    ws.connected = false
}

ws.onpong = function() {
    console.info("pong")
}

ws.ping = function() {
    if (!ws.connected) {
    return;
    }
    ws.send("ping")
    setTimeout("ws.ping()",15000)
}
