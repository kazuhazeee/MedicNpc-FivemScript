ESX = nil
PlayerData = {}
anjay = true
local cd = false

local Cooldown = 3600 -- Add COOLDOWN HERE(MS)

ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esxplayerLoaded', function(xPlayer)
	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStart', function(resource)
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setjob')
AddEventHandler('esx:setjob', function(xPlayer)
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand("medisnpc", function(source, args, raw)
	local nama = GetPlayerName(PlayerId())

	if not cd then
		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
			if isDead and anjay then
				ESX.TriggerServerCallback('youreyes-medic:cekdokter', function(medicsOnline)
					if medicsOnline < 1 then
						TriggerEvent("youreyes-medic:npc")
						anjay = false
						cd = true
						Citizen.Wait(Cooldown) -- ISI COOLDOWN DISINI (MS)
						cd = false
					else
						exports['mythic_notify']:DoHudText('error', 'EMS Sudah Tersedia, Silahkan Hubungi EMS.')
					end
				end)
			else
				exports['mythic_notify']:DoHudText('error', 'Gunakan Jika Pingsan.')
			end
		end)
	else
		exports['mythic_notify']:DoHudText('error', 'Medical Sedang Sibuk (Cooldown).')
	end
end)

AddEventHandler("youreyes-medic:npc", function()
    player = GetPlayerPed(-1)
    playerPos = GetEntityCoords(player)

    local doktorkod = GetHashKey("s_m_m_doctor_01")
    RequestModel(doktorkod)

    while not HasModelLoaded(doktorkod) and RequestModel(doktorkod) do
        RequestModel(doktorkod)
        Citizen.Wait(0)
    end

	DoktorNPC(playerPos.x, playerPos.y, playerPos.x, doktorkod)
	ClearPedTasksImmediately(player)
end)

function DoktorNPC(x, y, z, doktorkod)
	
	TriggerEvent("mythic_progbar:client:progress", {
		name = "Obatyoureyes",
		duration = 2000,
		label = 'Sedang di Obati',
		useWhileDead = true,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	})
	
	Citizen.Wait(9000)
	ClearPedTasks(DokterCreate)
	
	Citizen.Wait(500)
	TriggerEvent('esx_ambulancejob:revive')
	TriggerServerEvent('youreyes-medis:Bayar')
	
	Citizen.Wait(1000)
	DeletePed(DokterCreate)
	anjay = true
	exports['mythic_notify']:DoHudText('error', 'Kamu Sudah Mendapatkan Perawatan.')
	
	Citizen.Wait(100)
	ClearPedTasks(DokterCreate)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

