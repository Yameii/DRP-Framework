local myJob			= nil
local selling 	    = false
local has 			= false

currentped = nil
Citizen.CreateThread(function()
while true do
  Citizen.Wait(0)
    local player = GetPlayerPed(PlayerId())
    local playerloc = GetEntityCoords(player, 0)
    local handle, ped = FindFirstPed()
    repeat
      success, ped = FindNextPed(handle)
      local pos = GetEntityCoords(ped)
      local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
        if IsPedInAnyVehicle(GetPlayerPed(PlayerId())) == false then
            if DoesEntityExist(ped)then
                if IsPedDeadOrDying(ped) == false then
                    if IsPedInAnyVehicle(ped) == false then
                      local pedType = GetPedType(ped)
                        if pedType ~= 28 and IsPedAPlayer(ped) == false then
                          currentped = pos
                            if distance <= 2 and ped  ~= GetPlayerPed(PlayerId()) and ped ~= oldped then
                              TriggerServerEvent('DRP_Drugs:CheckForDrugs') -- Shit way of doing it i know, I will rewrite this!
                                if has then
                                  drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Press ~g~E ~w~to sell drugs", 255, 255, 255, 255)
                                    if IsControlJustPressed(1, 86) then
                                        oldped = ped
                                        SetEntityAsMissionEntity(ped)
                                        TaskStandStill(ped, 10.0)
                                        pos1 = GetEntityCoords(ped)
                                        TriggerServerEvent('DRP_Drugs:SellCoreStart')
                                        Citizen.Wait(2850)
                                        TriggerEvent('DRP_Drugs:AttemptToSell')
                                        SetPedAsNoLongerNeeded(oldped)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    until not success
    EndFindPed(handle)
  end
end)


RegisterNetEvent("DRP_Drugs:HasDrugsOnPerson")
AddEventHandler("DRP_Drugs:HasDrugsOnPerson", function(boolValue)
    has = boolValue
end)

RegisterNetEvent('DRP_Drugs:AttemptToSell')
AddEventHandler('DRP_Drugs:AttemptToSell', function()
    local player = GetPlayerPed(PlayerId())
    local playerloc = GetEntityCoords(player, 0)
    local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

    if distance <= 2 then
    	TriggerServerEvent('DRP_Drugs:Sell')
    elseif distance > 2 then
    	TriggerEvent("DRP_Core:Error", "Drugs", "You moved too far away to do the deal!", 5000, false, "leftCenter")
    end
end)

RegisterNetEvent('animation')
AddEventHandler('animation', function()
  local pid = PlayerPedId()
  RequestAnimDict("amb@prop_human_bum_bin@idle_b")
  while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Citizen.Wait(0) end
    TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    Wait(750)
    StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end