if CLIENT then return end

local ticket_id = 0
local tickets = {}

util.AddNetworkString("celestia_ticket_create_ticket")

net.Receive("celestia_ticket_create_ticket", function(len, ply)
    if not CelestiaLib.Net.Limiter("celestia_ticket_create_ticket", ply) then return end

    local reason = net.ReadString()
    local guilty = net.ReadEntity()

    if not IsValid(guilty) then return end

    CelestiaLib.Net.Debug("celestia_ticket_create_ticket", len, reason, guilty)

    local staff = CelestiaLib.Player.GetStaff(TicketSystemCelestia.Config.Staff)

    ticket_id = ticket_id + 1
    tickets[ticket_id] = {
        reason = reason,
        guilty = guilty,
        creator = ply,
        staff = nil
    }

    if table.IsEmpty(staff) then
        ply:ChatPrint("Aucun membre du staff n'est connecté pour prendre votre ticket. Veuillez vous diriger vers Discord.")
        return
    end

    ply:ChatPrint("Votre ticket a été envoyé au staff.")

    for k, v in pairs(staff) do
        if not IsValid(v) then continue end
        net.Start("celestia_ticket_create_ticket")
            net.WriteEntity(ply)
            net.WriteString(reason)
            net.WriteEntity(guilty)
            net.WriteUInt(ticket_id, 11)
        net.Send(v)
    end
end)

util.AddNetworkString("celestia_ticket_accept_ticket")

net.Receive("celestia_ticket_accept_ticket", function(len, ply)
    if not CelestiaLib.Net.Limiter("celestia_ticket_accept_ticket", ply) then return end

    local ticket_id = net.ReadUInt(11)

    CelestiaLib.Net.Debug("celestia_ticket_accept_ticket", len, ticket_id)

    local staff = CelestiaLib.Player.GetStaff(TicketSystemCelestia.Config.Staff)

    if not tickets[ticket_id] then return end
    tickets[ticket_id].staff = ply

    tickets[ticket_id].creator:ChatPrint("Votre ticket a été accepté par " .. ply:Nick() .. ".")

    for k, v in pairs(staff) do
        if not IsValid(v) then continue end
        if v == ply then continue end

        net.Start("celestia_ticket_accept_ticket")
            net.WriteUInt(ticket_id, 11)
        net.Send(v)
    end
end)

util.AddNetworkString("celestia_ticket_close_ticket")

net.Receive("celestia_ticket_close_ticket", function(len, ply)
    if not CelestiaLib.Net.Limiter("celestia_ticket_close_ticket", ply) then return end

    local ticket_id = net.ReadUInt(11)

    CelestiaLib.Net.Debug("celestia_ticket_close_ticket", len, ticket_id)

    local staff = CelestiaLib.Player.GetStaff(TicketSystemCelestia.Config.Staff)

    if not tickets[ticket_id] then return end

    tickets[ticket_id].creator:ChatPrint("Votre ticket a été fermé par " .. ply:Nick() .. ".")

    net.Start("celestia_ticket_close_ticket")
        net.WriteString(tickets[ticket_id].staff:Nick())
        net.WriteUInt(ticket_id, 11)
    net.Send(tickets[ticket_id].creator)
end)

util.AddNetworkString("celestia_ticket_send_rating")

net.Receive("celestia_ticket_send_rating", function(len, ply)
    if not CelestiaLib.Net.Limiter("celestia_ticket_send_rating", ply) then return end

    local ticket_id = net.ReadUInt(11)
    local rating = net.ReadUInt(3)

    CelestiaLib.Net.Debug("celestia_ticket_send_rating", len, ticket_id, rating)

    if not tickets[ticket_id] then return end

    tickets[ticket_id].staff:ChatPrint("Votre ticket a été noté " .. rating .. "/5 par " .. ply:Nick() .. ".")

    -- Save rating to data folder
    if not file.Exists("ticket_system_celestia", "DATA") then
        file.CreateDir("ticket_system_celestia")
    end

    if not file.Exists("ticket_system_celestia/rating.txt", "DATA") then
        file.Write("ticket_system_celestia/rating.txt", rating)
    end

    local currentDate = os.date("*t")
    if currentDate.day == 1 then
        file.Delete("ticket_system_celestia/rating.txt")
    end

    local rating_file = file.Read("ticket_system_celestia/rating.txt", "DATA")
    rating_file = util.JSONToTable(rating_file)

    if not rating_file then
        rating_file = {}
    end

    table.insert(rating_file, {
        rating = rating,
        staff = tickets[ticket_id].staff:SteamID(),
        staff_name = tickets[ticket_id].staff:Nick(),
    })

    file.Write("ticket_system_celestia/rating.txt", util.TableToJSON(rating_file))
end)
