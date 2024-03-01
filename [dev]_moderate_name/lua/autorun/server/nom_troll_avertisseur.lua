-- Configuration
local motsTrolls = {"nazi", "hitler", "ntm"} -- Liste des mots considérés comme trolls

-- Fonction pour vérifier si un nom est troll
local function estNomTroll(nomJoueur)
    for _, mot in ipairs(motsTrolls) do
        if string.find(string.lower(nomJoueur), string.lower(mot)) then
            return true
        end
    end
    return false
end

-- Fonction pour avertir un joueur
local function avertirJoueur(joueur)
    joueur:ChatPrint("Attention : Votre nom pourrait être considéré comme troll. Choisissez un nom approprié.")
end

-- Hook appelé à chaque fois qu'un joueur rejoint le serveur
hook.Add("PlayerInitialSpawn", "VerifNomTroll", function()
    for _, joueur in ipairs(player.GetAll()) do
        local nomJoueur = joueur:Nick()
        if estNomTroll(nomJoueur) then
            avertirJoueur(joueur)
        end
    end
end)

-- Hook appelé à chaque fois qu'un joueur change son nom
hook.Add("OnPlayerChangedName", "AC_VerifNomTroll", function(joueur, ancienNom, nouveauNom)
    if estNomTroll(nouveauNom) then
        avertirJoueur(joueur)
    end
end)