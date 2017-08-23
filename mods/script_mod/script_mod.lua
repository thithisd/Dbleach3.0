function cancelAll()
cancelVitaBuff()
cancelAntiPush()
cancelAutoSoft()
cancelMoneyRune()
cancelMining()
cancelUtevoSio()
cancelRecconect()
cancelAutoMount()
cancelAutoSay()
cancelAutoSay2()
cancelAutoSay3()
--cancelExani()
end

function invisivel()
push:setVisible(false)
mining:setVisible(false)
gransio:setVisible(false)
utevogran:setVisible(false)
runeflask:setVisible(false)
softboots:setVisible(false)
reconect:setVisible(false)
mount:setVisible(false)
autosay:setVisible(false)
autosay2:setVisible(false)
autosay3:setVisible(false)
--exanihur:setVisible(false)
end

local scriptButton
function init()

  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })
	scriptButton = modules.client_topmenu.addLeftButton('scriptButton', tr('scripts'), 'img/icone', toggle, true) -- Botão 
	
	if not g_game.isOnline() then
		scriptButton:enable()
	end
	
	
-- Chamando interface grafica( arquivos OTUI)	
	push = g_ui.displayUI('push')
	mining = g_ui.displayUI('mining')
	gransio = g_ui.displayUI('gransio')
	utevogran = g_ui.displayUI('utevogran')
	reconect =  g_ui.displayUI('reconect')
	runeflask = g_ui.displayUI('runeflask')
	softboots = g_ui.displayUI('softboots')
	mount = g_ui.displayUI('mount')
	autosay = g_ui.displayUI('autosay')
	autosay2 = g_ui.displayUI('autosay2')
	autosay3 = g_ui.displayUI('autosay3')
--	exanihur = g_ui.displayUI('exanihur') -- ainda não está pronto. Faz o char deslogar

  -- g_keyboard.bindKeyDown('Esc', scriptCancel)
  
	g_keyboard.bindKeyPress('Escape', function()
		invisivel()
	end)
	
end
-- Menus popup * Ao clicar em uma opiçã o OTUI fica visivel
function toggle()
  local menu = g_ui.createWidget('PopupMenu')
--  menu:addOption("Auto Exani Hur", function() exanihur:setVisible(true) end) faz o char deslogar
  menu:addOption("Auto Say", function() autosay:setVisible(true) end) -- Feito e funcionando
  menu:addSeparator()
  menu:addOption("Auto Say2", function() autosay2:setVisible(true) end) -- Feito e funcionando
  menu:addSeparator()
  menu:addOption("Auto Say3", function() autosay3:setVisible(true) end) -- Feito e funcionando
  menu:addSeparator()
  menu:addOption("Anti Push", function() push:setVisible(true) end) -- Feito e funcionando
  menu:addSeparator()
  menu:addOption("Recconect", function() reconect:setVisible(true) end) -- Fazendo
  menu:addSeparator()
  menu:addOption("Cancel All", function() cancelAll() end) -- feito
  menu:addSeparator()
 
--  menu:addOption("Stop Smart Pathing when..",) -- Em Construção
--  menu:addOption("Main Backpack", function() autobp:setVisible(true) end) || retirado
--  menu:addOption("exani hur/down", function() exanihur:setVisible(true) end) || ainda não achei comandos pra fazer esse script
  menu:display()
end

function vitaBuff()
-- Script de vita gran sio
if vitagransio == nil then
vitagransio = cycleEvent( function ()
			 if g_game.isOnline() then
								local Level = g_game.getLocalPlayer():getLevel()
								local LifePercent = (((Level*5)+145)*40) /100
								local Name = g_game.getLocalPlayer():getName()
								local Life = ((Level*5)+145)
								local LifeBuffado = ((Level*5)+145)+((((Level*5)+145)*40) /100)
								local MaxHealth = g_game.getLocalPlayer():getMaxHealth()
								local itemLife = MaxHealth - ((Level*5)+145)

								if MaxHealth < ((Level*5)+145)+((((Level*5)+145)*40) /100) or MaxHealth < (((Level*5)+145)+((((Level*5)+145)*40) /100)+itemLife)  then
									g_game.talk('Vita Gran Sio "'..Name)
								end
							end
						end, 30000)
