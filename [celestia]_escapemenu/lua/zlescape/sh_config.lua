ZLibs = ZLibs or {}
ZLConfig = ZLConfig or {}
-- Constantes de couleur / Tenez le site si vous voulez changer les couleur https://htmlcolorcodes.com/fr/ prennez la couleur RGB
ZLConfig.Colors = {
    BackgroundStart = Color(20, 20, 20, 255),
    BackgroundEnd = Color(33, 33, 33, 0),
    ButtonHovered = Color(100, 100, 100, 255),
    ButtonNormal = Color(255, 255, 255, 255),
    TextShadow = Color(0, 0, 0, 127),
}

--Tables des icons si vous souhaiter mettre une icons placer votre images dans le dossier materials/images/votre image.png ensuite remplacer les //////// par le nom de votre image.png
ZLibs.EscapeIcon = {
    ["Reprendre_icon"] = Material("materials/images/coeur.png", "noclamp smooth"),
    ["Discord_icon"] = Material("materials/images///////", "noclamp smooth"),
    ["Workshop_icon"] = Material("materials/images///////", "noclamp smooth"),
    ["Restart_icon"] = Material("materials/images///////", "noclamp smooth"),
    ["Boutique_icon"] = Material("materials/images///////", "noclamp smooth"),
    ["Quitter_icon"] = Material("materials/images///////", "noclamp smooth"), 
}

-- Emplacement / Nom des boutons  (Laisser 40 D'espace si vous souhaiter concerver cette apparence) Si vous ne souhaiter pas mettre d'icons laisser un vide entre les ""
ZLConfig.Buttons = {
    Resume = {Text = "Reprendre", X = 15, Y = 400, Visible = true, Icon = "Reprendre_icon"}, --
    Discord = {Text = "Discord", X = 15, Y = 450, Visible = true, Icon = ""},
    Workshop = {Text = "Workshop", X = 15, Y = 490, Visible = true, Icon = ""},
    Restart = {Text = "Redémarrer", X = 15, Y = 530, Visible = true, Icon = ""},
    Boutique = {Text = "Boutique", X = 15, Y = 610, Visible = true, Icon = ""},
    Quit = {Text = "Quitter", X = 15, Y = 570, Visible = true, Icon = ""},
}


-- Configurations du Titre
ZLConfig.Titre = {
    Text = "Astres",
    X = 10, -- Position gauche/droite
    Y = 150, -- Positions haut/bas 
    Size = 150,
    Width = 500, -- Augmenter si le nom apparait pas au complet
}

-- Constantes de la fenêtre
ZLConfig.Window = {
    Width = 400,
    Height = 1200,
    Title = "",
}

--Creations simplifier de boutons
ZLConfig.CreateButtons = {
    {
        Text = "Bouton 1", -- Nom du bouton
        X = 10, -- Position gauche/droite
        Y = 650, -- Positions haut/bas  
        Command = "noclip", -- La commande qui doit être exécutée
        Visible = true, -- Si le bouton est activé ou non
        UserRanks =  {"admin", "superadmin"}, -- Pour quels rangs est-il visible
        Icon = "discord_icon" -- Clé de l'icône correspondante dans la table ZLibs.EscapeIcon
    },
    {
        Text = "Bouton 2", -- Nom du bouton
        X = 10, -- Position gauche/droite
        Y = 690, -- Positions haut/bas
        Link = "https://example.com", -- Le lien qui doit être exécuté
        Visible = true, -- Si le bouton est activé ou non
        UserRanks =  {"admin", "superadmin"}, -- Pour quels rangs est-il visible
        Icon = "workshop_icon" -- Clé de l'icône correspondante dans la table ZLibs.EscapeIcon
    },
    -- Ajoutez d'autres boutons ici selon le format ci-dessus
}


--Config d'un logo de votre choix
ZLConfig.Window.Logo = {
    Path = "materials/images/coeur.png",
    X = 50,    -- Position gauche/droite
    Y = 50,    -- Positions haut/bas 
    Width = 100,  -- Largeur du logo
    Height = 100,  -- Hauteur du logo
    Visible = false -- si le logo est visible oui ou non
}

--Lien de votre discord boutique workshop
ZLConfig.DiscordLink = "https://discord.gg/astresrp"
ZLConfig.WorkshopLink = "https://steamcommunity.com/workshop/3048086972"
ZLConfig.BoutiqueLink = "https://astres.tebex.io/"
