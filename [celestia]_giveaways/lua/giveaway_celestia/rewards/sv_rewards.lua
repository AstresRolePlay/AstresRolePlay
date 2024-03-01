if CLIENT then return end

GiveawayAstres = GiveawayAstres or {}
GiveawayAstres.Rewards = GiveawayAstres.Rewards or {}

function GiveawayAstres.Rewards.Give(ply)
    if not IsValid(ply) then return end

    local reward = GiveawayAstres.Rewards.List[GiveawayAstres.Config.CoinReward]
    if not reward then return end

    if not ply.CelestiaLib then return false end

    local time = string.FormattedTime( GiveawayAstres.Config.NextGiveaway, "%02i:%02i" )

    CelestiaLib.Utils.SendColoredChatMessage(color_cyan, "Giveaway", color_green , ply:Name() .. " a gagné le giveaway !")
    CelestiaLib.Utils.SendColoredChatMessage(color_cyan, "Giveaway", color_green , "Le prochain giveaway aura lieu dans " .. time .. " !")
    
    GiveawayAstres.Rewards.List[GiveawayAstres.Config.CoinReward].func(ply, GiveawayAstres.Config.CoinAmount)
    if GiveawayAstres.Config.XpReward then
        GiveawayAstres.Rewards.List["xp"].func(ply, GiveawayAstres.Config.XpAmount)
    end
    return true
end