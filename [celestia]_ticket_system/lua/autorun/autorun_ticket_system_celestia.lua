local dir = "ticket_system_celestia"

TicketSystemCelestia = TicketSystemCelestia or {}

local function NicePrint(txt)
    if SERVER then
        MsgC(Color(23, 217, 62), txt .. "\n")
    else
        MsgC(Color(23, 217, 62), txt .. "\n")
    end
end

local function PreLoadFile(path)
    if CLIENT then
        include(path)
    else
        AddCSLuaFile(path)
        include(path)
    end
end

local function LoadFiles(path)
    local files, _ = file.Find(path .. "/*", "LUA")

    for _, v in ipairs(files) do
        if string.StartWith(v, "sh") then
            if CLIENT then
                include(path .. "/" .. v)
            else
                AddCSLuaFile(path .. "/" .. v)
                include(path .. "/" .. v)
            end
            NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
        end
    end

    for _, v in ipairs(files) do
        if string.StartWith(v, "cl") then
            if CLIENT then
                include(path .. "/" .. v)
                NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
            else
                AddCSLuaFile(path .. "/" .. v)
            end
        elseif string.StartWith(v, "sv") then
            include(path .. "/" .. v)
            NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
        end
    end
end

local function Initialize()
    NicePrint("")
    NicePrint("///////////////////////////////////////////////////")
    NicePrint("//             Ticket System celestia             //")
    NicePrint("///////////////////////////////////////////////////")
    PreLoadFile(dir .. "/config_ticket_system_celestia.lua")
    LoadFiles(dir .. "/ticket")
    LoadFiles(dir .. "/admin")
    LoadFiles(dir .. "/utils")
    NicePrint("///////////////////////////////////////////////////")
    NicePrint("//        Ticket System celestia initiated.       //")
    NicePrint("///////////////////////////////////////////////////")
    NicePrint("//     This addon is created by Jules celestia    //")
    NicePrint("///////////////////////////////////////////////////")
    NicePrint("//               Discord : celestia               //")
    NicePrint("///////////////////////////////////////////////////")
    NicePrint("")
end

timer.Simple(0, function()
    if CelestiaLib == nil then
        local function Warning(ply, msg)
            if DarkRP and DarkRP.notify then
                DarkRP.notify(ply, 1, 8, msg)
            else
                ply:ChatPrint(msg)
            end
        end

        MsgC(Color(255, 0, 0), "[Ticket System celestia] : CelestiaLib is missing, please install it on the workshop.")
        MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2870389496")

        if CLIENT then
            surface.PlaySound("common/warning.wav")
        end

        if SERVER then
            for k, v in ipairs(player.GetAll()) do
                if IsValid(v) then
                    Warning(v, "[Ticket System celestia] : CelestiaLib is missing, please install it on the workshop.")
                    Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2870389496")
                end
            end
        end
        return
    end
    Initialize()
end)