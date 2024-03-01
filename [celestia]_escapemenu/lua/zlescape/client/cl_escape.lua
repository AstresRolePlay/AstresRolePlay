
function createButton(parent, buttonInfo, onClick)
   if not buttonInfo.Visible then
      return
   end
   local button = vgui.Create('DButton', parent)
   button:SetSize(250, 30)
   button:SetPos(buttonInfo.X, buttonInfo.Y)
   button:SetText("")
   button.Paint = function(self, w, h)
       if self:IsHovered() then
           draw.RoundedBox(20, 0, 0, w, h, Color(51, 51, 51, 0))
           self:SetTextColor(Color(100, 100, 100, 255))
       else
           draw.RoundedBox(20, 0, 0, w, h, Color(51, 51, 51, 0))
           self:SetTextColor(Color(255, 255, 255, 255))
       end
       if buttonInfo.Icon then
           local iconMaterial = ZLibs.EscapeIcon[buttonInfo.Icon]
           if iconMaterial then
               surface.SetMaterial(iconMaterial)
               surface.SetDrawColor(255, 255, 255, 255)
               surface.DrawTexturedRect(5, (h - 16) / 2, 16, 16) -- Modifier les valeurs pour ajuster la position et la taille de l'icône
           end
       end
       drawAncientText(buttonInfo.Text, "Escape", 25, 0, self:GetTextColor()) 
   end
   button.DoClick = onClick
   return button
end

esc = esc or {}
include("cl_fonts.lua")
local frame
local isMainMenuVisible = false
local BlurBackground
local animationStartTime
local initialMenuPos

hook.Add("PreRender", "esc menu", function()
   if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
      gui.HideGameUI()
      if IsValid(frame) then
         frame:Close()
         gui.EnableScreenClicker(false)
         isMainMenuVisible = false
         if IsValid(BlurBackground) then
            BlurBackground:Remove()
         end
      else
         gui.HideGameUI()
         esc.openMenu(Vector(0, 0, 0))  
      end
   end
end)

esc.openMenu = function(pos)
   gui.EnableScreenClicker(true)
   isMainMenuVisible = true

   BlurBackground = vgui.Create("DFrame")
   BlurBackground:SetSize(1, 1)
   BlurBackground:SetPos(0, 0)
   BlurBackground:SetBackgroundBlur(true)

   frame = vgui.Create('DFrame')
   frame:SetSize(400, 1200)
   frame:SetTitle(" ")
   frame:SetDraggable(false)
   frame:ShowCloseButton(false)
   frame:SetPos(pos.x - frame:GetWide(), pos.y)  
   initialMenuPos = pos - Vector(frame:GetWide(), 0, 0)
   animationStartTime = RealTime()  
   frame:MakePopup()

   frame.Paint = function(self, w, h)
      local x, y = 0, 0
      local width, height = ZLConfig.Window.Width, ZLConfig.Window.Height
      local colorStart, colorEnd = ZLConfig.Colors.BackgroundStart, ZLConfig.Colors.BackgroundEnd
  
      drawHorizontalGradient(x, y, width, height, colorStart, colorEnd)
      
      local logoZLConfig = ZLConfig.Window.Logo
      if logoZLConfig.Path and logoZLConfig.Visible then
          surface.SetMaterial(Material(logoZLConfig.Path))
          surface.SetDrawColor(255, 255, 255, 255)
          surface.DrawTexturedRect(logoZLConfig.X, logoZLConfig.Y, logoZLConfig.Width, logoZLConfig.Height)
      end
  end
  
local titreZLConfig = ZLConfig.Titre

local titleLabel = vgui.Create('DLabel', frame)
titleLabel:SetPos(titreZLConfig.X, titreZLConfig.Y)
titleLabel:SetSize(titreZLConfig.Width, titreZLConfig.Size)
titleLabel:SetText(titreZLConfig.Text)
titleLabel:SetFont('TitreEscape')
titleLabel:SetTextColor(Color(255, 255, 255))
titleLabel:SetExpensiveShadow(1, Color(50, 50, 50))

local createButtonsZLConfig = ZLConfig.CreateButtons

for _, buttonInfo in ipairs(createButtonsZLConfig) do
   local userRank = LocalPlayer():GetUserGroup()

   if buttonInfo.Visible and table.HasValue(buttonInfo.UserRanks, userRank) then
       local iconMaterial = ZLibs.EscapeIcon[buttonInfo.Icon]
       local newButton = createButton(frame, buttonInfo, function()
           if buttonInfo.Command then
               
               RunConsoleCommand(buttonInfo.Command)
           elseif buttonInfo.Link then
               
               gui.OpenURL(buttonInfo.Link)
           end
       end, iconMaterial)
   end
end

   local buttonsZLConfig = ZLConfig.Buttons

local resumeButton = createButton(frame, buttonsZLConfig.Resume, function()
    frame:Close()
    gui.EnableScreenClicker(false)
    isMainMenuVisible = false
end)

local discordButton = createButton(frame, ZLConfig.Buttons.Discord, function()
   isSubmenuVisible = true
   gui.OpenURL(ZLConfig.DiscordLink)
   esc.cleanupMenu()
   gui.EnableScreenClicker(false)
   isMainMenuVisible = false
   isSubmenuVisible = false
end)

local workshopButton = createButton(frame, ZLConfig.Buttons.Workshop, function()
   isSubmenuVisible = true
   gui.OpenURL(ZLConfig.WorkshopLink)
   esc.cleanupMenu()
   gui.EnableScreenClicker(false)
   isMainMenuVisible = false
   isSubmenuVisible = false
end)

local restartButton = createButton(frame, ZLConfig.Buttons.Restart, function()
   RunConsoleCommand('retry')
end)

local boutiqueButton = createButton(frame, ZLConfig.Buttons.Boutique, function()
   isSubmenuVisible = true
   gui.OpenURL(ZLConfig.BoutiqueLink)
   esc.cleanupMenu()
   gui.EnableScreenClicker(false)
   isMainMenuVisible = false
   isSubmenuVisible = false
end)

local quitButton = createButton(frame, ZLConfig.Buttons.Quit, function()
   RunConsoleCommand('disconnect')
   esc.cleanupMenu()
end)


   esc.cleanupMenu = function()
   if IsValid(frame) then
      frame:Remove()
   end

   if IsValid(BlurBackground) then
      BlurBackground:Remove()
   end
end

 frame.OnClose = function()
      isMainMenuVisible = false
      esc.cleanupMenu()
   end
end

hook.Add("Think", "esc menu animation", function()
   if IsValid(frame) and animationStartTime then
      local elapsed = RealTime() - animationStartTime
      local duration = 1.0  

      if elapsed < duration then
         
         local progress = elapsed / duration
         local newX = Lerp(progress, initialMenuPos.x, initialMenuPos.x + frame:GetWide())
         frame:SetPos(newX, initialMenuPos.y)
      else
         
         animationStartTime = nil
         initialMenuPos = nil
      end
   end
end)

   gui.EnableScreenClicker(false)