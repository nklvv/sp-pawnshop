QBCore = exports['qb-core']:GetCoreObject()
local pawnshopTarget = nil

CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.PawnshopLocation,
        size = vec3(2, 2, 2),
        rotation = 0,
        options = {
            {
                name = "pawnshop",
                event = "sp-pawnshop:client:openMenu",
                icon = "fas fa-dollar-sign",
                label = "Sell Items",
            }
        }
    })
end)

RegisterNetEvent('sp-pawnshop:client:openMenu', function()
    local menuItems = {}

    for item, data in pairs(Config.Items) do
        local iconPath = ""

        if Config.Inventory == "ox" then
            iconPath = "nui://ox_inventory/web/images/" .. item .. ".png"
        elseif Config.Inventory == "qb" then
            iconPath = "nui://qb-inventory/html/images/" .. item .. ".png"
        end

        menuItems[#menuItems + 1] = {
            title = data.label,
            description = "Sell for $" .. data.price .. " each",
            icon = iconPath,
            event = "sp-pawnshop:client:sellItem",
            args = { item = item, price = data.price }
        }
    end

    lib.registerContext({
        id = 'pawnshop_menu',
        title = 'Pawnshop',
        options = menuItems
    })

    lib.showContext('pawnshop_menu')
end)

RegisterNetEvent('sp-pawnshop:client:sellItem', function(data)
    local input = lib.inputDialog('Sell Items', {
        { type = "number", label = "Enter Quantity", placeholder = "1" }
    })

    if input and tonumber(input[1]) > 0 then
        local quantity = tonumber(input[1])
        TriggerServerEvent('sp-pawnshop:server:sellItem', data.item, data.price, quantity)
    else
        QBCore.Functions.Notify('Invalid quantity', 'error')
    end
end)
