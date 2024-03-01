if SERVER then return end

local displayPage = 1
local totalWidth = (419 * CelestiaLib.Vgui.Width) * 4 + (10 * CelestiaLib.Vgui.Width) * 3
local startX = (ScrW() - totalWidth) / 2
local staffMode = false
local ContextMenu
local image_index = 1
local image_change_time = 0

local targetXPos = 2713 * CelestiaLib.Vgui.Width
local startXPos = targetXPos + 150 * CelestiaLib.Vgui.Width
local progress = 0

local function updateContextMenuPos()
    if not IsValid(ContextMenu) then
        hook.Remove("Think", "jeContext_MenuAnim")
        return
    end
    progress = math.min(progress + FrameTime() * 2, 1) -- Ajustez la vitesse de l'animation en modifiant le 2.
    if progress == 1 then
        hook.Remove("Think", "jeContext_MenuAnim")
    end
    local currentXPos = Lerp(progress, startXPos, targetXPos)
    ContextMenu:SetPos(currentXPos, 126 * CelestiaLib.Vgui.Height)
end

hook.Add("OnContextMenuOpen", "jeContext_MenuOpen", function()
    local ply = LocalPlayer()

    ContextMenu = vgui.Create("DPanel")
    ContextMenu:SetSize(1127 * CelestiaLib.Vgui.Width, 1908 * CelestiaLib.Vgui.Height)
    ContextMenu:SetPos(startXPos, 126 * CelestiaLib.Vgui.Height)
    ContextMenu:MakePopup()
    ContextMenu.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_background_hud_Celestia"))
        surface.DrawTexturedRect(0, 0, w, h)
    end

    hook.Add("Think", "jeContext_MenuAnim", updateContextMenuPos)

    local commandes_title = vgui.Create("DPanel", ContextMenu)
    commandes_title:SetSize(1007 * CelestiaLib.Vgui.Width, 156 * CelestiaLib.Vgui.Height)
    commandes_title:SetPos(83 * CelestiaLib.Vgui.Width, 417 * CelestiaLib.Vgui.Height)
    commandes_title.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(CelestiaLib.Materials.Get("title_menu_c_hud_Celestia"))
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Commandes", "CelestiaContextTitle", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local give_money_button = vgui.Create("DButton", ContextMenu)
    give_money_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    give_money_button:SetPos(108 * CelestiaLib.Vgui.Width, 615 * CelestiaLib.Vgui.Height)
    give_money_button:SetText("")
    give_money_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Donner de l'argent", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    give_money_button.DoClick = function()
        Derma_StringRequest("Donner de l'argent", "Combien d'argent voulez-vous donner ?", "", function(text)
            if text == "" then return end
            if !isnumber(tonumber(text)) then return end
            if tonumber(text) < 0 then return end
            if tonumber(text) > 1000000000 then return end
            RunConsoleCommand("say", "/givemoney " .. text)
        end)
    end

    local drop_money_button = vgui.Create("DButton", ContextMenu)
    drop_money_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    drop_money_button:SetPos(598 * CelestiaLib.Vgui.Width, 615 * CelestiaLib.Vgui.Height)
    drop_money_button:SetText("")
    drop_money_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Deposer de l'argent", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    drop_money_button.DoClick = function()
        Derma_StringRequest("Deposer de l'argent", "Combien d'argent voulez-vous deposer ?", "", function(text)
            if text == "" then return end
            if !isnumber(tonumber(text)) then return end
            if tonumber(text) < 0 then return end
            if tonumber(text) > 1000000000 then return end
            RunConsoleCommand("say", "/dropmoney " .. text)
        end)
    end

    local drop_weapon_button = vgui.Create("DButton", ContextMenu)
    drop_weapon_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    drop_weapon_button:SetPos(108 * CelestiaLib.Vgui.Width, 735 * CelestiaLib.Vgui.Height)
    drop_weapon_button:SetText("")
    drop_weapon_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Lacher son arme", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    drop_weapon_button.DoClick = function()
        RunConsoleCommand("say", "/dropweapon")
    end

    local stop_sound_button = vgui.Create("DButton", ContextMenu)
    stop_sound_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    stop_sound_button:SetPos(598 * CelestiaLib.Vgui.Width, 735 * CelestiaLib.Vgui.Height)
    stop_sound_button:SetText("")
    stop_sound_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Stopper le son", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    stop_sound_button.DoClick = function()
        RunConsoleCommand("stopsound")
    end

    local thirdperson_button = vgui.Create("DButton", ContextMenu)
    thirdperson_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    thirdperson_button:SetPos(108 * CelestiaLib.Vgui.Width, 855 * CelestiaLib.Vgui.Height)
    thirdperson_button:SetText("")
    thirdperson_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Troisième personne", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    thirdperson_button.DoClick = function()
        if ipr_thirdp then
            ply:ConCommand( "ipr_thirdp" );
        else
            RunConsoleCommand("simple_thirdperson_enable_toggle")
        end
    end

    local call_admin_button = vgui.Create("DButton", ContextMenu)
    call_admin_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    call_admin_button:SetPos(598 * CelestiaLib.Vgui.Width, 855 * CelestiaLib.Vgui.Height)
    call_admin_button:SetText("")
    call_admin_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText("Appeler un admin", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    call_admin_button.DoClick = function()
            RunConsoleCommand("say", "/ticket")
    end

    local playerModelPanel = vgui.Create("DModelPanel", ContextMenu)
    local modelPanelWidth = 180
    local modelPanelHeight = 350  -- Augmentez la hauteur du panneau
    playerModelPanel:SetSize(modelPanelWidth, modelPanelHeight)
    playerModelPanel:SetPos(35, 615)  -- Ajustez la position selon vos besoins
    playerModelPanel:SetModel(LocalPlayer():GetModel())
    
    -- Ajustez la position de la caméra et le point de vue
    playerModelPanel:SetLookAt(Vector(0, 0, 35))  -- Réduisez la valeur Z pour abaisser le point de vue
    playerModelPanel:SetCamPos(Vector(80, 0, 50))  -- Augmentez la valeur Z pour relever la position de la caméra
    
    playerModelPanel:SetFOV(36)
    playerModelPanel:SetAnimated(true)

    local rpname_button = vgui.Create("DButton", ContextMenu)
    rpname_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    rpname_button:SetPos(400 * CelestiaLib.Vgui.Width, 1350 * CelestiaLib.Vgui.Height)
    rpname_button:SetText("")
    rpname_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(1, 1, w, h)
        draw.SimpleText("Nom RP: " .. LocalPlayer():Nick(), "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local money_button = vgui.Create("DButton", ContextMenu)
    money_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    money_button:SetPos(400 * CelestiaLib.Vgui.Width, 1500 * CelestiaLib.Vgui.Height)
    money_button:SetText("")
    money_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        if self:IsHovered() then
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
        else
            surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        end
        surface.DrawTexturedRect(1, 1, w, h)
        
        local playerMoney = DarkRP and DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")) or "Inconnu"

        draw.SimpleText("Argent: " .. playerMoney, "CelestiaContextButtonSmall", w / 2, h / 2 + 3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local timenegame_button = vgui.Create("DButton", ContextMenu)
    timenegame_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
    timenegame_button:SetPos(400 * CelestiaLib.Vgui.Width, 1650 * CelestiaLib.Vgui.Height)
    timenegame_button:SetText("")
    
    timenegame_button.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(self:IsHovered() and CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia") or CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
        surface.DrawTexturedRect(1, 1, w, h)
    
        local player = LocalPlayer()
        local playTime = player:sam_get_play_time()
    
        local function formatTime(timeInSeconds)
            local days = math.floor(timeInSeconds / (3600 * 24))
            local months = math.floor(days / 30)
            local remainingDays = days % 30
            local hours = math.floor((timeInSeconds % (3600 * 24)) / 3600)
            local minutes = math.floor((timeInSeconds % 3600) / 60)
            return string.format("%d mois, %d jours, %dh %dm", months, remainingDays, hours, minutes)
        end
    
        local playTimeText = formatTime(playTime)
        draw.SimpleText(playTimeText, "CelestiaContextButtonSmall", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    
    
    
    
    
    


    if Celestia_contextmenu.AdminRank[CelestiaLib.Player.GetRank(ply)] then
        local staff_title = vgui.Create("DPanel", ContextMenu)
        staff_title:SetSize(1007 * CelestiaLib.Vgui.Width, 156 * CelestiaLib.Vgui.Height)
        staff_title:SetPos(83 * CelestiaLib.Vgui.Width, 997 * CelestiaLib.Vgui.Height)
        staff_title.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get("title_menu_c_hud_Celestia"))
            surface.DrawTexturedRect(0, 0, w, h)
            draw.SimpleText("Partie Staff", "CelestiaContextTitle", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local logs_button = vgui.Create("DButton", ContextMenu)
        logs_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
        logs_button:SetPos(108 * CelestiaLib.Vgui.Width, 1193 * CelestiaLib.Vgui.Height)
        logs_button:SetText("")
        logs_button.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            if self:IsHovered() then
                surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
            else
                surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
            end
            surface.DrawTexturedRect(0, 0, w, h)
            draw.SimpleText("Logs", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        logs_button.DoClick = function()
            RunConsoleCommand( "say", "!logs" )
        end

        local staff_mode_button = vgui.Create("DButton", ContextMenu)
        staff_mode_button:SetSize(468 * CelestiaLib.Vgui.Width, 92 * CelestiaLib.Vgui.Height)
        staff_mode_button:SetPos(598 * CelestiaLib.Vgui.Width, 1193 * CelestiaLib.Vgui.Height)
        staff_mode_button:SetText("")
        staff_mode_button.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            if self:IsHovered() then
                surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_active_hud_Celestia"))
            else
                surface.SetMaterial(CelestiaLib.Materials.Get("menu_c_button_hud_Celestia"))
            end
            surface.DrawTexturedRect(0, 0, w, h)
            draw.SimpleText("Mode Staff", "CelestiaContextButton", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        staff_mode_button.DoClick = function()
            if SAM_LOADED then
                if (staffMode) then
                    RunConsoleCommand( "sam", "unadmin" )
                    staffMode = false
                else
                    RunConsoleCommand( "sam", "admin" )
                    staffMode = true
                end
            else
                RunConsoleCommand( "ulx", "noclip" )
                if (staffMode) then
                    RunConsoleCommand( "ulx", "uncloak" )
                    staffMode = false
                else
                    RunConsoleCommand( "ulx", "cloak" )
                    staffMode = true
                end
            end
        end
    else
        local informations_image = vgui.Create("DPanel", ContextMenu)
        informations_image:SetSize(271 * CelestiaLib.Vgui.Width, 227 * CelestiaLib.Vgui.Height)
        informations_image:SetPos(108 * CelestiaLib.Vgui.Width, 1045 * CelestiaLib.Vgui.Height)
        informations_image.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(CelestiaLib.Materials.Get(Celestia_contextmenu.InformationsText[image_index].image))
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local informations_title = vgui.Create("DLabel", ContextMenu)
        informations_title:SetPos(526 * CelestiaLib.Vgui.Width, 1045 * CelestiaLib.Vgui.Height)
        informations_title:SetSize(429 * CelestiaLib.Vgui.Width, 54 * CelestiaLib.Vgui.Height)
        informations_title:SetFont("CelestiaContextTitle")
        informations_title:SetTextColor(color_white)
        informations_title:SetText("Informations")
        informations_title:SizeToContents()

        local informations_text = vgui.Create("DLabel", ContextMenu)
        informations_text:SetPos(420 * CelestiaLib.Vgui.Width, 1143 * CelestiaLib.Vgui.Height)
        informations_text:SetSize(630 * CelestiaLib.Vgui.Width, 140 * CelestiaLib.Vgui.Height)
        informations_text:SetFont("CelestiaContextInformation")
        informations_text:SetTextColor(color_white)
        informations_text:SetText(Celestia_contextmenu.InformationsText[image_index].text)
        informations_text:SetWrap(true)
        informations_text:SetContentAlignment(7)
        informations_text.Paint = function(self, w, h)
            if Celestia_contextmenu.InformationsText[image_index].text != self:GetText() then
                self:SetText(Celestia_contextmenu.InformationsText[image_index].text)
            end
        end
    end
end)

hook.Add("OnPlayerChat", "CheckTimeCommand", function(ply, text, teamChat, isDead)
    -- Vérifiez si le joueur a entré la commande !time
    if string.lower(text) == "!time" then
        -- Utilisez le module sam.menu.cmd pour envoyer la commande !time
        RunConsoleCommand("sam.menu.cmd", "time")

        -- Mettez à jour le temps de jeu lorsque la commande est détectée
        UpdatePlayerTime()
    end
end)

hook.Add("PostDrawOpaqueRenderables", "CelestiaContextMenu3DModel", function()
    -- Vérifiez que playerModelPanel existe avant de tenter d'y accéder
    if IsValid(playerModelPanel) then
        local x, y = playerModelPanel:LocalToScreen(0, 0)
        render.SetScissorRect(x, y, x + playerModelPanel:GetWide(), y + playerModelPanel:GetTall(), true)

        -- Effectuez le rendu des autres éléments du menu ici

        playerModelPanel:DrawModel()
        
        render.SetScissorRect(0, 0, 0, 0, false)
    end
end)

hook.Add("OnContextMenuClose","CelestiaContextMenuClose",function()
    gui.EnableScreenClicker(false)
    if IsValid(ContextMenu) then
        ContextMenu:Remove()
        startXPos = targetXPos + 150 * CelestiaLib.Vgui.Width
        progress = 0
    end
end)
