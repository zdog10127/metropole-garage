-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("cashmachine",cRP)
vSERVER = Tunnel.getInterface("cashmachine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local machineStart = false
local machineTimer = 0
local machinePosX = 0.0
local machinePosY = 0.0
local machinePosZ = 0.0
local objectBomb = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- MACHINES
-----------------------------------------------------------------------------------------------------------------------------------------
local machines = {
	{ 147.59,-1035.76,29.35,158.22 },
	{ 145.95,-1035.18,29.35,159.58 },
	{ 289.11,-1256.84,29.45,272.09 },
	{ 288.85,-1282.36,29.64,268.68 },
	{ -56.95,-1752.06,29.43,46.38 },
	{ -203.75,-861.35,30.27,25.8 },
	{ -254.43,-692.46,33.61,158.32 },
	{ -256.22,-716.01,33.53,67.9 },
	{ -721.08,-415.53,34.99,265.41 },
	{ -846.3,-341.27,38.69,115.1 },
	{ -846.84,-340.21,38.69,115.17 },
	{ -2072.35,-317.25,13.32,262.88 },
	{ 228.18,338.4,105.57,158.25 },
	{ 380.78,323.41,103.57,161.78 },
	{ -30.19,-723.7,44.23,339.56 },
	{ 5.27,-919.86,29.56,249.37 },
	{ 24.51,-945.96,29.36,338.97 },
	{ 33.19,-1348.25,29.5,177.59 },
	{ 295.76,-896.13,29.22,251.01 },
	{ 296.47,-894.21,29.24,252.01 },
	{ 356.96,173.57,103.07,341.32 },
	{ 285.48,143.38,104.18,160.1 },
	{ 158.65,234.21,106.63,338.35 },
	{ -165.16,234.78,94.93,90.0 },
	{ -165.16,232.76,94.93,90.11 },
	{ -258.82,-723.35,33.48,71.14 },
	{ -301.69,-830.01,32.42,350.36 },
	{ -303.25,-829.73,32.42,354.01 },
	{ 129.2,-1291.15,29.27,297.55 },
	{ -717.69,-915.66,19.22,87.44 },
	{ -660.73,-854.06,24.49,179.16 },
	{ 1153.69,-326.77,69.21,98.26 },
	{ -1109.8,-1690.81,4.38,125.01 },
	{ -1315.8,-834.76,16.97,307.4 },
	{ -1314.77,-835.98,16.97,305.52 },
	{ 527.35,-160.71,57.1,268.13 },
	{ -1430.16,-211.08,46.51,112.53 },
	{ -1415.95,-212.01,46.51,227.98 },
	{ -1286.26,-213.42,42.45,122.23 },
	{ -1289.29,-226.83,42.45,120.79 },
	{ -1285.61,-224.29,42.45,301.24 },
	{ -1205.03,-326.26,37.84,115.33 },
	{ -1205.72,-324.77,37.86,113.88 },
	{ -1282.54,-210.92,42.45,301.87 },
	{ 89.73,2.47,68.31,337.43 },
	{ 1077.73,-776.52,58.25,180.02 },
	{ -1305.41,-706.37,25.33,127.89 },
	{ -27.98,-724.52,44.23,338.4 },
	{ -57.68,-92.66,57.78,291.21 },
	{ -866.64,-187.78,37.85,120.99 },
	{ -867.6,-186.1,37.85,117.72 },
	{ 112.55,-819.38,31.34,159.55 },
	{ -596.07,-1161.29,22.33,0.51 },
	{ -594.53,-1161.27,22.33,358.18 },
	{ 1138.26,-468.94,66.74,72.73 },
	{ 1167.0,-456.08,66.8,341.24 },
	{ 236.6,219.66,106.29,289.38 },
	{ 236.95,218.7,106.29,290.55 },
	{ 237.48,217.82,106.29,292.16 },
	{ 237.89,216.91,106.29,291.38 },
	{ 238.32,215.98,106.29,289.65 },
	{ 129.68,-1291.94,29.27,297.52 },
	{ 130.11,-1292.67,29.27,295.5 },
	{ 119.07,-883.66,31.13,69.71 },
	{ -1410.34,-98.76,52.43,106.76 },
	{ -1409.76,-100.52,52.39,105.93 },
	{ -1570.11,-546.69,34.96,215.83 },
	{ -1571.04,-547.38,34.96,215.83 },
	{ -821.63,-1081.9,11.14,31.81 },
	{ -537.83,-854.49,29.3,179.26 },
	{ 111.31,-775.26,31.44,341.09 },
	{ 114.45,-776.39,31.42,340.98 },
	{ 315.1,-593.67,43.29,68.07 },
	{ -712.85,-818.9,23.73,0.02 },
	{ -710.01,-818.99,23.73,0.56 },
	{ -1316.07,-834.64,16.97,307.5 },
	{ -1314.78,-836.36,16.96,305.88 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMACHINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cashmachine:machineRobbery")
AddEventHandler("cashmachine:machineRobbery",function()
	local ped = PlayerPedId()
	if not machineStart then
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(machines) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 0.6 then
					if vSERVER.startMachine() then
						machinePosX = v[1]
						machinePosY = v[2]
						machinePosZ = v[3]
						SetEntityHeading(ped,v[4])
						TriggerEvent("cancelando",true)
						SetEntityCoords(ped,v[1],v[2],v[3]-1)
						vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

						Citizen.Wait(10000)
						startthreadmachinestart()
						machineStart = true
						vRP.removeObjects()
						TriggerEvent("cancelando",false)
						machineTimer = math.random(30,40)
						vSERVER.callPolice(machinePosX,machinePosY,machinePosZ)

						local mHash = GetHashKey("prop_c4_final_green")

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							RequestModel(mHash)
							Citizen.Wait(10)
						end

						local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.23,0.0)
						objectBomb = CreateObjectNoOffset(mHash,coords.x,coords.y,coords.z-0.23,true,false,false)
						SetEntityAsMissionEntity(objectBomb,true,true)
						FreezeEntityPosition(objectBomb,true)
						SetEntityHeading(objectBomb,v[4])
						SetModelAsNoLongerNeeded(mHash)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MACHINETIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function startthreadmachinestart()
	Citizen.CreateThread(function()
		while true do
			if machineStart and machineTimer > 0 then
				machineTimer = machineTimer - 1
				if machineTimer <= 0 then
					machineStart = false
					TriggerServerEvent("tryDeleteEntity",ObjToNet(objectBomb))
					vSERVER.stopMachine(machinePosX,machinePosY,machinePosZ)
					AddExplosion(machinePosX,machinePosY,machinePosZ,2,100.0,true,false,true)
				end
			end
			Citizen.Wait(1000)
		end
	end)
end