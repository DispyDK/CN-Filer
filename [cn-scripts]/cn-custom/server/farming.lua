
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_revive")

local items = {
	--Kokain
	{type="process", itemIn="cokepasta_pure", ItemInSec="acetone", itemOut="cut_pasta", unitsIn=30, unitsOut=60},
	{type="process", itemIn="cut_pasta", itemOut="pak_kokain", unitsIn=120, unitsOut=1},

	--Amfetamin
	{type="process", itemIn="amfetamin_pure", ItemInSec="frugt_farve", itemOut="cut_amfetamin", unitsIn=30, unitsOut=240},
	{type="process", itemIn="cut_amfetamin", itemOut="pak_amfetamin", unitsIn=480, unitsOut=1},

	--Heroin
	{type="process", itemIn="heroin_pure", ItemInSec="sukker", itemOut="cut_heroin", unitsIn=30, unitsOut=120},
	{type="process", itemIn="cut_heroin", itemOut="pak_heroin", unitsIn=240, unitsOut=1},

	--Heroin
	{type="process", itemIn="topskud_pure", ItemInSec="klistermaerke", itemOut="cut_topskud", unitsIn=30, unitsOut=150},
	{type="process", itemIn="cut_topskud", itemOut="pak_topskud", unitsIn=300, unitsOut=1},


	--Radio salg
	{type="process", itemIn="radio", itemOut="dirty_money", unitsIn=1, unitsOut=10000},
	
	--Vindrue farm
	{type="farm", itemOut="vindruer", unitsOut=1},

	--Fængsel Planke -Vargas
	{type="farm", itemOut="planke1", unitsOut=1},
	{type="process", itemIn="planke1", itemOut="planke2", unitsIn=1, unitsOut=1},
	{type="process", itemIn="planke2", itemOut="planke3", unitsIn=1, unitsOut=1},	
	{type="process", itemIn="planke3", itemOut="money", unitsIn=1, unitsOut=math.random(125, 150)},

	-- Miner mine
	{type="farm", itemOut="kul", unitsIn=0, unitsOut=1},
	{type="farm", itemOut="steel", unitsIn=0, unitsOut=1},
	{type="farm", itemOut="sulfur", unitsIn=0, unitsOut=1},
	{type="farm", itemOut="aluminium", unitsIn=0, unitsOut=1},
	{type="farm", itemOut="guldmalm", unitsIn=0, unitsOut=1},	
}

RegisterServerEvent("farming:donefarming")
AddEventHandler("farming:donefarming", function(item)
  local user_id = vRP.getUserId({source})
  for k,v in pairs(items) do
    if (item == v.itemOut) then
			local new_weight = vRP.getInventoryWeight({user_id})
			if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
				if (v.type == "process") then
					if (v.ItemInSec) then
						if vRP.hasInventoryItem({user_id,v.itemIn,v.unitsIn,true}) and vRP.hasInventoryItem({user_id,v.ItemInSec,v.unitsIn,true}) then
							if vRP.tryGetInventoryItem({user_id,v.itemIn,v.unitsIn,true}) then
								vRP.tryGetInventoryItem({user_id,v.ItemInSec,v.unitsIn,true})
								vRP.giveInventoryItem({user_id,v.itemOut,v.unitsOut,true})
							end
						else
							--print("Har intet på sig")
						end
						return
					end

					if vRP.tryGetInventoryItem({user_id,v.itemIn,v.unitsIn,true}) then
						vRP.giveInventoryItem({user_id,v.itemOut,v.unitsOut,true})
					end
				else
					vRP.giveInventoryItem({user_id,v.itemOut,v.unitsOut,true})
				end
			end
    end
  end

end)
