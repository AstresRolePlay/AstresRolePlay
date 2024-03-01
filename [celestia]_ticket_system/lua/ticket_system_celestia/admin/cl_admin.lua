if SERVER then return end

local function draw_stars(frame, right_panel, rating, staff)
    right_panel:Clear()

    local ratingPanelTitle = vgui.Create("DLabel", right_panel)
    ratingPanelTitle:Dock(TOP)
    ratingPanelTitle:DockMargin(0, 25 * CelestiaLib.Vgui.Height, 0, 0)
    ratingPanelTitle:SetTall(50 * CelestiaLib.Vgui.Height)
    ratingPanelTitle:SetText("Notes")
    ratingPanelTitle:SetFont(CelestiaLib.GetFont("celestia_lib_window_count"))
    ratingPanelTitle:SetTextColor(color_white)
    ratingPanelTitle:SetContentAlignment(5)

    local ratingPanelStars = vgui.Create("DPanel", right_panel)
    ratingPanelStars:Dock(TOP)
    ratingPanelStars:DockMargin( 0, 140 * CelestiaLib.Vgui.Height, 0, 0)
    ratingPanelStars:SetTall(50 * CelestiaLib.Vgui.Height)
    ratingPanelStars.Paint = function(self, w, h)
    end

    local starSize = 50 * CelestiaLib.Vgui.Width
    local starSpacing = 115 * CelestiaLib.Vgui.Width
    local totalStarsWidth = (starSize + starSpacing) * 5
    local offsetX = (frame:GetWide() - totalStarsWidth) / 5

    local averageRating = 0

    for k, v in ipairs(rating) do
        if staff and v.staff == LocalPlayer():SteamID() then continue end
        averageRating = averageRating + v.rating
    end
    averageRating = averageRating / #rating
    averageRating = math.Round(averageRating, 1)

    if #rating == 0 then
        averageRating = 0
    end

    for i = 1, 5 do
        local star = vgui.Create("DImage", ratingPanelStars)
        star:Dock(LEFT)
        if i == 1 then
            star:DockMargin(25 * CelestiaLib.Vgui.Width, 0, 0, 0)
        else
            star:DockMargin(offsetX, 0, 0, 0)
        end
        star:SetWide(50 * CelestiaLib.Vgui.Width)
        if i <= averageRating then
            star:SetImage("celestia/ticket/star_fill.png")
        else
            star:SetImage("celestia/ticket/star_empty.png")
        end
    end

    local rating_label = vgui.Create("DLabel", right_panel)
    rating_label:Dock(BOTTOM)
    rating_label:DockMargin(0, 0, 0, 25 * CelestiaLib.Vgui.Height)
    rating_label:SetTall(50 * CelestiaLib.Vgui.Height)
    rating_label:SetText("Note moyenne : " .. averageRating .. "/5")
    rating_label:SetFont(CelestiaLib.GetFont("celestia_lib_window_desc"))
    rating_label:SetTextColor(color_white)
    rating_label:SetContentAlignment(5)
end