end
	gransio:setVisible(false)
 modules.game_textmessage.displayGameMessage(tr('Voce ativou Vita Gran Sio!'))
end

function cancelVitaBuff()
-- Cancelando o evento de vita gran sio
	removeEvent(vitagransio)
	vitagransio = nil
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Vita Gran Sio!'))
	gransio:setVisible(false)
end

function antiPush()
	-- Script de Anti Push
		if g_game.isOnline() then
			if antipush == nil then
			antipush = cycleEvent( function()
			
				local player = g_game.getLocalPlayer()
				local mypos = player:getPosition()
				local tile = g_map.getTile(mypos)
				local bp = player:getInventoryItem(InventorySlotBack)
				local GP = 3031
				local Plat = 3035
				local Worm = 3492
				local GPNABP = player:getItem(GP)
				local PlatNaBP = player:getItem(Plat)
				local WormNaBP = player:getItem(Worm)
				local verificaSQM = tile:getTopMoveThing():getId()
					
					if verificaSQM ~= GP and verificaSQM ~= Worm and GPNABP == nil and WormNaBP ~= nil then
						g_game.move(WormNaBP, mypos,1)
					end
					if verificaSQM ~= GP then
						g_game.move(GPNABP, mypos, 1)
					end
				end, 70)
			end
			
			if trocaGold == nil then
			
				trocaGold = cycleEvent( function()
					local player = g_game.getLocalPlayer()
					local GP = 3031
					local Plat = 3035
					local GPNABP = player:getItem(GP)
					local PlatNaBP = player:getItem(Plat)
					
						if GPNABP == nil then
							g_game.use(PlatNaBP)
						end
					end, 200)
			end
		end
	push:setVisible(false)
modules.game_textmessage.displayGameMessage(tr('Voce ativou Anti Push!'))
end

function cancelAntiPush()
    modules.game_textmessage.displayGameMessage(tr('Voce desativou Anti Push!'))
	removeEvent(antipush)
	antipush = nil
	removeEvent(trocaGold)
	trocaGold = nil
	push:setVisible(false)
end

function autoSoft()
--[[ Script de Auto Soft Boots
id da soft boots = 6529
id da soft boots(sendo usada) = 3549
id da worn soft boots = 6530
slot da boots = InventorySlotFeet
]]
	if soft == nil then
	soft = cycleEvent( function()
			if g_game.isOnline() then
				local player = g_game.getLocalPlayer()
				local slot = InventorySlotFeet
				local back = InventorySlotBack
				local bootsSlot = player:getInventoryItem(slot)
				local soft = player:getItem('6529')
				local botaPos = {['x'] = 65535, ['y'] = slot, ['z'] = 0}
				local backPos = {['x'] = 65535, ['y'] = back, ['z'] = 0}

					if bootsSlot == nil then
						g_game.move(soft, botaPos, soft:getCount())
					elseif bootsSlot:getId() == 6530 then
						g_game.move(bootsSlot, backPos, bootsSlot:getCount())
					elseif bootsSlot:getId() == 3549 then
						return
					end
					
			end
		end, 5000) 
	end
	softboots:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Soft Boots!'))
end

function cancelAutoSoft()
-- Cancelando o evento de soft
	removeEvent(soft)
	soft = nil
	softboots:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Soft Boots!'))
end

