GiveawayCelestia = GiveawayCelestia or {}
GiveawayCelestia.Rewards = GiveawayCelestia.Rewards or {}
GiveawayCelestia.Rewards.List = GiveawayCelestia.Rewards.List or {}

CelestiaLib.Materials.Add( "giveaway_bg", Material( "celestia/giveaways/back.png", "noclamp smooth" ) )
CelestiaLib.Materials.Add( "giveaway_won", Material( "celestia/giveaways/gift.png", "noclamp smooth" ) )
CelestiaLib.Materials.Add( "giveaway_timer", Material( "celestia/giveaways/timer.png", "noclamp smooth" ) )
CelestiaLib.Materials.Add( "giveaway_reward", Material( "celestia/giveaways/galleon.png", "noclamp smooth" ) )

GiveawayCelestia.Rewards.List["money"] = {
    name = "$",
    func = function(ply, amount)
        ply:addMoney(amount)
    end
}

GiveawayCelestia.Rewards.List["pointshop2"] = {
    name = "Points",
    func = function(ply, amount)
        ply:PS2_AddStandardPoints(amount)
    end
}

GiveawayCelestia.Rewards.List["premium_pointshop2"] = {
    name = "Points",
    func = function(ply, amount)
        ply:PS2_AddPremiumPoints(amount)
    end
}

GiveawayCelestia.Rewards.List["xp"] = {
    name = "XP",
    func = function(ply, amount)
        ply:addXP(amount)
    end
}