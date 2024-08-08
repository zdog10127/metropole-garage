local permissions = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasPermission(user_id,perm)
	local consult = vRP.query("vRP/get_group",{ user_id = user_id, permiss = tostring(perm) })
	if consult[1] then
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.numPermission(perm)
	local users = {}
	for k,v in pairs(permissions) do
		if v == perm then
			table.insert(users,parseInt(k))
		end
	end
	return users
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.insertPermission(source,perm)
	permissions[tostring(source)] = tostring(perm)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removePermission(source,perm)
	if permissions[tostring(source)] then
		permissions[tostring(source)] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if permissions[tostring(source)] then
		permissions[tostring(source)] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
--AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
--	if vRP.hasPermission(user_id,"Police") then
--		permissions[tostring(source)] = "Police"
--		TriggerClientEvent("tencode:StatusService",source,true)
--		TriggerEvent("blipsystem:serviceEnter",source,"Policial",77)
--	elseif vRP.hasPermission(user_id,"Paramedic") then
--		permissions[tostring(source)] = "Paramedic"
--		TriggerEvent("blipsystem:serviceEnter",source,"Paramédico",83)
--	elseif vRP.hasPermission(user_id,"Paramedic") then
--		permissions[tostring(source)] = "Mechanic"
--		TriggerEvent("blipsystem:serviceEnter",source,"Mecânico",51)
--	end
--end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET USER BY PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare('creative/get_id_by_perm', 'SELECT user_id FROM vrp_permissions WHERE permiss=@perm')
function vRP.getUsersByPermission(perm)
    local users = {}
    for _,row in pairs(vRP.query('creative/get_id_by_perm', { perm=perm })) do
        if vRP.getUserSource(row.user_id) then
        table.insert(users, row.user_id)
        end
    end
    return users
end