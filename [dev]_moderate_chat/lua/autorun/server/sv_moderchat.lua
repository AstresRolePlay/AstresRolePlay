hook.Add("PlayerSay", "ModerateChat", function(ply, text)
    -- Liste des mots interdits (à personnaliser)
    local bannedWords = {"ntm", "pd", "pute"}

    -- Vérifier si le message contient des mots interdits
    for _, word in pairs(bannedWords) do
        if string.find(string.lower(text), string.lower(word)) then
            -- Bannir le joueur en cas de match
            ply:Ban(60, "Insulte dans le chat")
            return ""
        end
    end
end)