function moneyRune()
-- Script de estourar potion
	if rune == nil then
	rune = cycleEvent( function() 
			if g_game.isOnline() then
				local player = g_game.getLocalPlayer()
				local pos = player:getPosition()
				local rune = 3193
				local tileN = g_map.getTile({ x = pos.x, y = pos.y - 1, z = pos.z})
				local tileS = g_map.getTile({ x = pos.x, y = pos.y + 1, z = pos.z}) 
				local tileL = g_map.getTile({ x = pos.x + 1, y = pos.y, z = pos.z})
				local tileO = g_map.getTile({ x = pos.x - 1, y = pos.y, z = pos.z})
				local tileNE = g_map.getTile({ x = pos.x + 1, y = pos.y - 1, z = pos.z})
				local tileSE = g_map.getTile({ x = pos.x + 1, y = pos.y + 1, z = pos.z})
				local tileNO = g_map.getTile({ x = pos.x - 1, y = pos.y - 1, z = pos.z})
				local tileSO = g_map.getTile({ x = pos.x - 1, y = pos.y + 1, z = pos.z})	
				local tile = g_map.getTile(pos)
				local flask = tile:getTopThing()
				local flaskN = tileN:getTopThing()
				local flaskS = tileS:getTopThing()
				local flaskL = tileL:getTopThing()
				local flaskO = tileO:getTopThing()
				local flaskNE = tileNE:getTopThing()
				local flaskSE = tileSE:getTopThing()
				local flaskNO = tileNO:getTopThing()
				local flaskSO = tileSO:getTopThing()
				
					if flask:getId() == 283 or flask:getId() == 284 or flask:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flask)
					elseif flaskN:getId() == 283 or flaskN:getId() == 284 or flaskN:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskN)
					elseif flaskS:getId() == 283 or flaskS:getId() == 284 or flaskS:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskS)
					elseif flaskL:getId() == 283 or flaskL:getId() == 284 or flaskL:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskL)
					elseif flaskO:getId() == 283 or flaskO:getId() == 284 or flaskO:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskO)
					elseif flaskNE:getId() == 283 or flaskNE:getId() == 284 or flaskNE:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskNE)
					elseif flaskSE:getId() == 283 or flaskSE:getId() == 284 or flaskSE:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskSE)
					elseif flaskNO:getId() == 283 or flaskNO:getId() == 284 or flaskNO:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskNO)
					elseif flaskSO:getId() == 283 or flaskSO:getId() == 284 or flaskSO:getId() == 285 then
						Helper.safeUseInventoryItemWith(rune, flaskSO)
					end
				end
		end, 1000)
	end
	runeflask:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Money Rune!'))
end

function cancelMoneyRune()
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Money Rune!'))
	removeEvent(rune)
	rune = nil
	runeflask:setVisible(false)
end

