local UIID = "7483275955022154623"

local MainElement = "7483275955022154623_"
local CloseThisUI = ""
local NextPage = "7483275955022154623_163"
local PreviousPage = "7483275955022154623_162"
local CurrentPage = "7483275955022154623_164"

local FramePreview = "7483275955022154623_187"
local FrameName = "7483275955022154623_188"

local DisplayElements = {
    "7483275955022154623_165", "7483275955022154623_166", "7483275955022154623_167", "7483275955022154623_168", "7483275955022154623_169",
    "7483275955022154623_170", "7483275955022154623_171", "7483275955022154623_172", "7483275955022154623_173", "7483275955022154623_174",
    "7483275955022154623_175", "7483275955022154623_176", "7483275955022154623_177", "7483275955022154623_178", "7483275955022154623_179",
    "7483275955022154623_180", "7483275955022154623_181", "7483275955022154623_182", "7483275955022154623_183", "7483275955022154623_184"
}

local FrameElements = {}
local UsingAvatar = {}
local UsingFrame = {}
local PlayerPage = {}
local AvailableFrames = {}


threadpool:work(
    function ()
        for i = 1, #DisplayElements do FrameElements[DisplayElements[i]] = true end
        for i = 20201, 20292 do table.insert(AvailableFrames, i) end
        for i = 33001, 33188 do if i ~= 33021 and i ~= 33022 then table.insert(AvailableFrames, i) end end
    end
)

local TotalFrames = #AvailableFrames
local MaxPage = math.ceil(TotalFrames / #DisplayElements)

-- 2. Hàm hiển thị trang hiện tại
local function changePlayerPageByNumber(playerid, pageNumber)
    if pageNumber < 1 then pageNumber = 1 end
    if pageNumber > MaxPage then pageNumber = MaxPage end
    PlayerPage[playerid] = pageNumber

    Customui:setText(playerid, UIID, CurrentPage, PlayerPage[playerid] .. "/" .. MaxPage)

    if PlayerPage[playerid] <= 1 then
        Customui:hideElement(playerid, UIID, PreviousPage)
    else
        Customui:showElement(playerid, UIID, PreviousPage)
    end


    if PlayerPage[playerid] >= MaxPage then
        Customui:hideElement(playerid, UIID, NextPage)
    else
        Customui:showElement(playerid, UIID, NextPage)
    end


    local startIndex = (PlayerPage[playerid] - 1) * #DisplayElements
    for i = 1, #DisplayElements do
        local frameIndex = startIndex + i
        local elementid = DisplayElements[i]
        if frameIndex <= TotalFrames then
            local frameID = AvailableFrames[frameIndex]
            Customui:showElement(playerid, UIID, elementid)
            Customui:setTexture(playerid, UIID, elementid, 2000000 + frameID)

        else
            -- Ẩn đi các ô lưới trống ở trang cuối cùng
            Customui:hideElement(playerid, UIID, elementid)
        end
    end
end

-- 3. Xử lý các sự kiện click trên UI
local function onPlayerClickUI(event)
    local playerid = event.eventobjid
    local elementid = event.uielement

    if elementid == NextPage then
        changePlayerPageByNumber(playerid, (PlayerPage[playerid] or 1) + 1)

    elseif elementid == PreviousPage then
        changePlayerPageByNumber(playerid, (PlayerPage[playerid] or 1) - 1)

    elseif elementid == CloseThisUI then 
        Customui:hideElement(playerid, UIID, MainElement)

    elseif FrameElements[elementid] then
        local startIndex = ((PlayerPage[playerid] or 1) - 1) * #DisplayElements
        local clickedSlotIndex = 0
        for i = 1, #DisplayElements do
            if DisplayElements[i] == elementid then
                clickedSlotIndex = i
                break
            end
        end

        if clickedSlotIndex > 0 then
            local frameIndex = startIndex + clickedSlotIndex
            if frameIndex <= TotalFrames then
                local selectedFrameID = AvailableFrames[frameIndex]
                UsingFrame[playerid] = selectedFrameID
                local _, frameName = Item:getItemName(selectedFrameID)
                Customui:setText(playerid, UIID, FrameName, frameName)
                Customui:setTexture(playerid, UIID, FramePreview, 2000000 + selectedFrameID)
            end
        end
    end
end
ScriptSupportEvent:registerEvent("UI.Button.Click", onPlayerClickUI)
ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame", function(event) changePlayerPageByNumber(event.eventobjid, 1) end)