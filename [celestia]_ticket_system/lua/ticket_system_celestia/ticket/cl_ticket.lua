
if SERVER then return end

local notifications = {}

local function ShowNotification(creator, reason, guilty, ticket_id)
    local guilty_name = guilty:Nick()
    local creator_name = creator:Nick()
    local ply = LocalPlayer()
    local onSelf = creator == guilty
    local sited = false
    local frame = vgui.Create("DFrame")
    frame:SetSize(600 * CelestiaLib.Vgui.Width, 300 * CelestiaLib.Vgui.Height)
    frame:SetTitle("")
    frame:SetVisible(true)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
    end

    local panel = vgui.Create("DPanel", frame)
    panel:Dock(FILL)
    panel.Paint = function(self, w, h)
        surface.SetDrawColor(33, 27, 14)
        surface.DrawOutlinedRect(0, 0, w, h, 5)
        surface.SetDrawColor(8, 21, 25)
        surface.DrawRect(5 * CelestiaLib.Vgui.Width, 5 * CelestiaLib.Vgui.Height, w - 10 * CelestiaLib.Vgui.Width, h - 10 * CelestiaLib.Vgui.Height)
    end
    panel.accepted = false

    local close_button = vgui.Create("DButton", panel)
    close_button:SetPos(550 * CelestiaLib.Vgui.Width, 10 * CelestiaLib.Vgui.Height)
    close_button:SetSize(30 * CelestiaLib.Vgui.Width, 30 * CelestiaLib.Vgui.Height)
    close_button:SetText("X")
    close_button:SetTextColor(color_white)
    close_button:SetFont("celestia_ticket_title")
    close_button.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_red)
        else
            self:SetTextColor(color_white)
        end
    end
    close_button.DoClick = function()
        frame:Close()
    end

    local title = vgui.Create("DLabel", panel)
    title:Dock(TOP)
    title:DockMargin(10 * CelestiaLib.Vgui.Width, 10 * CelestiaLib.Vgui.Width, 10 * CelestiaLib.Vgui.Width, 10 * CelestiaLib.Vgui.Width)
    title:SetTall(20 * CelestiaLib.Vgui.Height)
    title:SetText("Ticket de " .. creator:Nick())
    title:SetFont("celestia_ticket_title")
    title:SetTextColor(color_white)
    title:SetContentAlignment(5)

    local reasonLabel = vgui.Create("DLabel", panel)
    reasonLabel:Dock(TOP)
    reasonLabel:DockMargin(10 * CelestiaLib.Vgui.Width, 0, 10 * CelestiaLib.Vgui.Width, 10 * CelestiaLib.Vgui.Width)
    reasonLabel:SetTall(50 * CelestiaLib.Vgui.Height)
    reasonLabel:SetText("Raison : " .. reason)
    reasonLabel:SetFont("celestia_ticket_text")
    reasonLabel:SetTextColor(color_white)
    reasonLabel:SetContentAlignment(5)
    reasonLabel:SetWrap(true)

    local guiltyLabel = vgui.Create("DLabel", panel)
    guiltyLabel:Dock(TOP)
    guiltyLabel:DockMargin(10 * CelestiaLib.Vgui.Width, 0, 10 * CelestiaLib.Vgui.Width, 10 * CelestiaLib.Vgui.Width)
    guiltyLabel:SetTall(20 * CelestiaLib.Vgui.Height)
    guiltyLabel:SetText("Conserné : " .. guilty_name)
    guiltyLabel:SetFont("celestia_ticket_text")
    guiltyLabel:SetTextColor(color_white)
    guiltyLabel:SetContentAlignment(5)

    local buttonPanel = vgui.Create("DPanel", panel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:DockMargin(0, 5 * CelestiaLib.Vgui.Height, 0, 5 * CelestiaLib.Vgui.Height)
    buttonPanel:SetTall(30 * CelestiaLib.Vgui.Height)
    buttonPanel.Paint = function(self, w, h)
    end

    local acceptButton = vgui.Create("DButton", buttonPanel)
    acceptButton:Dock(LEFT)
    acceptButton:DockMargin(0, 0, 0, 0)
    acceptButton:SetWide(145 * CelestiaLib.Vgui.Width)
    acceptButton:SetText("Accepter")
    acceptButton:SetTextColor(color_white)
    acceptButton:SetFont("celestia_ticket_title")
    acceptButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_gold)
        else
            self:SetTextColor(color_white)
        end
    end
    acceptButton.DoClick = function()
        if panel.accepted then
            ply:ConCommand("sam return " .. creator_name)
            ply:ConCommand("sam return " .. guilty_name)
            if sited then
                RunConsoleCommand("say", "!sit")
            end
            net.Start("celestia_ticket_close_ticket")
                net.WriteUInt(ticket_id, 11)
            net.SendToServer()
            frame:Close()
        else
            panel.accepted = true
            close_button:Remove()
            acceptButton:SetText("Fermer")
            net.Start("celestia_ticket_accept_ticket")
                net.WriteUInt(ticket_id, 11)
            net.SendToServer()
        end
    end

    local gotoButton = vgui.Create("DButton", buttonPanel)
    gotoButton:Dock(LEFT)
    gotoButton:DockMargin(0, 0, 0, 0)
    gotoButton:SetWide(145 * CelestiaLib.Vgui.Width)
    gotoButton:SetText("Se téléporter")
    gotoButton:SetTextColor(color_white)
    gotoButton:SetFont("celestia_ticket_title")
    gotoButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_gold)
        else
            self:SetTextColor(color_white)
        end
    end
    gotoButton.DoClick = function()
        local who_to_teleport = DermaMenu()
        who_to_teleport:AddOption(creator_name, function()
            ply:ConCommand("sam goto " .. creator_name)
        end)
        who_to_teleport:AddOption(guilty_name, function()
            ply:ConCommand("sam goto " .. guilty_name)
        end)
    end

    local bringButton = vgui.Create("DButton", buttonPanel)
    bringButton:Dock(LEFT)
    bringButton:DockMargin(0, 0, 0, 0)
    bringButton:SetWide(145 * CelestiaLib.Vgui.Width)
    bringButton:SetText("Téléporter")
    bringButton:SetTextColor(color_white)
    bringButton:SetFont("celestia_ticket_title")
    bringButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_gold)
        else
            self:SetTextColor(color_white)
        end
    end
    bringButton.DoClick = function()
        local who_to_teleport = DermaMenu()
        who_to_teleport:AddOption(creator_name, function()
            ply:ConCommand("sam bring " .. creator_name)
        end)
        who_to_teleport:AddOption(guilty_name, function()
            ply:ConCommand("sam bring " .. guilty_name)
        end)
    end

    local sitButton = vgui.Create("DButton", buttonPanel)
    sitButton:Dock(LEFT)
    sitButton:DockMargin(0, 0, 0, 0)
    sitButton:SetWide(145 * CelestiaLib.Vgui.Width)
    sitButton:SetText("Créer un sit")
    sitButton:SetTextColor(color_white)
    sitButton:SetFont("celestia_ticket_title")
    sitButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_gold)
        else
            self:SetTextColor(color_white)
        end
    end
    sitButton.DoClick = function()
        if not sited then
            RunConsoleCommand("say", "!sit " .. creator:SteamID() .. " " .. guilty:SteamID())
            sited = true
        else
            RunConsoleCommand("say", "!sit")
            sited = false
        end
    end

    local notification = {
        frame = frame,
        panel = panel,
        id = ticket_id
    }

    table.insert(notifications, notification)
