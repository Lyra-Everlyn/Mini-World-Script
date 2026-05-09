Trigger:setTriggerActiveAndFunc("WatchAd", true, function(reqdisable, data)
    if data and data.curparams then
        local playerid = data.curparams.TriggerByPlayer
        local finishEvent = Trigger.VCCommon:checkEventFinish(true)

        if not finishEvent then return end
        
        --Chat:sendSystemMsg("Người chơi " .. playerid .. " đã xem xong quảng cáo!")
        --Trigger.Player:killPlayer(playerid)
    end
end)

ScriptSupportEvent:registerEvent("Player.ClickBlock", function(param)
    local cur = param.CurEventParam
    if not cur or not cur.TriggerByPlayer then return end

    Trigger.Player:playAdvertisingNew(
        cur.TriggerByPlayer,
        "Quảng cáo sản phẩm", -- Dòng chữ trên thông báo
        "WatchAd",
        { curparams = cur, param = param }
    )
end)
