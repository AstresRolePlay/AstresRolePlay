Celestia_contextmenu = Celestia_contextmenu or {}

Celestia_contextmenu.AdminRank = {
    ["superadmin"] = true,
    ["gs"] = true,
    ["rs"] = true,
    ["admin"] = true,
    ["modo"] = true,
    ["modo-app"] = true
}

Celestia_contextmenu.DisableContextGmod        = true 

Celestia_contextmenu.EnableContextGmodAdmin    = true 

Celestia_contextmenu.InformationsTimings = 120 

Celestia_contextmenu.InformationsText = { -- (info_img_hud_Celestia, info2_img_hud_Celestia, info3_img_hud_Celestia) sont les images de fond, vous pouvez en ajouter d'autres dans le dossier "materials/hud_Celestia" et le rajouter dans sh_materials.lua
    {
        image = "info_img_hud_Celestia",
        text = "Bienvenue sur le serveur !",
    },
    {
        image = "info_img2_hud_Celestia",
        text = "N'oubliez pas de lire les règles ! En effet, si vous ne les respectez pas, vous serez sanctionné !",
    },
    {
        image = "info_img3_hud_Celestia",
        text = "Amusez vous bien !",
    },
    {
        image = "info_img_hud_Celestia",
        text = "N'oubliez pas d'aller en cours!",
    }
}