hook.Add("PlayerInitialSpawn", "CheckConnectionSpam", function(ply)
    ply.connectionAttempts = (ply.connectionAttempts or 0) + 1
    local connectionThreshold = 5
    if ply.connectionAttempts > connectionThreshold then
        ply:Ban(3600, "Connexion excessive")
        print("Le joueur " .. ply:Nick() .. " a été banni pour connexion excessive.")
    end
end)