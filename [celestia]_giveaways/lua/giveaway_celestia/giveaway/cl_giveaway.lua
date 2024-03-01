if SERVER then return end

GiveawayCelestia = GiveawayCelestia or {}
GiveawayCelestia.Giveaway = GiveawayCelestia.Giveaway or {}
GiveawayCelestia.Giveaway.Menu = GiveawayCelestia.Giveaway.Menu or {}

local player_nb = player.GetCount()
local next_run = UnPredictedCurTime()
local next_run2 = UnPredictedCurTime()
local panel
local time_left = GiveawayCelestia.Config.NextGiveaway

net.Receive("GiveawayCelestia.Giveaway.UpdateClientTimer", function()
    time_left = net.ReadUInt(16)
    surface.PlaySound("prplib/celestia/dev/giveaways/earn_notif.mp3")
end)

CelestiaLib.Hook.Add("HUDShouldDraw", "GiveawayCelestia.Giveaway.Menu.HUDShouldDraw", function()
    if not panel then
        local player_needed_panel = vgui.Create("DPanel")
        player_needed_panel:SetSize(400 * CelestiaLib.Vgui.Width, 70 * CelestiaLib.Vgui.Height)
        player_needed_panel:SetPos(ScrW() - player_needed_panel:GetWide() - 20 * CelestiaLib.Vgui.Width, 180 * CelestiaLib.Vgui.Height)
        player_needed_panel.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("giveaway_bg"))
            surface.DrawTexturedRect(0, 0, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("giveaway_won"))
            surface.DrawTexturedRect(20 * CelestiaLib.Vgui.Width, h / 2 - (35 * CelestiaLib.Vgui.Height / 2) , 35 * CelestiaLib.Vgui.Width, 35 * CelestiaLib.Vgui.Height)
            draw.DrawText("GIVEAWAY", "giveaway_text", 70 * CelestiaLib.Vgui.Width, h / 4, color_white, TEXT_ALIGN_LEFT)
            if player_nb >= GiveawayCelestia.Config.MinPlayers then
                draw.DrawText(player_nb .. " / " .. GiveawayCelestia.Config.MinPlayers, "giveaway_text", w - 20 * CelestiaLib.Vgui.Width, h / 4, color_darkgreen , TEXT_ALIGN_RIGHT)
            else
                draw.DrawText(player_nb .. " / " .. GiveawayCelestia.Config.MinPlayers, "giveaway_text", w - 20 * CelestiaLib.Vgui.Width, h / 4, color_red, TEXT_ALIGN_RIGHT)
            end
        end
        player_needed_panel.Think = function(self)
            if UnPredictedCurTime() < next_run then return end
            next_run = UnPredictedCurTime() + 10
            player_nb = player.GetCount()
        end

        local timer_panel = vgui.Create("DPanel")
        timer_panel:SetSize(400 * CelestiaLib.Vgui.Width, 70 * CelestiaLib.Vgui.Height)
        timer_panel:SetPos(ScrW() - timer_panel:GetWide() - 20 * CelestiaLib.Vgui.Width, 260 * CelestiaLib.Vgui.Height)
        timer_panel.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("giveaway_bg"))
            surface.DrawTexturedRect(0, 0, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("giveaway_timer"))
            surface.DrawTexturedRect(20 * CelestiaLib.Vgui.Width, h / 2 - (35 * CelestiaLib.Vgui.Height / 2) , 35 * CelestiaLib.Vgui.Width, 35 * CelestiaLib.Vgui.Height)
            draw.DrawText("TIRAGE", "giveaway_text", 70 * CelestiaLib.Vgui.Width, h / 4, color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(string.FormattedTime( time_left , "%02i:%02i" ), "giveaway_text", w - 20 * CelestiaLib.Vgui.Width, h / 4, color_cyan, TEXT_ALIGN_RIGHT)
        end
        timer_panel.Think = function(self)
            if UnPredictedCurTime() < next_run2 then return end
            next_run2 = UnPredictedCurTime() + 1
            time_left = time_left - 1
            if time_left < 0 then
                time_left = GiveawayCelestia.Config.NextGiveaway
            end
        end

        local reward_panel = vgui.Create("DPanel")
        reward_panel:SetSize(400 * CelestiaLib.Vgui.Width, 70 * CelestiaLib.Vgui.Height)
        reward_panel:SetPos(ScrW() - reward_panel:GetWide() - 20 * CelestiaLib.Vgui.Width, 340 * CelestiaLib.Vgui.Height)
        reward_panel.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("giveaway_bg"))
            surface.DrawTexturedRect(0, 0, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("giveaway_reward"))
            surface.DrawTexturedRect(20 * CelestiaLib.Vgui.Width, h / 2 - (35 * CelestiaLib.Vgui.Height / 2) , 35 * CelestiaLib.Vgui.Width, 35 * CelestiaLib.Vgui.Height)
            draw.DrawText("LOTS", "giveaway_text", 70 * CelestiaLib.Vgui.Width, h / 4, color_white, TEXT_ALIGN_LEFT)
            if GiveawayCelestia.Config.XpReward then
                draw.DrawText(GiveawayCelestia.Config.CoinAmount .. " " .. GiveawayCelestia.Rewards.List[GiveawayCelestia.Config.CoinReward].name, "giveaway_text_small", w - 20 * CelestiaLib.Vgui.Width, h / 6, color_gold, TEXT_ALIGN_RIGHT)
                draw.DrawText(GiveawayCelestia.Config.XpAmount .. " " .. GiveawayCelestia.Rewards.List["xp"].name, "giveaway_text_small", w - 20 * CelestiaLib.Vgui.Width, h / 2, color_gold, TEXT_ALIGN_RIGHT)
            else
                draw.DrawText(GiveawayCelestia.Config.CoinAmount .. " " .. GiveawayCelestia.Rewards.List[GiveawayCelestia.Config.CoinReward].name, "giveaway_text", w - 20 * CelestiaLib.Vgui.Width, h / 4.5, color_gold, TEXT_ALIGN_RIGHT)
            end
        end
        panel = true
    end


end)