function minerando()
-- Script de minerar
	if miningpick == nil then
		miningpick = cycleEvent( function()
			if g_game.isOnline() then
				local player = g_game.getLocalPlayer()
				local pos = player:getPosition()
				local pick = 3456
				local tileN = g_map.getTile({ x = pos.x, y = pos.y - 1, z = pos.z}):getTopThing()
				local tileS = g_map.getTile({ x = pos.x, y = pos.y + 1, z = pos.z}):getTopThing()
				local tileL = g_map.getTile({ x = pos.x + 1, y = pos.y, z = pos.z}):getTopThing()
				local tileO = g_map.getTile({ x = pos.x - 1, y = pos.y, z = pos.z}):getTopThing()
				local tileNE = g_map.getTile({ x = pos.x + 1, y = pos.y - 1, z = pos.z}):getTopThing()
				local tileSE = g_map.getTile({ x = pos.x + 1, y = pos.y + 1, z = pos.z}):getTopThing()
				local tileNO = g_map.getTile({ x = pos.x - 1, y = pos.y - 1, z = pos.z}):getTopThing()
				local tileSO = g_map.getTile({ x = pos.x - 1, y = pos.y + 1, z = pos.z}):getTopThing()

				if tileN:getId() == 5638 or tileN:getId() == 5639 or tileN:getId() == 5640 or tileN:getId() == 5641 or tileN:getId() == 5642 or
				tileN:getId() == 5643 or tileN:getId() == 5644 or tileN:getId() == 5645 or tileN:getId() == 5646 or tileN:getId() == 5647 or tileN:getId() == 5648 or
				tileN:getId() == 5649 or tileN:getId() == 5650 or tileN:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileN)
				elseif tileS:getId() == 5638 or tileS:getId() == 5639 or tileS:getId() == 5640 or tileS:getId() == 5641 or tileS:getId() == 5642 or
				tileS:getId() == 5643 or tileS:getId() == 5644 or tileS:getId() == 5645 or tileS:getId() == 5646 or tileS:getId() == 5647 or tileS:getId() == 5648 or
				tileS:getId() == 5649 or tileS:getId() == 5650 or tileS:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileS)
				elseif tileL:getId() == 5638 or tileL:getId() == 5639 or tileL:getId() == 5640 or tileL:getId() == 5641 or tileL:getId() == 5642 or
				tileL:getId() == 5643 or tileL:getId() == 5644 or tileL:getId() == 5645 or tileL:getId() == 5646 or tileL:getId() == 5647 or tileL:getId() == 5648 or
				tileL:getId() == 5649 or tileL:getId() == 5650 or tileL:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileL)
				elseif tileO:getId() == 5638 or tileO:getId() == 5639 or tileO:getId() == 5640 or tileO:getId() == 5641 or tileO:getId() == 5642 or
				tileO:getId() == 5643 or tileO:getId() == 5644 or tileO:getId() == 5645 or tileO:getId() == 5646 or tileO:getId() == 5647 or tileO:getId() == 5648 or
				tileO:getId() == 5649 or tileO:getId() == 5650 or tileO:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileO)
				elseif tileNE:getId() == 5638 or tileNE:getId() == 5639 or tileNE:getId() == 5640 or tileNE:getId() == 5641 or tileNE:getId() == 5642 or
				tileNE:getId() == 5643 or tileNE:getId() == 5644 or tileNE:getId() == 5645 or tileNE:getId() == 5646 or tileNE:getId() == 5647 or tileNE:getId() == 5648 or
				tileNE:getId() == 5649 or tileNE:getId() == 5650 or tileNE:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileNE)
				elseif tileSE:getId() == 5638 or tileSE:getId() == 5639 or tileSE:getId() == 5640 or tileSE:getId() == 5641 or tileSE:getId() == 5642 or
				tileSE:getId() == 5643 or tileSE:getId() == 5644 or tileSE:getId() == 5645 or tileSE:getId() == 5646 or tileSE:getId() == 5647 or tileSE:getId() == 5648 or
				tileSE:getId() == 5649 or tileSE:getId() == 5650 or tileSE:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileSE)
				elseif tileNO:getId() == 5638 or tileNO:getId() == 5639 or tileNO:getId() == 5640 or tileNO:getId() == 5641 or tileNO:getId() == 5642 or
				tileNO:getId() == 5643 or tileNO:getId() == 5644 or tileNO:getId() == 5645 or tileNO:getId() == 5646 or tileNO:getId() == 5647 or tileNO:getId() == 5648 or
				tileNO:getId() == 5649 or tileNO:getId() == 5650 or tileNO:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileNO)
				elseif tileSO:getId() == 5638 or tileSO:getId() == 5639 or tileSO:getId() == 5640 or tileSO:getId() == 5641 or tileSO:getId() == 5642 or
				tileSO:getId() == 5643 or tileSO:getId() == 5644 or tileSO:getId() == 5645 or tileSO:getId() == 5646 or tileSO:getId() == 5647 or tileSO:getId() == 5648 or
				tileSO:getId() == 5649 or tileSO:getId() == 5650 or tileSO:getId() == 5651 then
					Helper.safeUseInventoryItemWith(pick, tileSO)
				end
		end
	end, 1100)
