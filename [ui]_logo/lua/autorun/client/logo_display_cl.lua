local logoURL = "https://i.imgur.com/0JEbWvp.png" 
local logoSizePercent = 0.07 
local posXOffset = 1750 
local posYOffset = 50 
local function updateLogo(myLogo)
    local screenWidth = ScrW()
    local screenHeight = ScrH()

    local logoWidth = screenWidth * logoSizePercent
    local logoHeight = logoWidth

    myLogo:SetSize(logoWidth, logoHeight)

    local posX = screenWidth - logoWidth - posXOffset
    local posY = posYOffset
    myLogo:SetPos(posX, posY)
end

hook.Add("InitPostEntity", "AddLogoToScreen", function()
    local myLogo = vgui.Create("DHTML")
    updateLogo(myLogo)
    myLogo:SetHTML([[
        <body style="margin:0; padding:0;">
        <img src="]] .. logoURL .. [[" style="width:100%; height:100%;">
        </body>
    ]])
    hook.Add("OnScreenSizeChanged", "UpdateLogoOnScreenResize", function(oldWidth, oldHeight)
        updateLogo(myLogo)
    end)
end)