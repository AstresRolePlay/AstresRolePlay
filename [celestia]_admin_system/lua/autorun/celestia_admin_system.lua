if (engine.ActiveGamemode() != "darkrp") then return end

local dir = "celestia_admin_system"

local function NicePrint(txt)
	if SERVER then
		MsgC(Color(84, 150, 197), txt .. "\n")
	else
		MsgC(Color(117, 209, 152), txt .. "\n")
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
	NicePrint("///////////////// Celestia HUD /////////////////////")
	NicePrint("///////////////////////////////////////////////////")
	PreLoadFile("celestia_admin_system.lua")
	LoadFiles(dir)
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//             Celestia HUD initiated             //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//     This addon is created by Jules Eryziac    //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//         Discord : Jules Eryziac#0798          //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("")
end

timer.Simple(0,function()
    if CelestiaLib == nil then
		local function Warning(ply, msg)
			if DarkRP and DarkRP.notify then
				DarkRP.notify(ply, 1, 8, msg)
			else
				ply:ChatPrint(msg)
			end
		end

		MsgC(Color(255, 0, 0), "[Celestia HUD] : CelestiaLib is missing, please install it on the workshop.")
		MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2870389496")

		if CLIENT then
			surface.PlaySound( "common/warning.wav" )
		end

		if SERVER then
			for k,v in ipairs(player.GetAll()) do
				if IsValid(v) then
					Warning(v, "[Celestia HUD] : CelestiaLib is missing, please install it on the workshop.")
					Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2870389496")
				end
			end
		end
		return
	end
	Initialize()
end)