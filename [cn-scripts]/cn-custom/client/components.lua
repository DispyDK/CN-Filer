RegisterNetEvent("loadComp")
AddEventHandler('loadComp', function(weapon,attachment,ped)
  weapon = weapon
  type = type
  ped = GetPlayerPed(-1)
  if attachment == "extended" then
    if weapon == "WEAPON_VINTAGEPISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_VINTAGEPISTOL_CLIP_02"))
    end
    if weapon == "WEAPON_SNSPISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_SNSPISTOL_CLIP_02"))
    end
    if weapon == "WEAPON_PISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_PISTOL_CLIP_02"))
    end
  end
  if attachment == "silencer" then
    if weapon == "WEAPON_VINTAGEPISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_AT_PI_SUPP"))
    end
    if weapon == "WEAPON_PISTOL_MK2" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_AT_PI_SUPP_02"))
    end
    if weapon == "WEAPON_PISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_AT_PI_SUPP_02"))
    end
  end
  if attachment == "skin" then
    if weapon == "WEAPON_PISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"))
    end
    if weapon == "WEAPON_HEAVYPISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"))
    end
    if weapon == "WEAPON_SAWNOFFSHOTGUN" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE"))
    end
    if weapon == "WEAPON_MICROSMG" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"))
    end
    if weapon == "WEAPON_APPISTOL" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))
    end
	if weapon == "WEAPON_ASSAULTRIFLE" then
      GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))
    end	
  end
end)

RegisterNetEvent("savecomponents")
AddEventHandler("savecomponents", function(source)

  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_VINTAGEPISTOL", "COMPONENT_AT_PI_SUPP") then
    TriggerServerEvent('giveback', 'silencer|WEAPON_VINTAGEPISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_VINTAGEPISTOL", "COMPONENT_AT_PI_SUPP")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_VINTAGEPISTOL", "COMPONENT_VINTAGEPISTOL_CLIP_02") then
    TriggerServerEvent('giveback', 'extended|WEAPON_VINTAGEPISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_VINTAGEPISTOL", "COMPONENT_VINTAGEPISTOL_CLIP_02")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_PISTOL_MK2", "COMPONENT_AT_PI_SUPP_02") then
    TriggerServerEvent('giveback', 'silencer|WEAPON_PISTOL_MK2')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL_MK2", "COMPONENT_AT_PI_SUPP_02")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_AT_PI_SUPP_02") then
    TriggerServerEvent('giveback', 'silencer|WEAPON_PISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_AT_PI_SUPP_02")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_PISTOL_CLIP_02") then
    TriggerServerEvent('giveback', 'extended|WEAPON_PISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_PISTOL_CLIP_02")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_SNSPISTOL", "COMPONENT_SNSPISTOL_CLIP_02") then
    TriggerServerEvent('giveback', 'extended|WEAPON_SNSPISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_SNSPISTOL", "COMPONENT_SNSPISTOL_CLIP_02")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_PISTOL_VARMOD_LUXE") then
    TriggerServerEvent('giveback', 'skin|WEAPON_PISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_PISTOL_VARMOD_LUXE")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_SNSPISTOL", "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER") then
    TriggerServerEvent('giveback', 'skin|WEAPON_PISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_HEAVYPISTOL", "COMPONENT_HEAVYPISTOL_VARMOD_LUXE") then
    TriggerServerEvent('giveback', 'skin|WEAPON_HEAVYPISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_HEAVYPISTOL", "COMPONENT_HEAVYPISTOL_VARMOD_LUXE")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_MACHINEPISTOL", "COMPONENT_MG_VARMOD_LOWRIDER") then
    TriggerServerEvent('giveback', 'skin|WEAPON_MACHINEPISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_MACHINEPISTOL", "COMPONENT_MG_VARMOD_LOWRIDER")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_SAWNOFFSHOTGUN", "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE") then
    TriggerServerEvent('giveback', 'skin|WEAPON_SAWNOFFSHOTGUN')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_SAWNOFFSHOTGUN", "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_MICROSMG", "COMPONENT_MICROSMG_VARMOD_LUXE") then
    TriggerServerEvent('giveback', 'skin|WEAPON_MICROSMG')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_MICROSMG", "COMPONENT_MICROSMG_VARMOD_LUXE")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_APPISTOL", "COMPONENT_APPISTOL_VARMOD_LUXE") then
    TriggerServerEvent('giveback', 'skin|WEAPON_APPISTOL')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_APPISTOL", "COMPONENT_APPISTOL_VARMOD_LUXE")
  end
  if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_ASSAULTRIFLE", "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE") then
    TriggerServerEvent('giveback', 'skin|WEAPON_ASSAULTRIFLE')
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_ASSAULTRIFLE", "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE")
  end    

end)
