local hovering = false

RegisterCommand("helihover", function()
    ToggleHelicopterHovering()
end, false)

RegisterKeyMapping('helicopterHoverToggle', 'Toggle Helicopter Hovering', 'keyboard', Config.HoverKeyBind)

RegisterCommand("helicopterHoverToggle", function()
    ToggleHelicopterHovering()
end, false)

function ToggleHelicopterHovering()
    local player = PlayerId()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    if DoesEntityExist(vehicle) then
        local modelName = GetEntityModel(vehicle)
        
        if IsModelInTable(modelName, Config.Helicopters) then
            if not hovering then
                TriggerEvent("chatMessage", "SYSTEM", {0, 255, 0}, Config.HoverChatMessage)
                hovering = true

                Citizen.CreateThread(function()
                    while hovering and DoesEntityExist(vehicle) do
                        local currentVelocity = GetEntityVelocity(vehicle)
                        SetEntityVelocity(vehicle, currentVelocity.x, currentVelocity.y, 0.0)
                        Citizen.Wait(0)
                    end
                end)
            else
                TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, Config.UnHoverChatMessage)
                hovering = false
            end
        else
            TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, Config.HelicopterCantHoverMsg)
        end
    else
        TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, Config.NoHelicopterMessage )
    end
end

function IsModelInTable(model, modelTable)
    for _, value in pairs(modelTable) do
        if GetHashKey(value) == model then
            return true
        end
    end
    return false
end
