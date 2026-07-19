AdminList = {[1011636906] = true, [1062292351] = true, [1004828112] = true}

local LocalVersion = 0
local LocalBanList = {}
local BanString = "BanPlayersStr"
local DataVersion = "BanVersion"

local function splitChatContent(content)
    local t = {}
    for word in string.gmatch(content, "%S+") do table.insert(t, word) end
    return t
end

--[[
    Sync dữ liệu BanList và Version cho người chơi
    Đồng bộ khi ở local có Version mới hơn người chơi, hoặc khi người chơi có Version mới hơn local
]]
local function syncToPlayer(pid)
    VarLib2:setPlayerVarByName(pid, VARTYPE.NUMBER, DataVersion, LocalVersion)

    local flatList = {}
    for target, _ in pairs(LocalBanList) do table.insert(flatList, target) end

    local success, encoded = pcall(JSON.encode, JSON, flatList)
    if success and encoded then
        VarLib2:setPlayerVarByName(pid, VARTYPE.STRING, BanString, encoded)
    end
end

local function checkEnterGame(event)
    local playerJustEnter = event.eventobjid

    local code, pVer = VarLib2:getPlayerVarByName(playerJustEnter,
                                                  VARTYPE.NUMBER, DataVersion)
    if code ~= ErrorCode.OK then pVer = 0 end
    if not pVer then pVer = 0 end

    -- TRƯỜNG HỢP 1: Người vào mang chủng virus mới hơn -> Phòng cập nhật theo người vào, lây luôn cho tất cả người đang có mặt trong phòng
    if pVer > LocalVersion then

        -- Cập nhật Version mới nhất cho phòng
        local code2, encoded = VarLib2:getPlayerVarByName(playerJustEnter,
                                                          VARTYPE.STRING,
                                                          BanString)
        if code2 == ErrorCode.OK and encoded and encoded ~= "" then
            local success, decoded = pcall(JSON.decode, JSON, encoded)
            if success and decoded then
                LocalVersion = pVer
                LocalBanList = {}
                for _, target in ipairs(decoded) do
                    LocalBanList[target] = true
                end
                if AdminList[playerJustEnter] then
                    Chat:sendSystemMsg(
                        "#GPhòng đã cập nhật lên Version mới: #Y" ..
                            LocalVersion, playerJustEnter)
                end
            end
        end

        -- Đồng bộ lại cho tất cả người đang có mặt trong phòng
        local _, _, players = World:getAllPlayers(-1)
        for _, pid in ipairs(players) do
            if pid ~= playerJustEnter then syncToPlayer(pid) end
        end

        -- TRƯỜNG HỢP 2: Người vào mang dữ liệu cũ hơn -> Phòng lây nhiễm dữ liệu mới cho người vào
    elseif pVer < LocalVersion then
        syncToPlayer(playerJustEnter)
    end

    -- Sau khi đồng bộ xong xuôi, kiểm tra xem người này có bị BAN không
    if LocalBanList[playerJustEnter] then
        local _, name = Player:getNickname(playerJustEnter)
        Player:notifyGameInfo2Self(playerJustEnter,
                                   "#RTài khoản này đã bị cấm chơi.")
        World:despawnActor(playerJustEnter)

        local _, _, players = World:getAllPlayers(-1)
        for _, pid in ipairs(players) do
            if AdminList[pid] then
                Chat:sendSystemMsg("#R[Virus Ban] Đã tự động kick: " ..
                                       playerJustEnter .. " : " .. name, pid)
            end
        end
    end
end

----------------------------------------------------
-- Chat Command
----------------------------------------------------

local function handlePlayerInput(event)
    local playerid = event.eventobjid
    local content = event.content

    if string.sub(content, 1, 1) ~= "/" then return end
    local args = splitChatContent(content)
    local command = args[1]

    if not AdminList[playerid] then return end

    if command == "/banlist" then
        Chat:sendSystemMsg("#G===== Ban List (Version: " .. LocalVersion ..
                               ") =====", playerid)
        local count = 0
        for pid, _ in pairs(LocalBanList) do
            count = count + 1
            Chat:sendSystemMsg("#Y" .. pid, playerid)
        end
        Chat:sendSystemMsg("#GTổng: " .. count, playerid)
        return
    end

    if #args < 2 then return end
    local targetId = tonumber(args[2])
    if not targetId or targetId == playerid or AdminList[targetId] then
        return
    end
    if #tostring(targetId) < 10 then targetId = targetId + 1000000000 end

    if command == "/ban" then
        if LocalBanList[targetId] then
            Player:notifyGameInfo2Self(playerid,
                                       "#YĐã bị ban từ trước.")
            return
        end

        LocalBanList[targetId] = true
        LocalVersion = LocalVersion + 1
        Chat:sendSystemMsg("#GĐã ban #Y" .. targetId, playerid)

        syncToPlayer(playerid)
        local _, _, players = World:getAllPlayers(-1)
        for _, pid in ipairs(players) do
            if pid ~= playerid and pid ~= targetId then
                syncToPlayer(pid)
            end
        end

        World:despawnActor(targetId)

    elseif command == "/unban" then
        if not LocalBanList[targetId] then
            Player:notifyGameInfo2Self(playerid,
                                       "#YNgười này chưa bị ban.")
            return
        end

        LocalBanList[targetId] = nil
        LocalVersion = LocalVersion + 1

        syncToPlayer(playerid)
        Chat:sendSystemMsg("#GĐã gỡ ban cho #Y" .. targetId, playerid)

        local _, _, players = World:getAllPlayers(-1)
        for _, pid in ipairs(players) do
            if pid ~= playerid then syncToPlayer(pid) end
        end
    end
end

ScriptSupportEvent:registerEvent("Player.InputContent", handlePlayerInput)
ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame", checkEnterGame)