end
if mininggems == nil then
	mininggems = cycleEvent( function()
		if g_game.isOnline() then
			local player = g_game.getLocalPlayer()
			local pos = player:getPosition()

			if  player:getItem('1792') ~= nil then
					g_game.move(player:getItem('1792'), pos, player:getItem('1792'):getCount())
				elseif player:getItem('1780') ~= nil then
						g_game.move(player:getItem('1780'), pos, player:getItem('1780'):getCount())
				elseif player:getItem('1782') ~= nil then
						g_game.move(player:getItem('1782'), pos, player:getItem('1782'):getCount())
				elseif player:getItem('3041') ~= nil then
						g_game.move(player:getItem('3041'), pos, player:getItem('3041'):getCount())
				elseif player:getItem('3039') ~= nil then
						g_game.move(player:getItem('3039'), pos, player:getItem('3039'):getCount())
				elseif player:getItem('3038') ~= nil then
						g_game.move(player:getItem('3038'), pos, player:getItem('3038'):getCount())
				elseif player:getItem('3037') ~= nil then
						g_game.move(player:getItem('3037'), pos, player:getItem('3037'):getCount())
				elseif player:getItem('3036') ~= nil then
						g_game.move(player:getItem('3036'), pos, player:getItem('3036'):getCount())
				elseif player:getItem('1781') ~= nil then
						g_game.move(player:getItem('1781'), pos, player:getItem('1781'):getCount())
					
			end
		end
	end, 1000/2)
end
if miningSkull == nil then
	miningSkull = cycleEvent( function()
			if g_game.isOnline() then
					local player = g_game.getLocalPlayer()
					local pos = player:getPosition()
					local tileN = g_map.getTile({ x = pos.x, y = pos.y - 1, z = pos.z})
					local tileS = g_map.getTile({ x = pos.x, y = pos.y + 1, z = pos.z})
					local tileL = g_map.getTile({ x = pos.x + 1, y = pos.y, z = pos.z})
					local tileO = g_map.getTile({ x = pos.x - 1, y = pos.y, z = pos.z})
					local tileNE = g_map.getTile({ x = pos.x + 1, y = pos.y - 1, z = pos.z})
					local tileSE = g_map.getTile({ x = pos.x + 1, y = pos.y + 1, z = pos.z})
					local tileNO = g_map.getTile({ x = pos.x - 1, y = pos.y - 1, z = pos.z})
					local tileSO = g_map.getTile({ x = pos.x - 1, y = pos.y + 1, z = pos.z})
			
			if  player:getItem('3207') ~= nil then
			
				if tileN:isWalkable() then
							g_game.move(player:getItem('3207'), tileN:getPosition(), player:getItem('3207'):getCount())
				elseif not tileN:isWalkable() ~= nil and tileS:isWalkable() then
							g_game.move(player:getItem('3207'), tileS:getPosition(), player:getItem('3207'):getCount())
				elseif not tileS:isWalkable() ~= nil and tileL:isWalkable() then
						g_game.move(player:getItem('3207'), tileL:getPosition(), player:getItem('3207'):getCount())
				elseif not tileL:isWalkable() ~= nil and tileO:isWalkable() then
						g_game.move(player:getItem('3207'), tileO:getPosition(), player:getItem('3207'):getCount())
				elseif not tileO:isWalkable() ~= nil and tileNE:isWalkable() then
						g_game.move(player:getItem('3207'), tileNE:getPosition(), player:getItem('3207'):getCount())
				elseif not tileNE:isWalkable() ~= nil and tileSE:isWalkable() then
						g_game.move(player:getItem('3207'), tileSE:getPosition(), player:getItem('3207'):getCount())
				elseif not tileSE:isWalkable() ~= nil and tileSO:isWalkable() then
						g_game.move(player:getItem('3207'), tileNO:getPosition(), player:getItem('3207'):getCount())
				elseif not tileNO:isWalkable() ~= nil and tileSO:isWalkable() then
						g_game.move(player:getItem('3207'), tileSO:getPosition(), player:getItem('3207'):getCount())
				end
			end
		end
	end, 1000/2)
