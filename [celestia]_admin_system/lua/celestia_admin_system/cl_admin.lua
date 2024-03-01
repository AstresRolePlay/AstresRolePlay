if SERVER then return end

local admin_active = false
local imageX, imageY = 0, 0
local imageWidth, imageHeight = 100, 100
local animationSpeed = 2


net.Receive("sam_admin_mode", function()
    admin_active = net.ReadBool()
end)

local function IsAllowedRank(player)
    if not player:IsValid() or not player:IsPlayer() then return false end

    local playerRank = player:GetUserGroup()
    return CelestiaAdminConfig.AdminRank[playerRank] == true
end

CelestiaLib.AddFont("CelestiaContextInformation", "Lato", 5, 500, true, false, false)


local function DrawRainbowText(x, y, text, font, align, textSize)
    surface.SetFont(font)
    local textWidth, textHeight = surface.GetTextSize(text)

    if textSize then
        surface.SetTextColor(255, 255, 255)
        surface.SetTextPos(x, y)
        surface.DrawText(text)
    else
        local col = Color(255, 255, 255)
        draw.SimpleText(text, font, x, y, col, align)
    end
end

local function DrawFilledCircle(x, y, radius, color, segments)
    local segments = segments or 360
    local poly = {}

    for i = 0, segments do
        local angle = math.rad((i / segments) * 360)
        local circlePoint = {
            x = x + math.cos(angle) * radius,
            y = y + math.sin(angle) * radius
        }
        table.insert(poly, circlePoint)
    end

    draw.NoTexture()
    surface.SetDrawColor(color.r or 8, color.g or 21, color.b or 25)
    surface.DrawPoly(poly)

    return poly
end

local function DrawPlayerNameAndCircle(ply, pos, jobColor)
    local screenPos = pos:ToScreen()
    if not screenPos.visible then return end

    local distance = LocalPlayer():GetPos():Distance(ply:GetPos())

    if distance > 450 then
        local text = ply:Nick()
        draw.SimpleText(text, "CelestiaContextInformation", screenPos.x, screenPos.y - 30, Color(255, 255, 255), TEXT_ALIGN_CENTER)

        if ply:sam_get_play_time() < 2 * 24 * 60 * 60 then
            draw.SimpleText("Nouveau Joueur", "CelestiaContextInformation", screenPos.x, screenPos.y - 45, Color(255, 0, 0), TEXT_ALIGN_CENTER)
        end

        local radius = 12 * CelestiaLib.Vgui.Width
        DrawFilledCircle(screenPos.x, screenPos.y, radius, jobColor)
    end
end

local function DrawPlayerPoints()
    local localplayer = LocalPlayer()
    if not IsValid(localplayer) then return end

    local screenWidth, screenHeight = ScrW(), ScrH()

    if admin_active and IsAllowedRank(localplayer) then
        local message = "Vous êtes en Admin"
        local font = "CelestiaAdminTexT"
        local textSize = ScreenScale(35)
    
        surface.SetFont(font)
        local textWidth, textHeight = surface.GetTextSize(message)
    
        local centerX, centerY = screenWidth / 2, screenHeight / 2
        local offsetX, offsetY = 0, -400
    
        local x, y = centerX - textWidth / 2 + offsetX, centerY - textHeight / 2 + offsetY
    
        DrawRainbowText(x, y, message, font, TEXT_ALIGN_LEFT, textSize)

        -- Draw "Rester discret" below "Vous êtes en Admin"
        local discreetMessage = "attention n'oublier pas de rester discret"
        local discreetFont = "CelestiaAdminTexT2"
        local discreetTextSize = ScreenScale(25)

        surface.SetFont(discreetFont)
        local discreetTextWidth, discreetTextHeight = surface.GetTextSize(discreetMessage)

        local discreetX = centerX - discreetTextWidth / 2 + offsetX
        local discreetY = y + textHeight + 10 -- Adjust the offset to place it below the "Vous êtes en Admin" message

        DrawRainbowText(discreetX, discreetY, discreetMessage, discreetFont, TEXT_ALIGN_LEFT, discreetTextSize)
    
        local adminImage = Material("celestia/admin/logo_admin.png")
        surface.SetMaterial(adminImage)
    
        local centerX = x + 65
        local centerY = y - 75

        local currentTime = RealTime()
        local angle = math.sin(currentTime * animationSpeed) * 10

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(adminImage)

        local rotationMatrix = Matrix()
        rotationMatrix:Translate(Vector(centerX, centerY, 0))
        rotationMatrix:Rotate(Angle(0, angle, 0))
        rotationMatrix:Translate(Vector(-imageWidth / 2, -imageHeight / 2, 0))

        cam.PushModelMatrix(rotationMatrix)
        surface.DrawTexturedRect(45, 45, imageWidth, imageHeight)
        cam.PopModelMatrix()
    end
    
    if not admin_active or not IsAllowedRank(localplayer) then return end

    local players = player.GetAll()

    for _, ply in ipairs(players) do
        if ply:Alive() and ply ~= localplayer then
            local pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 10)

            if localplayer:GetPos():DistToSqr(pos) > 2500 then
                local jobColor = team.GetColor(ply:Team())
                DrawPlayerNameAndCircle(ply, pos, jobColor)
            end
        end
    end
end

hook.Add("HUDPaint", "sam_admin_mode", DrawPlayerPoints)