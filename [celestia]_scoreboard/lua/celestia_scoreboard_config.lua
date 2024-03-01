CelestiaScoreboard = CelestiaScoreboard or {}


CelestiaScoreboardConfig = {
    ["superadmin"] = "icon16/shield.png",
    ["rs"] = "icon16/shield.png",
    ["gs"] = "icon16/shield.png",
    ["cm"] = "icon16/shield.png",
    ["admin"] = "icon16/shield.png",
    ["modo"] = "icon16/shield.png",
    ["modo-app"] = "icon16/shield.png",
    --["animateur"] = "icon16/shield.png",
    --["serpentard"] = "celestia/scoreboard/serpentard.png",
    --["gryffondor"] = "celestia/scoreboard/gryffondor.png",
    --["poufsouffle"] = "celestia/scoreboard/poufsouffle.png",
    --["serdaigle"] = "celestia/scoreboard/serdaigle.png",
    ["vip"] = "icon16/star.png",
    ["user"] = "icon16/user.png",
    StaffRoles = {
        "superadmin",
        "rs",
        "gs",
        "cm",
        "modo",
        "modo-app",
    }
}

CelestiaScoreboardConfig.StaffOptions = {
    {command = "sam kick", icon = "icon16/user_orange.png", label = "Kick"},
    {command = "sam ban", icon = "icon16/user_red.png", label = "Ban"},
    {command = "sam spectate", icon = "icon16/eye.png", label = "Spectate"},
    {command = "sam goto", icon = "icon16/user_go.png", label = "Goto"},
    {command = "sam bring", icon = "icon16/user_go.png", label = "Bring"},
    {command = "sam jail", icon = "icon16/lock.png", label = "Jail"},
    {command = "sam unjail", icon = "icon16/lock_open.png", label = "Unjail"},
    {command = "sam freeze", icon = "icon16/weather_snow.png", label = "Freeze"},
    {command = "sam unfreeze", icon = "icon16/weather_sun.png", label = "Unfreeze"},
    {command = "sam strip", icon = "icon16/wrench.png", label = "Strip Weapons"},
    {command = "sam gag", icon = "icon16/user.png", label = "Gag"},
    {command = "sam ungag", icon = "icon16/user.png", label = "Ungag"},
    {command = "sam respawn", icon = "icon16/user.png", label = "Respawn"},
}

CelestiaScoreboardConfig.titleText = {
    "",
}