end
if miningBlank == nil then
	miningBlank = cycleEvent( function()
			if g_game.isOnline() then
					local player = g_game.getLocalPlayer()
					local pos = player:getPosition()
					local tileN = g_map.getTile({ x = pos.x, y = pos.y - 1, z = pos.z})
					local tileS = g_map.getTile({ x = pos.x, y = pos.y + 1, z = pos.z})
					local tileL = g_map.getTile({ x = pos.x + 1, y = pos.y, z = pos.z})
					local tileO = g_map.getTile({ x = pos.x - 1, y = pos.y, z = pos.z})
					local tileNE = g_map.getTile({ x = pos.x + 1, y = pos.y - 1, z = pos.z})
					local tileSE = g_map.getTile({ x = pos.x + 1, y = pos.y + 1, z = pos.z})
					local tileNO = g_map.getTile({ x = pos.x - 1, y = pos.y - 1, z = pos.z})
					local tileSO = g_map.getTile({ x = pos.x - 1, y = pos.y + 1, z = pos.z})
					
			if  player:getItem('3147') ~= nil then
			
				if tileN:isWalkable() then
							g_game.move(player:getItem('3147'), tileN:getPosition(), player:getItem('3147'):getCount())
				elseif not tileN:isWalkable() ~= nil and tileS:isWalkable() then
							g_game.move(player:getItem('3147'), tileS:getPosition(), player:getItem('3147'):getCount())
				elseif not tileS:isWalkable() ~= nil and tileL:isWalkable() then
						g_game.move(player:getItem('3147'), tileL:getPosition(), player:getItem('3147'):getCount())
				elseif not tileL:isWalkable() ~= nil and tileO:isWalkable() then
						g_game.move(player:getItem('3147'), tileO:getPosition(), player:getItem('3147'):getCount())
				elseif not tileO:isWalkable() ~= nil and tileNE:isWalkable() then
						g_game.move(player:getItem('3147'), tileNE:getPosition(), player:getItem('3147'):getCount())
				elseif not tileNE:isWalkable() ~= nil and tileSE:isWalkable() then
						g_game.move(player:getItem('3147'), tileSE:getPosition(), player:getItem('3147'):getCount())
				elseif not tileSE:isWalkable() ~= nil and tileSO:isWalkable() then
						g_game.move(player:getItem('3147'), tileNO:getPosition(), player:getItem('3147'):getCount())
				elseif not tileNO:isWalkable() ~= nil and tileSO:isWalkable() then
						g_game.move(player:getItem('3147'), tileSO:getPosition(), player:getItem('3207'):getCount())
				end
			end
		end
	end, 1000/2)
end

if miningrune == nil then
	miningrune = cycleEvent( function()
		if g_game.isOnline() then
			local player = g_game.getLocalPlayer()
			local pos = player:getPosition()
			local tile = g_map.getTile(pos)
			local rune = 3193
			local pedra = tile:getTopThing()
			if  
				pedra:getId() == 1781 or 
				pedra:getId() == 3039 or 
				pedra:getId() == 3038 or 
				pedra:getId() == 1782 or 		
				pedra:getId() == 3036 or 
				pedra:getId() == 1780 or 
				pedra:getId() == 3041 or
				pedra:getId() == 3037 then
				
				Helper.safeUseInventoryItemWith(rune, pedra)
				elseif 	
				pedra:getId() ~= 1781 and 
				pedra:getId() ~= 3039 and  
				pedra:getId() ~= 3038 and  
				pedra:getId() ~= 1782 and 
				pedra:getId() ~= 3036 and 
				pedra:getId() ~= 1780 and 
				pedra:getId() ~= 3041 and
				pedra:getId() ~= 3037 then
				
				return
			end
		end
	end,1000/5)
end
modules.game_textmessage.displayGameMessage(tr('Voce ativou Mining!'))
mining:setVisible(false)
end

function cancelMining()
modules.game_textmessage.displayGameMessage(tr('Voce desativou Mining!'))
removeEvent(miningpick)
miningpick = nil
removeEvent(mininggems)
mininggems = nil
removeEvent(miningrune)
miningrune = nil
removeEvent(miningSkull)
miningSkull = nil
removeEvent(miningBlank)
miningBlank = nil
mining:setVisible(false)
end

function recconect()
if reccon == nil then
 reccon = cycleEvent(function ()
		if not g_game.isOnline() then
			CharacterList.doLogin() end 
		end , 5000)
end
	reconect:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Recconect!'))
end

function cancelRecconect()
	removeEvent(reccon)
	reccon = nil
	reconect:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Recconect!'))
end

