local data = {eventobjid = 1011636906, x = 0, y = 7, z = 0, shortix =0}
local _, json = pcall(JSON.encode, JSON, data)
Game:dispatchEvent("Game.AnyPlayer.EnterGame", {customdata = json})

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame", function(event)
    local _, data = pcall(JSON.decode, JSON, event.customdata)
    if not data or data == {} then return end
    local playerid = data.playerid
    local x, y, z = data.x, data.y, data.z
    local shortix = data.shortix

    Chat:sendSystemMsg("#GĐã nhận sự kiện từ UID: #Y" .. playerid, playerid)
    Chat:sendSystemMsg("#GĐã nhận tọa độ: #Y(" .. x .. ", " .. y .. ", " .. z .. ", " .. shortix .. ")", playerid)
end)