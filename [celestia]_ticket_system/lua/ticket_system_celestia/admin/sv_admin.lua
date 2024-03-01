if CLIENT then return end

util.AddNetworkString("celestia_ticket_open_panel")

net.Receive("celestia_ticket_open_panel", function(len, ply)
    if not TicketSystemCelestia.Config.Staff[CelestiaLib.Utils.GetRank(ply)] then return end

    if not CelestiaLib.Net.Limiter("celestia_ticket_open_panel", ply) then return end
    CelestiaLib.Net.Debug("celestia_ticket_open_panel", len, ply)

    if not file.Exists("ticket_system_celestia", "DATA") then
        file.CreateDir("ticket_system_celestia")
    end

    if not file.Exists("ticket_system_celestia/rating.txt", "DATA") then
        file.Write("ticket_system_celestia/rating.txt", rating)
    end

    local rating_file = file.Read("ticket_system_celestia/rating.txt", "DATA")
    rating_file = util.JSONToTable(rating_file)

    if not rating_file then
        rating_file = {}
    end

    local compressed = util.Compress(util.TableToJSON(rating_file))
    local bytes_amount = #compressed
    
    net.Start("celestia_ticket_open_panel")
        net.WriteUInt(bytes_amount, 16)
        net.WriteData(compressed, bytes_amount)
    net.Send(ply)
end)