function utevosio()
if buffmana == nil then
 buffmana =	cycleEvent( function()
	if g_game.isOnline() then
	local Name = g_game.getLocalPlayer():getName()
		g_game.talk('utevo gran sio "'..Name)
	end
	end, 550000)
end
	utevogran:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Utevo Gran Sio'))
end

function cancelUtevoSio()
	removeEvent(buffmana)
	buffmana = nil
	utevogran:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Utevo Gran Sio'))	
end

function autoMount()

	if montaria == nil then
		montaria = cycleEvent( function ()
			if g_game.isOnline() then
				g_game.mount(true)

			end
		end, 3000)
	end
	mount:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Mount'))
end

function cancelAutoMount()
	removeEvent(montaria)
	montaria = nil
	mount:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Mount'))
end

function autoSay()
	local magia = autosay:getChildById('magiaText'):getText()
	local delay = autosay:getChildById('delayText'):getText()*1
	if AUTOSAY == nil then
		AUTOSAY = cycleEvent( function()
			if g_game.isOnline() then
				g_game.talk(magia)
			end
		end, delay)
	end
	autosay:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Say'))
end

function cancelAutoSay()
	removeEvent(AUTOSAY)
	AUTOSAY = nil
	autosay:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Say'))
end

function autoSay2()
	local magia = autosay2:getChildById('magiaText'):getText()
	local delay = autosay2:getChildById('delayText'):getText()*1
	if AUTOSAY2 == nil then
		AUTOSAY2 = cycleEvent( function()
			if g_game.isOnline() then
				g_game.talk(magia)
			end
		end, delay)
	end
	autosay2:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Say2'))
end

function cancelAutoSay2()
	removeEvent(AUTOSAY2)
	AUTOSAY2 = nil
	autosay2:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Say2'))
end

function autoSay3()
	local magia = autosay3:getChildById('magiaText'):getText()
	local delay = autosay3:getChildById('delayText'):getText()*1
	if AUTOSAY3 == nil then
		AUTOSAY3 = cycleEvent( function()
			if g_game.isOnline() then
				g_game.talk(magia)
			end
		end, delay)
	end
	autosay3:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Say3'))
end

function cancelAutoSay3()
	removeEvent(AUTOSAY3)
	AUTOSAY3 = nil
	autosay3:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Say3'))
end

function autoSio()
local nome = autosio:getChildById('nickText'):getText()
local percent = autosio:getChildById('percentText'):getText()

if sioEvent == nil then
	sioEvent = cycleEvent(function () 
		local player = g_game.getLocalPlayer()
		local spectators = g_map.getSpectators(player:getPosition(), false)
		local magia = autosio:getChildById('magiaText'):getText()

		  for _, creature in ipairs(spectators) do
				if not creature:isLocalPlayer() then
					if creature:getName() == nome and creature:getHealthPercent() < percent*1 then
						g_game.talk('magia "'..nome)
					else
						return
					end
				end
			end
end, 2000)
end
	autosio:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce Ativou Auto Sio'))
end

function cancelAutoSio()
	removeEvent(sioEvent)
	sioEvent = nil
	autosio:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Sio'))
end

-- Faz o char deslogar!
--[[ 
function magicExani()
magiaExani = 1
	g_keyboard.bindKeyDown('Up', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "up')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Up', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "down')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Down', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "up')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Down', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "Down')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Left', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "up')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Left', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "down')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Right', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "up')
	else
		return 
	end
	end)
	g_keyboard.bindKeyDown('Right', function()
	if magiaExani == 1 then
		g_game.talk('exani hur "down')
	else
		return 
	end
	end)
	modules.game_textmessage.displayGameMessage(tr('Voce ativou Auto Exani Hur'))
	exanihur:setVisible(false) 
end

function cancelExani()
	magiaExani = 0
	exanihur:setVisible(false)
	modules.game_textmessage.displayGameMessage(tr('Voce desativou Auto Exani Hur'))
end
--]]
function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })
  
  scriptButton:destroy()
  scriptButton = nil
  
end

function online()
	scriptButton:enable()
end

function offline()
	--scriptButton:disable()
end


-- if player:hasState(PlayerStates.Pz) condição de pz