--[[-----------------

	VIGNN3TIK
	by DyaMetR

	Version 1.1
	15/10/2017

]]-------------------

if CLIENT then

	--[[

		VARIABLES

	]]--

	// CONVARS
	local enabled = CreateClientConVar("vighud_enabled", 1);
	local hev = CreateClientConVar("vighud_hev", 0);

	local ammo = CreateClientConVar("vighud_ammostyle", 0);
	local reserv = CreateClientConVar("vighud_rvstyle", 0);
	local drawammo = CreateClientConVar("vighud_drawammo", 1);

  local ammo0r = CreateClientConVar("vighud_ammo0r", 255);
  local ammo0g = CreateClientConVar("vighud_ammo0g", 0);
  local ammo0b = CreateClientConVar("vighud_ammo0b", 0);

  local ammo1r = CreateClientConVar("vighud_ammo1r", 255);
  local ammo1g = CreateClientConVar("vighud_ammo1g", 255);
  local ammo1b = CreateClientConVar("vighud_ammo1b", 255);

  local ammo2r = CreateClientConVar("vighud_ammo2r", 100);
  local ammo2g = CreateClientConVar("vighud_ammo2g", 255);
  local ammo2b = CreateClientConVar("vighud_ammo2b", 100);

  local ammoSr = CreateClientConVar("vighud_ammoSr", 255);
  local ammoSg = CreateClientConVar("vighud_ammoSg", 255);
  local ammoSb = CreateClientConVar("vighud_ammoSb", 100);

	// HEALTH ANIMATIONS
	local hpanim = 0
	local critanim = 0

	// DAMAGE AND HEALING ANIMATIONS
	local lasthp = 100
	local acum = 0
	local dcanim = 0
	local time = 0

	local nextblink = 0
	local blink = 0
	local blinked = false

	local dmg = 0

	local heal = 0
	local nextheal = 0

	// ARMOR ANIMATIONS
	local lastap = 0
	local apanim = 0
	local maanim = 0
	local nextap = 0
	local new = 0
	local aptime = 0
	local apt = 0

	// AMMO ANIMATIONS
	local lastsec = 0
	local lastclip = 0
	local ammoanim = 0
	local ammoth = 0

	local ammoshow = 0
	local ammotime = 0
	local ammored = 0

	local full = 1

	local types = {
		[3] = {"p",22},
		[5] = {"q",27},
		[4] = {"r",23},
		[1] = {"u",32},
		[7] = {"s",28},
		[6] = {"w",22},
		[10] = {"v",40},
		[8] = {"x",30}
	}

	--[[

		FUNCTIONS

	]]--

	local function Health()

		local hp = LocalPlayer():Health()

		if dcanim < 0.01 then

			hpanim = Lerp(FrameTime()*10, hpanim, math.Clamp(hp-20,0,40)/40)

		end

		if hpanim < 0.9 then

			surface.SetDrawColor(Color(255,255,255))
			surface.SetTexture(surface.GetTextureID("vighud/vignette"))
			surface.DrawTexturedRect(0-(ScrW()*hpanim),0-(ScrH()*hpanim),ScrW()*(1 + 2*hpanim), ScrH()*(1 + 2*hpanim))

		end

		critanim = Lerp(FrameTime()*10, critanim, math.Clamp(hp-10,0,10)/5)

		if critanim < 0.9 then

			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(Material("vighud/vignette_maroon.png"))
			surface.DrawTexturedRect(0-(ScrW()*(0.1+(0.9*critanim))),0-(ScrW()*(0.1+(0.9*critanim))),ScrW()*(1.2 + (1.8*critanim)),ScrH()*(1.5 + (1.5*critanim)))

		end

	end

	local function Damage()

		local hp = LocalPlayer():Health()

		if !LocalPlayer():Alive() then
			lasthp = 100
			time = 0
		end

		// Damage/heal module

		if lasthp != hp then

			if lasthp > hp then

				dmg = 1

				acum = acum + (lasthp - hp)
				time = CurTime() + 3 --+ 3*(1-(hp/100))

			else

				if hp >= lasthp then

					time = 0
					heal = 1

				end

			end

			lasthp = hp

		end

		// Normal damage (when taking too much damage at once)

		if time > CurTime() then

			dcanim = Lerp(FrameTime()*8, dcanim, math.Clamp(acum,0,15)/15)
			acum = 20
			if acum >= 20 then

				if blinked then
					if blink > 0.01 then
						blink = Lerp(FrameTime()*10, blink, 0)
					else
						blinked = false
					end
				else
					if blink < 0.99 then
						blink = Lerp(FrameTime()*10, blink, 1)
					else
						blinked = true
					end
				end
			end

		else

			if dcanim > 0.01 then
				dcanim = Lerp(FrameTime()*2, dcanim, 0)
			else
				if dcanim != 0 then
					dcanim = 0
				end
			end

			if blink > 0.01 then
				blink = Lerp(FrameTime()*20, blink, 0)
			else
				if blink != 0 then
					blink = 0
				end
			end

			if acum != 0 then
				acum = 0
			end

		end

		if dcanim >= 0.01 then
			hpanim = Lerp(FrameTime()*10, hpanim, math.Clamp((math.Clamp(hp-20,0,40)/40) - dcanim,0,1))
		end

		if blink > 0 then

			surface.SetDrawColor(Color(255,255,255,255*blink))
			surface.SetMaterial(Material("vighud/vignette_blink.png"))
			surface.DrawTexturedRect(0-(ScrW()*dcanim),0-(ScrH()*dcanim),ScrW()*(1 + 2*dcanim), ScrH()*(1 + 2*dcanim))

		end

		// Critical damage

		if hp <= 50 then

			if dmg > 0.01 then
				dmg = Lerp(FrameTime()*1, dmg, 0)
			else
				if dmg != 0 then
					dmg = 0
				end
			end

			if dmg > 0.01 then

				surface.SetDrawColor(Color(255,255,255))
				surface.SetTexture(surface.GetTextureID("vighud/vignette_red"))
				surface.DrawTexturedRect(0-(ScrW()*(1-dmg)),0-(ScrH()*(1-dmg)),ScrW()*(1 + 2*(1-dmg)), ScrH()*(1 + 2*(1-dmg)))

			end

		end

	end

	// FONTS

	surface.CreateFont( "vighud_icon", {
	font = "HalfLife2",
	size = 120,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
	})

	surface.CreateFont( "vighud_icon2", {
	font = "HalfLife2",
	size = 120,
	weight = 500,
	blursize = 4,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
	})

	surface.CreateFont( "vighud_num1", {
	font = "Roboto",
	size = 55,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
	})

	surface.CreateFont( "vighud_num2", {
	font = "Roboto",
	size = 55,
	weight = 500,
	blursize = 4,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
	})

	surface.CreateFont( "vighud_big1", {
	font = "Roboto",
	size = 70,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
	})

	surface.CreateFont( "vighud_big2", {
	font = "Roboto",
	size = 70,
	weight = 500,
	blursize = 4,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
	})

	local function HUD()

		if enabled:GetInt() <= 0 then return false end

		Health()
		Damage()

		if drawammo:GetInt() >= 1 and LocalPlayer():GetActiveWeapon() != NULL and LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() >= 0 then
			if ammo:GetInt() <= 0 and LocalPlayer():GetActiveWeapon():Clip1() >= 0 then

				local offset

				if types[LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()] == nil then

					offset = 88

				else

					offset = types[LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()][2]*4

				end

			else

			end
		end

	end
	hook.Add("HUDPaint", "vighud", HUD)

	local tohide = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true
	}
	local function HUDShouldDraw(name)
		if enabled:GetInt() <= 0 then return true end
		if (tohide[name]) then
			return false;
		end
	end
	hook.Add("HUDShouldDraw", "vighud hide", HUDShouldDraw)

end

if SERVER then

	resource.AddFile("vighud/vignette.vmt")
	resource.AddFile("vighud/vignette.vtf")

	resource.AddFile("vighud/vignette_red.vmt")
	resource.AddFile("vighud/vignette_red.vtf")

	resource.AddFile("vighud/vignette_yellow.vmt")
	resource.AddFile("vighud/vignette_yellow.vtf")

	resource.AddFile("vighud/vignette_blue.vmt")
	resource.AddFile("vighud/vignette_blue.vtf")

	resource.AddFile("vighud/vignette_blink.png")
	resource.AddFile("vighud/vignette_maroon.png")

end
