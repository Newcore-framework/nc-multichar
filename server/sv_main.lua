lib.callback.register('nc-multichar:GetCharacters', function(src)
    local res = MySQL.query.await('SELECT * FROM characters WHERE id = ?', {
        exports['nc-core']:GetPlayer(src).id
    })
    if res[1] then
        return res
    else
        return nil
    end
end)

lib.callback.register('nc-multichar:GetCharacter', function(src)
    local player = exports['nc-core']:GetPlayer(src)
    local res = MySQL.query.await('SELECT * FROM characters WHERE id = ? AND character_id = ?', {
        player.id, player.chosenCharacter
    })
    return res[1]
end)

lib.callback.register('nc-multichar:setupCharacter', function(src, chosenCharacter)
    local player = exports['nc-core']:GetPlayer(src)
    local res = MySQL.query.await('SELECT * FROM `characters` WHERE `character_id` = ? AND `id` = ?', {
        tonumber(chosenCharacter), tonumber(player.id)
    })

    if res[1] then
        exports['nc-core']:SetChosenCharacter(src, chosenCharacter)
        -- res[1].firstname = json.decode(res[1].firstname)
        -- res[1].lastname = json.decode(res[1].lastname)
        -- res[1].character_id = json.decode(res[1].character_id)
        -- res[1].adminrank = json.decode(res[1].adminrank)
        -- res[1].job = json.decode(res[1].job)
        -- res[1].sex = json.decode(res[1].sex)
        res[1].coords = json.decode(res[1].coords)
        return res[1]
    else
        -- print('Fejl?', chosenCharacter, player.id)
    end
end)

RegisterNetEvent('nc-multichar:CreateCharacter', function(Create)
    local CreatePlayer = MySQL.insert.await(
        'INSERT INTO `characters` (id, firstname, lastname, sex, dob) VALUES (?, ?, ?, ?, ?)', {
            1, Create[1], Create[2], Create[3], Create[4]
        })
    if CreatePlayer then
        print('inserted successfully')
    end
end)


RegisterNetEvent('nc-multichar:deleteChar', function(data,charid)
    MySQL.update.await('DELETE FROM characters WHERE character_id', { data.character_id })
end)