end

local notificationSpacing = 10 * CelestiaLib.Vgui.Height  -- Espace vertical entre les notifications

local function DrawNotifications()
    local yOffset = 20 * CelestiaLib.Vgui.Height

    for _, notification in ipairs(notifications) do
        if IsValid(notification.frame) then
            notification.frame:SetPos(20 * CelestiaLib.Vgui.Width, yOffset)
            yOffset = yOffset + notification.frame:GetTall() + notificationSpacing
        end
    end
end


net.Receive("celestia_ticket_accept_ticket", function()
    local ticket_id = net.ReadUInt(11)

    for i, notification in ipairs(notifications) do
        if notification.id == ticket_id then
            notification.frame:Close()
            table.remove(notifications, i)
            return
        end
    end
end)

net.Receive("celestia_ticket_close_ticket", function()
    local staff_name = net.ReadString()
    local ticket_id = net.ReadUInt(11)

    local frame = vgui.Create("DFrame")
    frame:SetSize(1000 * CelestiaLib.Vgui.Width, 250 * CelestiaLib.Vgui.Height)
    frame:SetTitle("")
    frame:SetVisible(true)
    frame:Center()
    frame:MakePopup()
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(33, 27, 14)
        surface.DrawOutlinedRect(0, 0, w, h, 5)
        surface.SetDrawColor(8, 21, 25)
        surface.DrawRect(5 * CelestiaLib.Vgui.Width, 5 * CelestiaLib.Vgui.Height, w - 10 * CelestiaLib.Vgui.Width, h - 10 * CelestiaLib.Vgui.Height)
    end

    local label = vgui.Create("DLabel", frame)
    label:Dock(TOP)
    label:SetText("Qu'avez-vous pensez de l'intervention de " .. staff_name .. " ?")
    label:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    label:SetTextColor(color_white)
    label:SetContentAlignment(5)
    label:SizeToContents()

    local ratingPanelStars = vgui.Create("DPanel", frame)
    ratingPanelStars:Dock(TOP)
    ratingPanelStars:DockMargin( 230 * CelestiaLib.Vgui.Width, 25 * CelestiaLib.Vgui.Height, 0, 0)
    ratingPanelStars:SetTall(50 * CelestiaLib.Vgui.Height)
    ratingPanelStars.Paint = function(self, w, h)
    end

    local ratingStars = {}
    local starSize = 50 * CelestiaLib.Vgui.Width
    local starSpacing = 100 * CelestiaLib.Vgui.Width
    local totalStarsWidth = (starSize + starSpacing) * 5
    local offsetX = (frame:GetWide() - totalStarsWidth) / 5

    for i = 1, 5 do
        local star = vgui.Create("DImageButton", ratingPanelStars)
        star:Dock(LEFT)
        star:DockMargin(offsetX, 0, 0, 0)
        star:SetWide(50 * CelestiaLib.Vgui.Width)
        star:SetImage("celestia/ticket/star_empty.png")
        star:SetTooltip(i)
        star.OnMousePressed = function()
            for j = 1, i do
                ratingStars[j]:SetImage("celestia/ticket/star_fill.png")
            end
            for j = i + 1, 5 do
                ratingStars[j]:SetImage("celestia/ticket/star_empty.png")
            end
        end
        ratingStars[i] = star
    end

    local sendRatingButton = vgui.Create("DButton", frame)
    sendRatingButton:Dock(TOP)
    sendRatingButton:DockMargin(0, 25 * CelestiaLib.Vgui.Height, 0, 0)
    sendRatingButton:SetText("Envoyer")
    sendRatingButton:SetTextColor(color_white)
    sendRatingButton:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    sendRatingButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_gold)
        else
            self:SetTextColor(color_white)
        end
    end
    sendRatingButton.DoClick = function()
        local rating = 0
        for i = 1, 5 do
            if ratingStars[i]:GetImage() == "celestia/ticket/star_fill.png" then
                rating = i
            end
        end
        net.Start("celestia_ticket_send_rating")
        net.WriteUInt(ticket_id, 11)
        net.WriteUInt(rating, 3)
        net.SendToServer()
        frame:Close()
    end

