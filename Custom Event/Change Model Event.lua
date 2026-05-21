local PlayerModels = {}

-- 1. LƯU MODEL BAN ĐẦU KHI NGƯỜI CHƠI VÀO GAME
local function onPlayerEnter(e)
    local playerid = e.eventobjid
    local result, model = Actor:getActorFacade(playerid)
    if result == ErrorCode.OK then PlayerModels[playerid] = model end
end
ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame", onPlayerEnter)


-- 2. KIỂM TRA LIÊN TỤC VÀ PHÁT SỰ KIỆN TÙY CHỈNH KHI ĐỔI MODEL
local function onRunTime()
    for playerid, oldModel in pairs(PlayerModels) do
        local result, currentModel = Actor:getActorFacade(playerid)
        if result == ErrorCode.OK then
            if currentModel ~= oldModel then
                PlayerModels[playerid] = currentModel
                local data = {
                    eventobjid = playerid,
                    model = currentModel
                }
                local ok, json = pcall(JSON.encode, JSON, data)
                if ok then
                    Game:dispatchEvent("Custom.Player.ModelChanged", {customdata = json})
                end
            end
        else
            PlayerModels[playerid] = nil
        end
    end
end
ScriptSupportEvent:registerEvent("Game.RunTime", onRunTime)

-- 3. LẮNG NGHE SỰ KIỆN TÙY CHỈNH
local function onModelChanged(param)
    local ret, data = pcall(JSON.decode, JSON, param.customdata)
    if ret and data then
        local playerid = data.eventobjid
        local newModel = data.model
        Chat:sendSystemMsg("Người chơi ID: " .. tostring(playerid) .. " vừa đổi model thành: " .. tostring(newModel))
    end
end

ScriptSupportEvent:registerEvent("Custom.Player.ModelChanged", onModelChanged)