ServerCFG = {}



ServerCFG.Worlds = {}



ServerCFG.Discord_Webhooks = {
    ['user_left'] = 'webhookhere',
    ['dev_logs'] = 'webhookhere',
}




ServerCFG.Commands = {
    
    ['test_command'] = {permission = true,function(source, args_table)
        print('Source is: ' .. source)
        print('Args table is: ' .. args_table)
    end},

    ['playertable'] = {permission = false,function(source, args_table)
        TriggerClientEvent('table', source, _G.online_players)
    end},

    ['player_coords'] = {permission = false,function(source, args_table)
        simple_base.send_discord_log('dev_logs', 16007897, '**Dev coords**', '**Requested by: **' .. GetPlayerName(source) .. '\n **Coords: **' .. tostring(GetEntityCoords(GetPlayerPed(source))))
    end},

    ['ban'] = {permission = true,function(source, args_table)
        print('args table 1' .. args_table[1])
        if args_table[1] then
            simple_base.ban_player(args_table[1])
        end
    end},
}



for i, v in pairs(ServerCFG.Commands) do
    RegisterCommand(i, function (source, args, rawCommand)
        if ServerCFG.Commands[i].permission == true then
            if simple_base.get_object_from_user_table(source, 'user_admin') == true then
                ServerCFG.Commands[i][1](source, args)
            end
        else
            ServerCFG.Commands[i][1](source, args)
        end
    end)
end