end)

CelestiaLib.Hook.Add("OnPlayerChat", "celestiaOpenTicketPanel", function(ply, text, teamChat, isDead)
    if text ~= "/ticket" then return end
    if ply ~= LocalPlayer() then return end

    local frame = vgui.Create("DFrame")
    frame:SetSize(1100 * CelestiaLib.Vgui.Width, 600 * CelestiaLib.Vgui.Height)
    frame:SetTitle("")
    frame:SetVisible(true)
    frame:Center()
    frame:MakePopup()
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(33, 27, 14)
        surface.DrawOutlinedRect(0, 0, w, h, 5)
        surface.SetDrawColor(8, 21, 25)
        surface.DrawRect(5 * CelestiaLib.Vgui.Width, 5 * CelestiaLib.Vgui.Height, w - 10 * CelestiaLib.Vgui.Width, h - 10 * CelestiaLib.Vgui.Height)
    end

    local close_button = vgui.Create("DButton", frame)
    close_button:SetPos(1050 * CelestiaLib.Vgui.Width, 25 * CelestiaLib.Vgui.Height)
    close_button:SetSize(25 * CelestiaLib.Vgui.Width, 25 * CelestiaLib.Vgui.Height)
    close_button:SetText("X")
    close_button:SetTextColor(color_white)
    close_button:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    close_button.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_red)
        else
            self:SetTextColor(color_white)
        end
    end
    close_button.DoClick = function()
        frame:Close()
    end

    local title = vgui.Create("DLabel", frame)
    title:Dock(TOP)
    title:DockMargin(0, 25 * CelestiaLib.Vgui.Height, 0, 0)
    title:SetTall(60 * CelestiaLib.Vgui.Height)
    title:SetText("Créer un ticket")
    title:SetFont(CelestiaLib.GetFont("celestia_lib_window_title"))
    title:SetTextColor(color_white)
    title:SetContentAlignment(5)

    local reason_panel = vgui.Create("DPanel", frame)
    reason_panel:Dock(TOP)
    reason_panel:DockMargin(0, 50 * CelestiaLib.Vgui.Height, 0, 0)
    reason_panel:SetTall(100 * CelestiaLib.Vgui.Height)
    reason_panel.Paint = function(self, w, h)
    end

    local reason_label = vgui.Create("DLabel", reason_panel)
    reason_label:Dock(LEFT)
    reason_label:DockMargin(50 * CelestiaLib.Vgui.Width, 0, 0, 0)
    reason_label:SetText("Raison :")
    reason_label:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    reason_label:SetTextColor(color_white)
    reason_label:SetContentAlignment(4)
    reason_label:SetWide(145 * CelestiaLib.Vgui.Width)

    local reason_entry = vgui.Create("DTextEntry", reason_panel)
    reason_entry:Dock(FILL)
    reason_entry:DockMargin(50 * CelestiaLib.Vgui.Width, 0, 50 * CelestiaLib.Vgui.Width, 0)
    reason_entry:SetText("")
    reason_entry:SetPlaceholderText("Raison")
    reason_entry:SetContentAlignment(5)
    reason_entry:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    reason_entry:SetDrawLanguageID(false)
    reason_entry:SetMultiline(true)
    reason_entry:SetVerticalScrollbarEnabled(true)
    reason_entry:SetEnterAllowed(false)
    reason_entry:SetUpdateOnType(true)
    reason_entry.AllowInput = function(self, value)
        if string.len(self:GetValue()) > 200 then
            return true
        end
    end

    local guilty_panel = vgui.Create("DPanel", frame)
    guilty_panel:Dock(TOP)
    guilty_panel:DockMargin(0, 50 * CelestiaLib.Vgui.Height, 0, 0)
    guilty_panel:SetTall(100 * CelestiaLib.Vgui.Height)
    guilty_panel.Paint = function(self, w, h)
    end

    local guilty_label = vgui.Create("DLabel", guilty_panel)
    guilty_label:Dock(LEFT)
    guilty_label:DockMargin(50 * CelestiaLib.Vgui.Width, 0, 0, 0)
    guilty_label:SetText("Concerné :")
    guilty_label:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    guilty_label:SetTextColor(color_white)
    guilty_label:SetContentAlignment(4)
    guilty_label:SetWide(145 * CelestiaLib.Vgui.Width)

    local guilty_selector = vgui.Create("DComboBox", guilty_panel)
    guilty_selector:Dock(FILL)
    guilty_selector:DockMargin(50 * CelestiaLib.Vgui.Width, 0, 50 * CelestiaLib.Vgui.Width, 0)
    guilty_selector:SetValue(player.GetAll()[1]:Nick())  -- Sélectionnez le premier joueur par défaut
    guilty_selector:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    guilty_selector:SetSortItems(true)
    for k, v in ipairs(player.GetAll()) do
        guilty_selector:AddChoice(v:Nick())
    end
    guilty_selector.OnSelect = function(self, index, value, data)
        for k, v in ipairs(player.GetAll()) do
            if v:Nick() == value then
                self.player = v
            end
        end
    end

    local send_button = vgui.Create("DButton", frame)
    send_button:Dock(TOP)
    send_button:DockMargin(0, 50 * CelestiaLib.Vgui.Height, 0, 50 * CelestiaLib.Vgui.Height)
    send_button:SetTall(100 * CelestiaLib.Vgui.Height)
    send_button:SetText("Envoyer")
    send_button:SetTextColor(color_white)
    send_button:SetFont(CelestiaLib.GetFont("celestia_lib_window_title"))
    send_button:SetContentAlignment(5)
    send_button.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(color_gold)
        else
            self:SetTextColor(color_white)
        end
    end
    send_button.DoClick = function()
        if reason_entry:GetText() == "" then
            ShowNotification("Erreur", "Vous devez entrer une raison !", {})
            return
        end
    
        local reason = reason_entry:GetText()
        local guilty_player = nil
    
        -- Vérifier s'il y a des joueurs disponibles
        local players = player.GetAll()
        if #players > 0 then
            guilty_player = players[1]  -- Sélectionnez le premier joueur par défaut
        end
    
        net.Start("celestia_ticket_create_ticket")
        net.WriteString(reason)
        net.WriteEntity(guilty_player)
        net.SendToServer()
    
        frame:Close()
    end

end)

net.Receive("celestia_ticket_create_ticket", function()
    local creator = net.ReadEntity()
    local reason = net.ReadString()
    local guilty = net.ReadEntity()
    local ticket_id = net.ReadUInt(11)

    ShowNotification(creator, reason, guilty, ticket_id)
end)

hook.Add("HUDPaint", "DrawNotifications", DrawNotifications)