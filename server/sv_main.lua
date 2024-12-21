QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sp-pawnshop:server:sellItem', function(item, price, quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local itemData = Player.Functions.GetItemByName(item)
    local webhookURL = "YOUR_WEBHOOK_URL" 

    if itemData and itemData.amount >= quantity then
        Player.Functions.RemoveItem(item, quantity)
        local totalMoney = price * quantity
        Player.Functions.AddMoney('cash', totalMoney)

        TriggerClientEvent('QBCore:Notify', src, 'You sold ' .. quantity .. 'x ' .. item .. ' for $' .. totalMoney, 'success')

        local discordMessage = {
            {
                ["color"] = tonumber("0x2b2d31"),
                ["title"] = "Pawnshop Sale",
                ["description"] = "**Player:** " .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname ..
                                  "\n**Item Sold:** " .. quantity .. "x " .. item ..
                                  "\n**Total Received:** $" .. totalMoney,
                ["footer"] = {
                    ["text"] = os.date('%Y-%m-%d %H:%M:%S'),
                }
            }
        }

        PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Pawnshop Logs", embeds = discordMessage}), {['Content-Type'] = 'application/json'})
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough items', 'error')
    end
end)