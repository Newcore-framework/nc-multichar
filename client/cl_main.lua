---@diagnostic disable: undefined-global
local character = exports['nc-core']:GetCharacterData()

RegisterNetEvent('playerSpawned', function()
    if not character then
        CreateCharacter()
    elseif character then
        exports['nc-multichar']:OpenMulticharacter(true)
    else
        print('player not defined')
    end
end)

CreateThread(function() -- CLOSES THE MULTICHARACTER AUTOMATICLY WHEN RESTARTED
    SendNUIMessage({
        action = 'close',
    })
    SetNuiFocus(false, false)
end)

exports('GetCharacters', function()
    local data = lib.callback.await('nc-multichar:GetCharacters')
    if data then
        return data
    else
        return nil
    end
end)

exports('GetChosenCharacter', function()
    local data = lib.callback.await('nc-multichar:GetCharacter')
    if data then
        return data
    else
        return nil
    end
end)

exports('OpenMulticharacter', function(boolean)
    if boolean then
        return OpenMultichar()
    elseif not boolean then
        return CloseMultichar()
    end
end)

function CloseMultichar()
    SendNUIMessage({
        action = 'close',
    })
    SetNuiFocus(false, false)
end

function OpenMultichar()
    local data = lib.callback.await('nc-multichar:GetCharacters', false)

    for i = 1, #data do
        data[i].coords = json.decode(data[i].coords)
    end

    if not data then
        CreateCharacter()
    else
        SendNUIMessage({
            action = 'open',
            data = data
        })

        SetNuiFocus(true, true)
    end
end

RegisterNUICallback('selectCharacter', function(data)
    local characterData = lib.callback.await('nc-multichar:setupCharacter', false, data.characterId)
    SendNUIMessage({ action = 'close' })
    SetNuiFocus(false, false)
    SpawnCharacter(characterData)
    -- print(json.encode(characterData))
end)

RegisterNUICallback('deleteCharacter', function(data)
    SendNUIMessage({ action = 'close' })
    SetNuiFocus(false, false)
    local charid = exports['nc-core']:GetCharacterData().character_id
    TriggerServerEvent('nc-multichar:deleteChar', data, charid)
    CreateCharacter()
    -- print('char deleted')
end)

function CreateCharacter()
    local Create = lib.inputDialog('Create Character', {
        {
            type = 'input',
            label = 'Firstname',
            required = true,
            min = 3
        },
        {
            type = 'input',
            label = 'Lastname',
            required = true,
            min = 3
        },
        {
            type = 'select',
            label = 'Sex',
            required = true,
            options = {
                {
                    label = 'Male',
                    value = 'male',
                },
                {
                    label = 'Female',
                    value = 'female',
                },
            }
        },
        {
            type = 'date',
            label = 'Date of birth',
            icon = { 'far', 'calendar' },
            default = true,
            format = "YYYY/MM/DD",
            required = true
        },
    })

    if Create then
        print(json.encode(Create))
        TriggerServerEvent('nc-multichar:CreateCharacter', Create)
    else
        CreateCharacter()
    end
end

function SpawnCharacter(character)
    DoScreenFadeOut(1000)
    Wait(1000)
    if character.sex == 'male' then
        lib.RequestModel('mp_m_freemode_01')
        SetPlayerModel(PlayerId(), 'mp_m_freemode_01')
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
    elseif character.sex == 'female' then
        lib.RequestModel('mp_f_freemode_01')
        SetPlayerModel(PlayerId(), 'mp_f_freemode_01')
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
    end
    --MAKE CHARACTER GET CLOTHING FROM DATABASE
    if character.coords.x == nil then
        SetEntityCoords(PlayerPedId(), Shared.Startlocation)
    else
        SetEntityCoords(PlayerPedId(), character.coords.x, character.coords.y, character.coords.z-1)
    end
    DoScreenFadeIn(1000)
end

RegisterCommand('multi', function()
    local data = exports['nc-multichar']:GetCharacters()
    if data then
        OpenMultichar()
    elseif not data then
        CreateCharacter()
    end
end, false)

RegisterCommand('unmulti', function()
    SendNUIMessage({
        action = 'close',
    })
    SetNuiFocus(false, false)
end, false)
