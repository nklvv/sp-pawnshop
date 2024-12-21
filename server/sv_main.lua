QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sp-pawnshop:server:sellItem', function(item, price, quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local webhookURL = "YOUR_WEBHOOK_URL" 

    if not Player then return end

    local itemData = nil

    if Config.Inventory == "qb" then
        itemData = Player.Functions.GetItemByName(item)
        
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
    elseif Config.Inventory == "ox" then
        itemData = exports.ox_inventory:Search('count', item)

        if itemData and itemData >= quantity then
            exports.ox_inventory:RemoveItem(item, quantity)
            
            local totalMoney = price * quantity
            
            TriggerEvent("ox:server:addMoney", src, totalMoney)
            
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
    end
end)