local function draw_stats_panel(rating)

    local frame = vgui.Create("DFrame")
    frame:SetSize(1100 * CelestiaLib.Vgui.Width, 600 * CelestiaLib.Vgui.Height)
    frame:SetTitle("")
    frame:SetVisible(true)
    frame:Center()
    frame:MakePopup()
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(CelestiaLib.Colors["celestia_border"])
        surface.DrawOutlinedRect(0, 0, w, h, 5)
        surface.SetDrawColor(86, 52, 17)
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
    title:DockMargin(0, 0, 0, 0)
    title:SetTall(60 * CelestiaLib.Vgui.Height)
    title:SetText("Statistiques des tickets")
    title:SetFont(CelestiaLib.GetFont("celestia_lib_window_title"))
    title:SetTextColor(color_white)
    title:SetContentAlignment(5)

    local right_panel = vgui.Create("DPanel", frame)
    right_panel:Dock(FILL)
    right_panel:DockMargin(25 * CelestiaLib.Vgui.Width, 25 * CelestiaLib.Vgui.Height, 25 * CelestiaLib.Vgui.Width, 25 * CelestiaLib.Vgui.Height)
    right_panel.Paint = function(self, w, h)
        surface.SetDrawColor(CelestiaLib.Colors["celestia_details"])
        surface.DrawRect(5 * CelestiaLib.Vgui.Width, 5 * CelestiaLib.Vgui.Height, w - 10 * CelestiaLib.Vgui.Width, h - 10 * CelestiaLib.Vgui.Height)
    end

    draw_stars(frame, right_panel, rating, nil)

    local left_panel = vgui.Create("DPanel", frame)
    left_panel:Dock(LEFT)
    left_panel:DockMargin(25 * CelestiaLib.Vgui.Width, 25 * CelestiaLib.Vgui.Height, 0, 25 * CelestiaLib.Vgui.Height)
    left_panel:SetWide(500 * CelestiaLib.Vgui.Width)
    left_panel.Paint = function(self, w, h)
    end
    local left_panel_title = vgui.Create("DLabel", left_panel)
    left_panel_title:Dock(TOP)
    left_panel_title:DockMargin(0, 0, 0, 0)
    left_panel_title:SetTall(50 * CelestiaLib.Vgui.Height)
    left_panel_title:SetText("Liste des staffs")
    left_panel_title:SetFont(CelestiaLib.GetFont("celestia_lib_window_count"))
    left_panel_title:SetTextColor(color_white)
    left_panel_title:SetContentAlignment(5)

    local left_panel_scroll = vgui.Create("DScrollPanel", left_panel)
    left_panel_scroll:Dock(FILL)
    left_panel_scroll:DockMargin(0, 0, 0, 0)
    left_panel_scroll.Paint = function(self, w, h)
    end
    local left_panel_scroll_bar = left_panel_scroll:GetVBar()
    left_panel_scroll_bar:SetWide(5 * CelestiaLib.Vgui.Width)
    left_panel_scroll_bar.Paint = function(self, w, h)
        surface.SetDrawColor(CelestiaLib.Colors["celestia_border"])
        surface.DrawRect(0, 0, w, h)
    end
    left_panel_scroll_bar.btnUp.Paint = function(self, w, h)
        surface.SetDrawColor(CelestiaLib.Colors["celestia_details"])
        surface.DrawRect(0, 0, w, h)
    end
    left_panel_scroll_bar.btnDown.Paint = function(self, w, h)
        surface.SetDrawColor(CelestiaLib.Colors["celestia_details"])
        surface.DrawRect(0, 0, w, h)
    end

    local left_panel_scroll_bar_btn_grip = left_panel_scroll_bar.btnGrip
    left_panel_scroll_bar_btn_grip.Paint = function(self, w, h)
        surface.SetDrawColor(CelestiaLib.Colors["celestia_details"])
        surface.DrawRect(0, 0, w, h)
    end

    local staffs = {}

    for k, v in ipairs(rating) do
        if not staffs[v.staff] then
            staffs[v.staff] = v.staff_name
        end
    end

    for k, v in pairs(staffs) do
        local button = vgui.Create("DButton", left_panel_scroll)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5 * CelestiaLib.Vgui.Height)
        button:SetTall(50 * CelestiaLib.Vgui.Height)
        button:SetText("")
        button.Paint = function(self, w, h)
            if self:IsHovered() then
                surface.SetDrawColor(CelestiaLib.Colors["celestia_details"])
                surface.DrawRect(0, 0, w, h)
            end
            draw.SimpleText(v, CelestiaLib.GetFont("celestia_lib_window_desc"), 10 * CelestiaLib.Vgui.Width, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function()
            draw_stars(frame, right_panel, rating, k)
        end
    end

end

net.Receive("celestia_ticket_open_panel", function()
    local bytes_amount = net.ReadUInt(16)
    local compressed_data = net.ReadData(bytes_amount)

    local data = util.Decompress(compressed_data)
    data = util.JSONToTable(data)

    if not data then return end

    draw_stats_panel(data)
end)

CelestiaLib.Hook.Add("OnPlayerChat", "CelestiaOpenAdminPanel", function(ply, text, teamChat, isDead)
    if text ~= "/ticket_admin" then return end
    if ply ~= LocalPlayer() then return end

    net.Start("celestia_ticket_open_panel")
    net.SendToServer()
end)