--[[
    Module: Cloud
    Version: 2.0.0
    Lastest: 6/11/2025 3:12 AM
    Author: Lyra Everlyn
    Description: tải dữ liệu lên cloud
]]--

local Cloud = {}


-- Upload dữ liệu từ table lên sever lưu trữ
function Cloud:uploadTable(playerid, keyLibName, tableName)

    -- Kiểm tra tham số
    if not playerid or not keyLibName or not tableName then
        Chat:sendSystemMsg("[Cloud Upload]: Thiếu tham số khi upload")
        return false
    end


    -- Chuyển đổi bảng thành chuỗi JSON
    local success, encoded = pcall(JSON.encode, JSON, tableName)
    if not success then
        Chat:sendSystemMsg("[Cloud Upload]: Chuyển đổi JSON thất bại")
        return false
    end


    -- Lưu chuỗi JSON vào VarLib2
    local result = VarLib2:setPlayerVarByName(playerid, VARTYPE.STRING, keyLibName, encoded)
    if result ~= ErrorCode.OK then
        Chat:sendSystemMsg("[Cloud Upload]: Tải dữ liệu thất bại")
        return false
    end

    --Chat:sendSystemMsg("[Cloud Upload]: Đã lưu dữ liệu vào: " .. keyLibName .. " (" .. #encoded .. " ký tự)")
    return true
end

-- Download dữ liệu từ sever lưu trữ về bảng
function Cloud:downloadTable(playerid, keyLibName)

    -- Kiểm tra tham số
    if not playerid or not keyLibName then
        Chat:sendSystemMsg("[Cloud Download]: Thiếu tham số đầu vào")
        return false, {}
    end

    -- Lấy chuỗi JSON từ VarLib2
    local result, encoded = VarLib2:getPlayerVarByName(playerid, VARTYPE.STRING, keyLibName)
    if result ~= ErrorCode.OK or encoded == "" then
        Chat:sendSystemMsg("[Cloud Download]: Không tìm thấy dữ liệu: " .. keyLibName)
        return false, {}
    end

    -- Giải mã chuỗi JSON thành bảng
    local success, decoded = pcall(JSON.decode, JSON, encoded)
    if not success then
        Chat:sendSystemMsg("[Cloud Download]: Chuyển đổi JSON thất bại: " .. keyLibName)
        return false, {}
    end

    --Chat:sendSystemMsg("[Cloud Download]: Tải dữ liệu thành công: " .. keyLibName)
    return true, decoded
end

--return Cloud


-- Test Load / Save
-- Player is in server
-- local playerid = 0
-- table[playerid] = { key1 = "value1", key2 = "value2" }
-- Cloud:uploadTable(0, "testTable", table)
-- table[playerid] = {} -- clear table

-- player leave server, then rejoin
-- local playerid = 0
-- local success, downloadedTable = Cloud:downloadTable(0, "testTable")
-- if success then
--     table[playerid] = downloadedTable
-- end