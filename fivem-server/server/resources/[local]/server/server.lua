print("Iniciando o script server.lua...")

local function spawnVehicle(playerId, vehicleModel)
    print("Tentando spawn do veículo: " .. vehicleModel .. " para o ID do jogador: " .. playerId)
    
    local player = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(player)
    local model = GetHashKey(vehicleModel)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local vehicle = CreateVehicle(model, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(player), true, false)
    TaskWarpPedIntoVehicle(player, vehicle, -1)
    
    print("Veículo spawnado com sucesso: " .. vehicleModel)
end

local function onHttpRequest(data, cb)
    if data.method == 'POST' and data.path == '/spawn-vehicle' then
        local requestBody = json.decode(data.body)
        local playerId = requestBody.playerId
        local vehicleModel = requestBody.vehicleModel

        if playerId and vehicleModel then
            print("Recebido pedido de spawn do veículo: " .. vehicleModel .. " para o ID do jogador: " .. playerId)
            spawnVehicle(playerId, vehicleModel)
            cb({
                status = 200,
                body = json.encode({ message = 'Pedido de spawn do veículo recebido' })
            })
        else
            print("Erro: Corpo da solicitação inválido")
            cb({
                status = 400,
                body = json.encode({ message = 'Requisição Inválida' })
            })
        end
    else
        print("Erro: Rota não encontrada")
        cb({
            status = 404,
            body = json.encode({ message = 'Não Encontrado' })
        })
    end
end

local function startHttpServer()
    print("Tentando iniciar o servidor HTTP...")
    local server = CreateHttpServer()
    server:listen('0.0.0.0', 3001, function(err)
        if err then
            print('Erro ao iniciar o servidor HTTP: ' .. err)
        else
            print('Servidor HTTP iniciado na porta 3001')
        end
    end)

    server:on('request', onHttpRequest)
end

AddEventHandler('onResourceStart', function(resourceName)
    print("Evento onResourceStart acionado")
    if GetCurrentResourceName() == resourceName then
        startHttpServer()
    end
end)
