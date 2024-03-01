local Icon = Material("mellow_lib/ui/micro/logo.png")
local VoiceIsActived = false
local PlayerVoicePanels = {}

function draw.RotatedBox( x, y, w, h )

	local Rotating = math.sin(CurTime() * 3)
        local backwards = 0

        if Rotating < 0 then
            Rotating = 1 - (1 + Rotating)
           backwards = 1
       end
		
	surface.SetMaterial(Icon)
	surface.SetDrawColor(color_white )
	surface.DrawTexturedRectRotated( x, y, Rotating * 64, 64,  backwards )
end

hook.Add( "HUDPaint", "MicIcon_HUD", function()
		if VoiceIsActived then

	draw.RotatedBox( ScrW()-55, ScrH()/2-32, 64, 64)
		end
end )

--[[----------------
	Radar: Voice
----------------]]--

hook.Add("PlayerStartVoice", "MicIcon_EnableVoice", function(ply)
	Material("voice/icntlk_pl"):SetFloat("$alpha", 0)
	if ply == LocalPlayer() then
		VoiceIsActived = true
	end
end)

hook.Add("PlayerEndVoice", "MicIcon_DisableVoice", function(ply)
	if ply == LocalPlayer() then
		VoiceIsActived = false
	end
end)