if CLIENT then return end

GiveawayCelestia = GiveawayCelestia or {}
GiveawayCelestia.Giveaway = GiveawayCelestia.Giveaway or {}

CelestiaLib.Timer.Create("GiveawayCelestia.Giveaway.Timer", 30, 1, function()
    CelestiaLib.Timer.Create( "GiveawayCelestia.Giveaway.Start", GiveawayCelestia.Config.NextGiveaway, 1, function()
        GiveawayCelestia.Giveaway.Start()
    end )
end)

function GiveawayCelestia.Giveaway.Start()
    if player.GetCount() < GiveawayCelestia.Config.MinPlayers then
        CelestiaLib.Utils.SendColoredChatMessage(color_cyan, "Giveaway", color_green , " Il n'y a pas assez de joueurs pour lancer un Giveaway !")
        CelestiaLib.Timer.Create( "GiveawayCelestia.Giveaway.Start", GiveawayCelestia.Config.NextGiveaway, 1, function()
            GiveawayCelestia.Giveaway.Start()
        end )
        return
    end
    CelestiaLib.Utils.SendColoredChatMessage(color_cyan, "Giveaway", color_green , " Un nouveau giveaway a été lancé !")
    GiveawayCelestia.Giveaway.End()
end

function GiveawayCelestia.Giveaway.End()
    local winner = {
        ply = nil,
        result = 0
    }
    
    for k, v in pairs(player.GetAll()) do
        local min = 1
        local max = 100
        if GiveawayCelestia.Giveaway.VerifTag(v) then
            min = GiveawayCelestia.Config.TagChance
        end
        local result = math.random(min, max)
        if result > winner.result then
            winner.ply = v
            winner.result = result
        end
    end
    if IsValid(winner.ply) and GiveawayCelestia.Rewards.Give(winner.ply) then
        GiveawayCelestia.Giveaway.UpdateClientsTimer()
        CelestiaLib.Timer.Create( "GiveawayCelestia.Giveaway.Start", GiveawayCelestia.Config.NextGiveaway, 1, function()
            GiveawayCelestia.Giveaway.Start()
        end )
        return
    end

    GiveawayCelestia.Giveaway.End()
end

util.AddNetworkString("GiveawayCelestia.Giveaway.UpdateClientTimer")
function GiveawayCelestia.Giveaway.UpdateClientsTimer()
    net.Start("GiveawayCelestia.Giveaway.UpdateClientTimer")
    net.WriteUInt(GiveawayCelestia.Config.NextGiveaway, 16)
    net.Broadcast()
end

hook.Add( "PlayerInitialSpawn", "GiveawayCelestia.Giveaway.UpdateClientTimer", function(ply)
    if timer.Exists("GiveawayCelestia.Giveaway.Start") then
        net.Start("GiveawayCelestia.Giveaway.UpdateClientTimer")
        net.WriteUInt(timer.TimeLeft("GiveawayCelestia.Giveaway.Start"), 16)
        net.Send(ply)
    end
end)

function GiveawayCelestia.Giveaway.VerifTag(ply)
    local nick = ply:Name()
    local steamid = ply:SteamID64()
    local apiKey = GiveawayCelestia.Config.API
    local tag = GiveawayCelestia.Config.Tag
    local ok = false

    if !nick or !steamid or !apiKey or !tag then
        CelestiaLib.AddonPrint("Giveaway", "Joueur, clé api ou tag invalide !")
        return false
    end

    CelestiaLib.Http.JSONFetch("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=" .. apiKey .. "&steamids=" .. steamid, 
    function(data)
        local resp = (data && data.response)
        local players = (resp && resp.players)
        local sPly = (players && players[1] || false)
        local sName = (sPly && sPly.personaname)
        local hasTag = false

        if (sName) then
            sName = string.lower(sName)
            if (istable(tag)) then
                for k,v in pairs(tag) do
                    hasTag = string.StartWith(sName, string.lower(v))
                        
                    if (hasTag) then break end
                end
            else
                hasTag = string.StartWith(sName, string.lower(tag))
            end
        end
    end,
    function(data)
        local errStr = (istable(data) && data.error || "Unknown error.")

        CelestiaLib.AddonPrint("Giveaway", "Erreur lors de la vérification du tag : " .. errStr)
    end)
    return ok
end