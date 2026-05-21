local PlayerState = {}

-- 1. KIỂM TRA LIÊN TỤC VÀ PHÁT SỰ KIỆN KHI THAY ĐỔI CHẾ ĐỘ
local function checkPlayerMovementMode()
    local result, num, array = World:getAllPlayers(-1)
    if result == 0 and array then
        for i = 1, #array do
            local playerid = array[i]
            local inAir = Actor:isInAir(playerid)
            if PlayerState[playerid] ~= nil then
                if PlayerState[playerid] ~= inAir then
                    PlayerState[playerid] = inAir

                    local data = {
                        eventobjid = playerid,
                        isInAir = inAir
                    }
                    
                    local ok, json = pcall(JSON.encode, JSON, data)
                    if ok then
                        Game:dispatchEvent("Custom.Player.ChangeMoveType", {customdata = json})
                    end
                end
            else
                PlayerState[playerid] = inAir
            end
        end
    end
end
ScriptSupportEvent:registerEvent("Game.RunTime", checkPlayerMovementMode)


-- 2. DỌN DẸP DỮ LIỆU KHI NGƯỜI CHƠI THOÁT GAME
local function onPlayerLeave(e)
    local playerid = e.eventobjid
    if PlayerState[playerid] ~= nil then
        PlayerState[playerid] = nil
    end
end
ScriptSupportEvent:registerEvent("Game.AnyPlayer.LeaveGame", onPlayerLeave)


-- 3. LẮNG NGHE SỰ KIỆN CHUYỂN CHẾ ĐỘ DI CHUYỂN
local function onMoveModeChanged(param)
    local ret, data = pcall(JSON.decode, JSON, param.customdata)
    
    if ret and data then
        local playerid = data.eventobjid
        local isFlying = data.isInAir
        if isFlying == 0 then
            Chat:sendSystemMsg("Người chơi ID: " .. tostring(playerid) .. " vừa cất cánh / bay lên!")
        else
            Chat:sendSystemMsg("Người chơi ID: " .. tostring(playerid) .. " vừa chạm đất!")
        end
    end
end
ScriptSupportEvent:registerEvent("Custom.Player.ChangeMoveType", onMoveModeChanged)