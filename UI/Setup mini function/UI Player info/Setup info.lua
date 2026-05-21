local UIID = "7483275955022154623"
local BoxAvatar1 = UIID .. "_2"
local BoxFrame1 = UIID .. "_3"
local BoxName1 = UIID .. "_54"
local BoxId1 = UIID .. "_56"

local BoxName2 = "7483275955022154623_15"
local BoxId2 = "7483275955022154623_124"
local BoxFrame2 = "7483275955022154623_14"
local BoxAvatar2 = "7483275955022154623_13"

local BoxAvatar3 = "7483275955022154623_186"
local BoxFrame3 = "7483275955022154623_187"

local AvailableFrames = {}
local IsLoadedAll = false

threadpool:work(function()
    -- Range 1: Từ 20201 đến 20292
    for i = 20201, 20292 do
        table.insert(AvailableFrames, i)
    end

    -- Range 2: Từ 33001 đến 33188
    for i = 33001, 33188 do
        if i ~= 33021 and i ~= 33022 then
            table.insert(AvailableFrames, i)
        end
    end

    IsLoadedAll = true
end)

function setPlayerAvatar(event)
    local playerid = event.eventobjid
    local _, avatar = Customui:getRoleIcon(playerid)
    local _, name = Player:getNickname(playerid)
    
    local randomValue = 20201 
    if IsLoadedAll and #AvailableFrames > 0 then
        local randomIndex = math.random(1, #AvailableFrames)
        randomValue = AvailableFrames[randomIndex]
    end

    Customui:setTexture(playerid, UIID, BoxAvatar1, avatar)
    Customui:setTexture(playerid, UIID, BoxAvatar2, avatar)
    Customui:setTexture(playerid, UIID, BoxAvatar3, avatar)
    
    Customui:setTexture(playerid, UIID, BoxFrame1, 2000000 + randomValue)
    Customui:setTexture(playerid, UIID, BoxFrame2, 2000000 + randomValue)
    Customui:setTexture(playerid, UIID, BoxFrame3, 2000000 + randomValue)
    
    Customui:setText(playerid, UIID, BoxName1, name)
    Customui:setText(playerid, UIID, BoxName2, name)
    
    Customui:setText(playerid, UIID, BoxId1, playerid)
    Customui:setText(playerid, UIID, BoxId2, playerid)
end

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame", setPlayerAvatar)