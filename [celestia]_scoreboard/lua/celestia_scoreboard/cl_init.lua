if SERVER then return end

hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
hook.Remove("ScoreboardShow", "FAdmin_scoreboard")

local scoreBoard = nil

local function OpenScoreboard()
    if not IsValid(scoreBoard) then
        scoreBoard = vgui.Create("DFrame")
        scoreBoard:SetSize(ScrW() * 0.8, ScrH() * 0.8)
        scoreBoard:Center()
        scoreBoard:SetTitle("")
        scoreBoard:SetDraggable(false)
        scoreBoard:ShowCloseButton(false)
        scoreBoard:MakePopup()
        scoreBoard.Paint = function(self, w, h)
            local backgroundMaterial = Material("celestia/scoreboard/background_scoreboard.png") -- Replace with the path to your image
            surface.SetMaterial(backgroundMaterial)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)

            surface.SetDrawColor(CelestiaLib.Colors["celestia_border"])
            surface.DrawOutlinedRect(0, 0, w, h, 5 * CelestiaLib.Vgui.Width)
        end
    end

        local title = vgui.Create("DLabel", scoreBoard)
        title:Dock(TOP)
        title:SetFont("celestia_lib_window_title")
        title:SetText(CelestiaScoreboardConfig.titleText[1]) 
        title:SetContentAlignment(5)
        title:SizeToContents()

        local players = player.GetAll()

        -- Sort all players by job and then by name
        table.sort(players, function(a, b)
            if a:getDarkRPVar("job") == b:getDarkRPVar("job") then
                return a:Nick() < b:Nick()
            else
                return a:getDarkRPVar("job") < b:getDarkRPVar("job")
            end
        end)

        local playerList = vgui.Create("DScrollPanel", scoreBoard)
        playerList:Dock(FILL)
        playerList:DockMargin(80 * CelestiaLib.Vgui.Width, 40 * CelestiaLib.Vgui.Height, 50 * CelestiaLib.Vgui.Width, 70 * CelestiaLib.Vgui.Height)
        playerList.Paint = function(self, w, h)
        end
        local scrollbar = playerList:GetVBar()
        scrollbar:SetWide(10 * CelestiaLib.Vgui.Width)
        scrollbar.Paint = function(self, w, h)
            surface.SetDrawColor(CelestiaLib.Colors["celestia_details"])
            surface.DrawRect(0, 0, w, h)
        end

        for _, ply in pairs(players) do
            local jobColor = team.GetColor(ply:Team())
            local playerPanel = vgui.Create("DButton", playerList)
            playerPanel:Dock(TOP)
            playerPanel:SetTall(55 * CelestiaLib.Vgui.Height)
            playerPanel:SetText("")
        
            playerPanel.Paint = function(self, w, h)
                -- Draw the background color
                surface.SetDrawColor(jobColor)
                surface.DrawRect(0, 0, w - 10 * CelestiaLib.Vgui.Width, h)
        
                -- Draw the outline
                surface.SetDrawColor(CelestiaLib.Colors["celestia_border"])
                surface.DrawOutlinedRect(0, 0, w - 10 * CelestiaLib.Vgui.Width, h, 2.5 * CelestiaLib.Vgui.Width)
            end
            playerPanel.OnMousePressed = function(self, key)
                if key == MOUSE_LEFT then
                    if IsValid(ply) then
                        local player_menu = DermaMenu(playerPanel)
                        player_menu:SetPos(gui.MousePos())
                        player_menu:MakePopup()
                        player_menu:AddOption("Copy Name", function()
                            SetClipboardText(ply:Nick())
                        end):SetIcon("icon16/user.png")
                        player_menu:AddOption("Copy SteamID", function()
                            SetClipboardText(ply:SteamID())
                        end):SetIcon("icon16/user.png")
                        player_menu:AddOption("Open Profile", function()
                            ply:ShowProfile()
                        end):SetIcon("icon16/report_user.png")

                        hook.Add("CelestiaScoreboard_PlayerMenu", "AddChangeJobOption", function(ply, player_menu)
                            -- Vérifiez si le joueur a le rôle "staff"
                            local hasStaffRole = false
                            for _, role in ipairs(CelestiaScoreboardConfig.StaffRoles) do
                                if LocalPlayer():IsUserGroup(role) then
                                    hasStaffRole = true
                                    break
                                end
                            end
                        
                            -- Vérifiez si le joueur a la permission de changer de métier
                            local hasPermission = false
                            for _, option in ipairs(CelestiaScoreboardConfig.StaffOptions) do
                                if LocalPlayer():CheckGroup(option.command) then
                                    hasPermission = true
                                    break
                                end
                            end
                        
                            -- Si le joueur est différent de vous-même, a le rôle "staff" et a la permission, ajoutez la catégorie "Changer de métier"
                            if ply ~= LocalPlayer() and hasStaffRole and hasPermission then
                                local changeJobOption, changeJobOptionIcon = player_menu:AddSubMenu("Changer de métier")
                                changeJobOptionIcon:SetIcon("icon16/user_edit.png")
                        
                                for k, v in SortedPairsByMemberValue(RPExtraTeams, "name") do
                                    changeJobOption:AddOption(v.name, function()
                                        RunConsoleCommand("_FAdmin", "setteam", ply:UserID(), k)
                                    end):SetIcon("icon16/user_edit.png")
                                end
                            end
                        end)
                        
                        
                        local isPlayerStaff = false
                        local localPlayer = LocalPlayer()
                        local staffRoles = CelestiaScoreboardConfig.StaffRoles
                        
                        for _, role in pairs(staffRoles) do
                            if localPlayer:IsUserGroup(role) then
                                isPlayerStaff = true
                                break
                            end
                        end
        
                        if isPlayerStaff then -- Vérification de l'appartenance au groupe du joueur local
                            for _, staffOption in ipairs(CelestiaScoreboardConfig.StaffOptions) do
                                player_menu:AddSpacer()
                                player_menu:AddOption(staffOption.label, function()
                                    local command = staffOption.command .. " " .. ply:Nick()
                                    RunConsoleCommand(unpack(string.Explode(" ", command)))
                                    scoreBoard:Close()
                                end):SetIcon(staffOption.icon)
                            end
                        end
                    end
                end
            end

            local avatar = vgui.Create("AvatarImage", playerPanel)
            avatar:Dock(LEFT)
            avatar:SetWide(50 * CelestiaLib.Vgui.Width)
            avatar:SetPlayer(ply, 50)
            avatar.PaintOver = function(self, w, h)
                surface.SetDrawColor(CelestiaLib.Colors["celestia_border"])
                surface.DrawOutlinedRect(0, 0, w, h, 2.5 * CelestiaLib.Vgui.Width)
            end

            local rank_icon = vgui.Create("DImage", playerPanel)

            rank_icon:Dock(LEFT)
            rank_icon:DockMargin(10 * CelestiaLib.Vgui.Width, 12.5 * CelestiaLib.Vgui.Height, 0, 12.5 * CelestiaLib.Vgui.Height)
            rank_icon:SetWide(25 * CelestiaLib.Vgui.Width)

            local usergroup = ply:GetNWString("usergroup")
            local imageFile = CelestiaScoreboardConfig[usergroup]
            
            if imageFile then
                rank_icon:SetImage(imageFile)
            else
                rank_icon:SetImage("celestia/scoreboard/user.png")
            end
            local name = vgui.Create("DLabel", playerPanel)
            local textColor = Color(10, 10, 10, 200) -- Change color to black
            local outlineColor = Color(240, 240, 240, 200) -- Couleur du contour (noir)
            local outlineSize = 2 -- Épaisseur du contour en pixels
            
            name:Dock(LEFT)
            name:DockMargin(10 * CelestiaLib.Vgui.Width, 12.5 * CelestiaLib.Vgui.Height, 0, 12.5 * CelestiaLib.Vgui.Height)
            name:SetFont("celestia_scoreboard_text")
            name:SetText(ply:Nick())
            name:SetContentAlignment(4)
            name:SetWide(700 * CelestiaLib.Vgui.Width)
            
            -- Le contour ne peut pas être défini directement avec DLabel, donc nous utilisons draw.SimpleTextOutlined
            local x, y = name:GetPos()
            draw.SimpleTextOutlined(ply:Nick(), "celestia_scoreboard_text", x, y, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, outlineSize, outlineColor)
            
            -- Pour définir la couleur du texte, vous pouvez utiliser SetColor comme suit :
            name:SetColor(textColor)

           local job_name = vgui.Create("DLabel", playerPanel)
           local textColor = Color(10, 10, 10, 200) -- Change color to black
           local outlineColor = Color(240, 240, 240, 200) -- Couleur du contour (noir)
           local outlineSize = 2 -- Épaisseur du contour en pixels
           
           job_name:Dock(FILL)
           job_name:SetFont("celestia_scoreboard_text")
           job_name:SetText(ply:getDarkRPVar("job"))
           job_name:SetContentAlignment(5)
           job_name:DockMargin(0, 0, 800 * CelestiaLib.Vgui.Width, 0)  -- Ajustez la marge ici pour déplacer vers la gauche
                      
           -- Le contour ne peut pas être défini directement avec DLabel, donc nous utilisons draw.SimpleTextOutlined
           local x, y = job_name:GetPos()
           draw.SimpleTextOutlined(ply:getDarkRPVar("job"), "celestia_scoreboard_text", x, y, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlineSize, outlineColor)
                      
           -- Pour définir la couleur du texte, vous pouvez utiliser SetColor comme suit :
           job_name:SetColor(textColor)

            function GetXPPercent(player)
                return math.random() 
            end

            local xp_label = vgui.Create("DLabel", playerPanel)
            local textColor = Color(10, 10, 10, 200) -- Change color to black
            local outlineColor = Color(240, 240, 240, 200) -- Couleur du contour (noir)
            local xp_outlineSize = 2 -- Épaisseur du contour en pixels
            
            xp_label:Dock(FILL)
            xp_label:SetFont("celestia_scoreboard_text")
            
            local level = ply:getDarkRPVar('level') or 0 -- Utilisez 0 par défaut si 'level' est nil
            local percent = GetXPPercent(ply) -- Remplacez par votre fonction pour obtenir le pourcentage d'XP
            
            local textToShow =  "Niveau: " .. level .. ""
            xp_label:SetText(textToShow)
            xp_label:SetContentAlignment(5)
            xp_label:DockMargin(350 * CelestiaLib.Vgui.Width, 0, 25 * CelestiaLib.Vgui.Width, 0)  -- Ajustez la marge ici pour déplacer encore plus vers la droite
            
            -- Le contour ne peut pas être défini directement avec DLabel, donc nous utilisons draw.SimpleTextOutlined
            local xp_x, xp_y = xp_label:GetPos()
            draw.SimpleTextOutlined(textToShow, "celestia_scoreboard_text", xp_x, xp_y, xp_textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, xp_outlineSize, xp_outlineColor)
            
            xp_label:SetColor(textColor)
            

           local ping = ply:Ping()

           local ping_icon = vgui.Create("DImage", playerPanel)
           ping_icon:Dock(RIGHT)
           ping_icon:DockMargin(0, 12.5 * CelestiaLib.Vgui.Height, 20 * CelestiaLib.Vgui.Width, 12.5 * CelestiaLib.Vgui.Height)
           ping_icon:SetWide(25 * CelestiaLib.Vgui.Width)
           if ping < 40 then
               ping_icon:SetImage("celestia/scoreboard/ping.png")
           elseif ping < 100 then
               ping_icon:SetImage("celestia/scoreboard/ping_2.png")
           else
               ping_icon:SetImage("celestia/scoreboard/ping_3.png")
           end
           
           local ping_label = vgui.Create("DLabel", playerPanel)
           local textColor = Color(10, 10, 10, 200)
           local outlineColor = Color(240, 240, 240, 200) 
           local outlineSize = 2 
           
           ping_label:Dock(RIGHT)
           ping_label:DockMargin(0, 12.5 * CelestiaLib.Vgui.Height, 20 * CelestiaLib.Vgui.Width, 12.5 * CelestiaLib.Vgui.Height)
           ping_label:SetFont("celestia_scoreboard_text")
           ping_label:SetText(ping)
           ping_label:SetContentAlignment(6)
           ping_label:SetWide(800 * CelestiaLib.Vgui.Width)
           local x, y = ping_label:GetPos()
           draw.SimpleTextOutlined(ping, "celestia_scoreboard_text", x, y, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, outlineSize, outlineColor)
           ping_label:SetColor(textColor)           
        end
    end

hook.Add("ScoreboardShow", "celestia_scoreboard_open", function()
    if not IsValid(scoreBoard) then
        OpenScoreboard()
    end
    return true
end)

hook.Add("ScoreboardHide", "celestia_scoreboard_hide", function()
    if scoreBoard then
        scoreBoard:Remove()
    end
    return true
end)