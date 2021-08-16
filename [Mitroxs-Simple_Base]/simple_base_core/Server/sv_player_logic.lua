
AddEventHandler("playerConnecting", function (name, setKickReason, deferrals)
    local player = source
    deferrals.defer()
    -- mandatory wait!
    Wait(0)
    deferrals.update("Checking if user exist")
    -- mandatory wait!
    Wait(0)

    if not simple_base.does_user_exist(player) then
        deferrals.update("Creating user")
        simple_base.create_user(player)
        deferrals.done()
       simple_base.put_user_info_in_global_table(player)
    else
        if not simple_base.is_user_banned(player) then
            simple_base.put_user_info_in_global_table(player)
            deferrals.done()
        else
            deferrals.done("You are currently not allowed to play!")
        end
    end
end)


AddEventHandler('playerDropped', function(reason)
    local player = source
    local player_license = simple_base.get_player_license(player)
    if not _G.online_players[player_license] == nil then
        simple_base.send_discord_log('user_left', 16007897, '**User left**', '**Name: **' .. _G.online_players[player_license].player_name .. '\n **User-ID: **' .. _G.online_players[player_license].player_id .. '\n **Reason: **' .. reason) 
        _G.online_players[player_license] = nil
    end
    _G.online_players[player_license] = nil
end)
