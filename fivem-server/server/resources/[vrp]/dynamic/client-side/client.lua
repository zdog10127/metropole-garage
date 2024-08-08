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
Tunnel.bindInterface("dynamic",cRP)
vSERVER = Tunnel.getInterface("dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false
local policeService = false
local paramedicService = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
local animalHahs = nil
local animalFollow = false
local animalName = ""
local emotePlaying = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:updateService")
AddEventHandler("police:updateService",function(status)
	policeService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:updateService")
AddEventHandler("paramedic:updateService",function(status)
	paramedicService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SetNuiFocus(true,true)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(data,cb)
	if data["server"] == "true" then
		TriggerServerEvent(data["trigger"],data["param"])
	else
		TriggerEvent(data["trigger"],data["param"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	menuOpen = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		menuOpen = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function(source,args)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			menuOpen = true

			exports["dynamic"]:AddButton("Remover","Remover a roupa atual.","player:outfitFunctions","remover","outfit",true)
            exports["dynamic"]:AddButton("Salvar","Salvar a roupa atual.","player:outfitPlayerSave","","outfit",true)
            exports["dynamic"]:AddButton("Aplicar","Aplicar a roupa salva.","player:outfitPlayerApply","","outfit",true)   

			exports["dynamic"]:AddButton("Informações","Todas as informações de sua identidade.","player:identityFunctions","","others",true)
			exports["dynamic"]:AddButton("Desmanche","Listagem dos veículos.","dismantle:invokeDismantle","","others",true)
			exports["dynamic"]:AddButton("Comercialização","Iniciar/Finalizar venda de drogas.","drugs:toggleService","","others",false)

			if not IsPedInAnyVehicle(ped) then
				exports["dynamic"]:AddButton("Rebocar","Colocar veículo na prancha do reboque.","towdriver:invokeTow","","others",false)

				exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","dynamic:EnterTrunk","","otherPlayers",true)
				exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","emergency:rv","rv","otherPlayers",true)
				exports["dynamic"]:AddButton("Checar Porta-Malas","Vericar pessoa dentro do mesmo.","player:CheckTrunk","","otherPlayers",true)

				exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","otherPlayers")
			else
				exports["dynamic"]:AddButton("Banco Dianteiro Esquerdo","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
				exports["dynamic"]:AddButton("Banco Dianteiro Direito","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
				exports["dynamic"]:AddButton("Banco Traseiro Esquerdo","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
				exports["dynamic"]:AddButton("Banco Traseiro Direito","Sentar no banco do passageiro.","player:seatPlayer","3","vehicle",false)
				exports["dynamic"]:AddButton("Levantar Vidros","Levantar todos os vidros.","player:winsFunctions","1","vehicle",true)
				exports["dynamic"]:AddButton("Abaixar Vidros","Abaixar todos os vidros.","player:winsFunctions","0","vehicle",true)

				exports["dynamic"]:SubMenu("Veículo","Funções do veículo.","vehicle")
			end

			exports["dynamic"]:AddButton("Propriedades","Ativa/Desativa as propriedades no mapa.","homes:togglePropertys","","propertys",false)

			exports["dynamic"]:SubMenu("Roupas","Mudança de roupas rápidas.","outfit")
			
			exports["dynamic"]:SubMenu("Propriedades","Todas as funções das propriedades.","propertys")

			exports["dynamic"]:SubMenu("Outros","Todas as funções do personagem.","others")

				if animalHahs ~= nil then
					exports["dynamic"]:SubMenu("Domésticos","Todas as funções dos animais domésticos.","animal")
				end
				if animalHahs ~= nil then
					exports["dynamic"]:SubMenu("Animações do Animal","Todas as animações dos animais.","animations")
				end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function(source,args)
	if policeService or paramedicService then
		if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then

			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 then
				menuOpen = true

				exports["dynamic"]:AddButton("Serviço","Verificar companheiros em serviço.","emergency:servicoFunctions","","utilitys",true)

				if not IsPedInAnyVehicle(ped) then
					exports["dynamic"]:AddButton("Carregar pelos Braços","Carregar a pessoa mais próxima.","emergency:carryb","","player",true)
					exports["dynamic"]:AddButton("Carregar nos Ombros","Carregar a pessoa mais próxima.","emergency:carrya","","player",true)
					exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","emergency:cv","4","player",true)
					exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","emergency:rv","","player",true)

					exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","player")
				end

				if policeService then
					exports["dynamic"]:AddButton("Computador","Abrir o dispositivo móvel.","police:openSystem","","utilitys",false)
					exports["dynamic"]:AddButton("Barreira","Colocar barreira na frente.","police:insertBarrier","","utilitys",false)
					exports["dynamic"]:AddButton("Invadir","Invadir a residência.","homes:invadeSystem","","utilitys",true)

					exports["dynamic"]:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","emergency:removeHat","","player",true)
					exports["dynamic"]:AddButton("Remover Máscara","Remover da pessoa mais próxima.","emergency:removeMask","","player",true)
					exports["dynamic"]:AddButton("Defusar","Desativar bomba do veículo.","races:defuseBomb","","player",true)

					exports["dynamic"]:AddButton("Sheriff","Fardamento de oficial.","emergency:presetFunctions","1","prePolice",true)
					exports["dynamic"]:AddButton("State Police","Fardamento de oficial.","emergency:presetFunctions","2","prePolice",true)
					exports["dynamic"]:AddButton("State Park","Fardamento de oficial.","emergency:presetFunctions","3","prePolice",true)
					exports["dynamic"]:AddButton("Los Santos Police","Fardamento de oficial.","emergency:presetFunctions","4","prePolice",true)
					exports["dynamic"]:AddButton("Los Santos Police","Fardamento de oficial.","emergency:presetFunctions","5","prePolice",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
					exports["dynamic"]:SubMenu("Utilidades","Todas as funções dos policiais.","utilitys")
				elseif paramedicService then
					exports["dynamic"]:AddButton("Medical Center","Fardamento de doutor.","emergency:presetFunctions","6","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de paramédico.","emergency:presetFunctions","7","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de paramédico interno.","emergency:presetFunctions","8","preMedic",true)
					exports["dynamic"]:AddButton("Fire Departament","Fardamento de atendimentos.","emergency:presetFunctions","9","preMedic",true)
					exports["dynamic"]:AddButton("Fire Departament","Fardamento de mergulhador.","emergency:presetFunctions","10","preMedic",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos médicos.","preMedic")
					exports["dynamic"]:SubMenu("Utilidades","Todas as funções dos paramédicos.","utilitys")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","f1")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emergência.","keyboard","f10")