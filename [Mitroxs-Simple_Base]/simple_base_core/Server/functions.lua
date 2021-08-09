simple_base = {}

_G.online_players = {}


--- If u want to get player_source from the online_players table , use the is_player_online function second value returned is the player source, and first one is a bool.


function simple_base.get_all_user_info(player)
    local license = simple_base.get_player_license(player)
    local all_info = exports['ghmattimysql']:executeSync('SELECT * FROM users WHERE license = @license',{['@license'] = license})
    return all_info
end


function simple_base.put_user_info_in_global_table(player)
    local player = player
    local user_info = simple_base.get_all_user_info(player)
    local user_id = user_info[1].id
    local user_admin = user_info[1].admin
    local user_name = GetPlayerName(player)
    local user_license = simple_base.get_player_license(player)
    if user_admin == 1 then
        _G.online_players[user_license] = {player_name = user_name, player_id = user_id, user_admin = true, player_source = player}
    else
        _G.online_players[user_license] = {player_name = user_name, player_id = user_id, user_admin = false, player_source = player}
    end
end




function simple_base.get_object_from_user_table(player, object)
    local license = simple_base.get_player_license(player)
    for _, v in pairs(_G.online_players) do
        if _ == license then
            return v[object]
        end
    end
end


function simple_base.remove_user_admin(player)
    local license = simple_base.get_player_license(player)
    exports['ghmattimysql']:executeSync('UPDATE users SET admin = 0 WHERE license = @license',{['@license'] = license})
    _G.online_players[license].user_admin = false
end

function simple_base.give_user_admin(player)
    local license = simple_base.get_player_license(player)
    exports['ghmattimysql']:executeSync('UPDATE users SET admin = 1 WHERE license = @license',{['@license'] = license})
    _G.online_players[license].user_admin = true
end


function simple_base.is_user_admin(player)
    local license = simple_base.get_player_license(player)
    local is_admin = exports['ghmattimysql']:executeSync('SELECT admin FROM users WHERE license = @license',{['@license'] = license})
    if is_admin[1].admin == 1 then
        return true
    else
        return false
    end
end






function simple_base.get_player_license(player)
    for k,v in pairs(GetPlayerIdentifiers(player))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
          return v
        end
    end
end

function simple_base.does_user_exist(player)
    local license = simple_base.get_player_license(player)
    local user = exports['ghmattimysql']:executeSync('SELECT id FROM users WHERE license = @license',{['@license'] = license})
    if user[1] ~= nil then
        return true
    else
        return false
    end
end


function simple_base.send_discord_log(log_type, color, title, contents)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. title .."**",
            ["description"] = contents,
            ["footer"] = {
                ["text"] = 'Enjoy',
            },
        }
    }
    PerformHttpRequest(ServerCFG.Discord_Webhooks[log_type], function(err, text, headers) end, 'POST', json.encode({username = ServerCFG.Discord_Webhooks['user_name'], embeds = connect, avatar_url = ServerCFG.Discord_Webhooks['image_url']}), { ['Content-Type'] = 'application/json' })
end

function simple_base.create_user(player)
    local license = simple_base.get_player_license(player)
    local player_name = GetPlayerName(player)
    exports['ghmattimysql']:execute("INSERT INTO users (`license`, `name`) VALUES (@license, @name);", {['@license'] = license, ['@name'] = player_name}, function() end)
end


function simple_base.ban_player(user_id)
    exports['ghmattimysql']:executeSync('UPDATE users SET banned = 1 WHERE id = @id',{['@id'] = user_id})
    local user_online, player_source = simple_base.is_user_online(user_id)
    if user_online == true then
        DropPlayer(player_source, 'Banned')
    end
end

function simple_base.is_user_banned(player)
    local license = simple_base.get_player_license(player)
    local banned = exports['ghmattimysql']:executeSync('SELECT banned FROM users WHERE license = @license',{['@license'] = license})
    if banned[1].banned == 1 then
        return true
    else
        return false
    end
end


function simple_base.is_user_online(user_id)
    for _, v in pairs(_G.online_players) do
        if v['player_id'] == tonumber(user_id) then
            return true, v['player_source']
        end
    end
    return false
end






