ESX = nil

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('youreyes-medic:cekdokter', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local medicsOnline = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			medicsOnline = medicsOnline + 1
		end
	end

	cb(medicsOnline)
end)

RegisterServerEvent('youreyes-medis:Bayar')
AddEventHandler('youreyes-medis:Bayar', function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeBank(20000)
    TriggerClientEvent('esx:showNotification', src, '~w~You Were Billed For ~r~$50,000~w~.')
end)