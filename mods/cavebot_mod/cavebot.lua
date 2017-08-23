contador = 1
caveBot = {}
caveWindow = nil
path_interrupt = false
path_walk = false
walk_interrupt = false

local lastTime = 1
local clearOption = false
local cavebotDir = "/cavebot"
local refreshEvent
local popupStatus
local loadListIndex

function caveBot.online()
	if not g_resources.directoryExists(cavebotDir) then
		g_resources.makeDir(cavebotDir)
	end
	connect( g_game, {onTalk = commandOnText})
	connect( LocalPlayer, { onAutoWalkFail = onAutoWalkFail })
	connect( g_game,{ onTextMessage = onUseFail })
	contador = 1
	caveWindow = g_ui.displayUI('cavebot')
	saveWindow = g_ui.displayUI('save-load')
	saveWindow:hide()
	saveWindow.onEnter = saveHide
	saveWindow.onEscape = saveHide
	MenuButton = modules.client_topmenu.addLeftButton('button', tr('Waypoints'), 'Icon', botaoMenu)
	caveWindow:hide()
	caveWindow.onEnter = hide
	caveWindow.onEscape = hide
	
	LoadList = saveWindow:getChildById('LoadList')
	saveNameEdit = saveWindow:getChildById('fileText')
	LoadButton = saveWindow:getChildById('loadButton')
	
	caveBot.refreshDir()
	refreshEvent = cycleEvent(caveBot.refreshDir(),8000)
	connect( LocalPlayer, { onPositionChange = updatePosition })
	
	connect(LoadList, {
    onChildFocusChange = function(self, focusedChild, unfocusedChild, reason)
        if reason == ActiveFocusReason then return end
        if focusedChild == nil then 
          LoadButton:setEnabled(false)
          loadListIndex = nil
        else
          LoadButton:setEnabled(true)
          saveNameEdit:setText(string.gsub(focusedChild:getText(), ".otml", ""))
          loadListIndex = LoadList:getChildIndex(focusedChild)
        end
      end
    })
end

function caveBot.refreshDir()
	LoadList:destroyChildren()
	local files = g_resources.listDirectoryFiles(cavebotDir)
	for _,file in pairs(files) do
		caveBot.addFile(file)
	end
	LoadList:focusChild(LoadList:getChildByIndex(loadListIndex), ActiveFocusReason)
end

function caveBot.addFile(file)
  local item = g_ui.createWidget('ListRowComplex', LoadList)
  item:setText(file)
  item:setTextAlign(AlignLeft)
  item:setId(file)

  local removeButton = item:getChildById('remove')
  connect(removeButton, {
    onClick = function(button)
      if removeFileWindow then return end

      local row = button:getParent()
      local fileName = row:getText()

      local yesCallback = function()
        g_resources.deleteFile(cavebotDir..'/'..fileName)
        row:destroy()

        removeFileWindow:destroy()
        removeFileWindow=nil
      end
      local noCallback = function()
        removeFileWindow:destroy()
        removeFileWindow=nil
      end

      removeFileWindow = displayGeneralBox(tr('Delete'), 
        tr('Delete '..fileName..'?'), {
        { text=tr('Yes'), callback=yesCallback },
        { text=tr('No'), callback=noCallback },
        anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
    end
  })
end

function caveBot.saveWaypoints(fileName)
	local patch = cavebotDir.."/"..fileName..".otml"
	local arquivo = g_configs.load(patch)
	
	if arquivo then
		local wpObjs = caveBot.getWaypoints()
		local wp = {}
		
		for k,v in pairs(caveBot.getWaypoints()) do
			wp[k] = v:getText()
		end
		
		arquivo:setNode('Waypoints', wp)
		arquivo:save()
	else
		arquivo = g_configs.create(patch)
		local wpObjs = caveBot.getWaypoints()
		local wp = {}
		
		for k,v in pairs(caveBot.getWaypoints()) do
			wp[k] = v:getText()
		end
		
		arquivo:setNode('Waypoints', wp)
		arquivo:save()
	end
end

function caveBot.loadWaypoints(fileName)
	local patch = cavebotDir.."/"..fileName
	local arquivo = g_configs.load(patch)
	local wpOrganizado = {}
	if arquivo then
		local arqLoad = arquivo:getNode('Waypoints')
		
		if caveWindow:getChildById('caveEnable'):isChecked() then 
			caveWindow:getChildById('caveEnable'):setChecked(false)
		end
		
		if #caveBot.getWaypoints() > 0 then
			for k,v in ipairs(caveBot.getWaypoints()) do 
				v:destroy()
				v = nil
			end
		end
		for k,v in pairs(arqLoad) do 
            table.insert(wpOrganizado,v)
		end
		
		wpOrganizado = organizaArquivo(wpOrganizado)
		
		for k,v in ipairs(wpOrganizado) do
			caveBot.addWaypoint(v)
		end
		contador = 1
	else
		print("Este arquivo nao existe")
	end
end

function caveBot.getDir()
	return cavebotDir
end

function onAutoWalkFail(player)
	contador = contador + 1
end

function onUseFail(mode, msg)
	if msg == "First go downstairs." or msg == "First go upstairs." then
		contador = contador + 1
	end
end

function hide()
	caveWindow:hide()
end

function saveHide()
	saveWindow:hide()
end

function botaoMenu()
	if caveWindow:isVisible() then
		caveWindow:hide()
	else
		caveWindow:show()
		caveWindow:focus()
	end
end

function caveBot.offline()
	disconnect( LocalPlayer, { onPositionChange = updatePosition })
	disconnect( g_game, {onTalk = commandOnText})
	disconnect( LocalPlayer, { onAutoWalkFail = onAutoWalkFail })
	disconnect( g_game,{ onTextMessage = onUseFail })
	terminatePopup()
	caveWindow:destroy()
end

function caveBot.addWaypoint(way)
	local waypoint = way
	lista = caveWindow:getChildById('wpList')
	local item = g_ui.createWidget('Waypoint', lista)
	item:setText(waypoint)
end

function caveBot.getWaypoints()
	return caveWindow:getChildById('wpList'):getChildren()
end

function caveBot.removeWaypoint()
	local selected = caveWindow:getChildById('wpList'):getFocusedChild()
	
	 if selected then
		selected:destroy()
		selected = nil
	end
end

function caveBot.clearConfirm()
	if clearOption == false then
		clearOption = true
	else
		return
	end
	clearWindow = displayGeneralBox("Clear Waypoints"," Deseja apagar todos waypoints?",{
	{text = "Confirmar", callback = caveBot.clearWaypoint},
	{text = "Cancelar", callback = caveBot.clearCancel},
	anchor = AnchorHorizontalCenter},
	caveBot.clearWaypoint, caveBot.clearCancel)
end

function caveBot.clearCancel()
	clearWindow:destroy()
	clearWindow = nil
	if clearOption == true then
		clearOption = false
	end
end

function caveBot.clearWaypoint()
	for k,v in ipairs(caveBot.getWaypoints()) do 
		v:destroy()
		v = nil
	end
	clearWindow:destroy()
	clearWindow = nil
		if clearOption == true then
		clearOption = false
	end
end

function cave()
if andar == nil then
	andar = cycleEvent(function ()
		local currentTime = os.time()
		
		if #caveBot.getWaypoints() == 0 then
			return
		end
		if contador > #caveBot.getWaypoints() then
			contador = 1
		end
		if not g_game.isOnline() then
			return
		end
		local player = g_game.getLocalPlayer()
		local pos = player:getPosition()
		
		if player:isAutoWalking() or player:isServerWalking() then
			lastTime = currentTime
			return
		end
		
		if g_game.isAttacking() then
			lastTime = currentTime
			return
		end
		
		if (currentTime - lastTime) > 199999 then
			lastTime = currentTime
		end
		if (currentTime - lastTime) > 10 then
			contador = contador + 1
			lastTime = currentTime
			return
		end
		caveBot.getWaypoints()[contador]:focus()
		local wpArray = caveBot.getWaypoints()[contador]:getText():explode(";") --[[ Separando a position do modo ]]
		local stringPos = wpArray[1]:explode(",")
		local wpX = tonumber(stringPos[1]) -- Separando as posições X,Y,Z.
		local wpY = tonumber(stringPos[2])
		local wpZ = tonumber(stringPos[3])

		local delaySleep = wpX*1000
		if wpArray[2] == "Sleep" then  -- Verificando o modo do waypoint.
			removeEvent(andar) andar = nil
				scheduleEvent(function () 
					contador = contador + 1
					lastTime = currentTime
					cave()
				end, delaySleep)
		end
		
		if wpArray[2] == "Walk" then
			if caveWindow:getChildById('PathFind'):isChecked() then
				local toposPath = {x = wpX, y = wpY, z = wpZ}
				local result = g_map.findPath(player:getPosition(),toposPath, 50000, PathFindFlags.AllowNonPathable)
				
				if #result <= 0 then
				    path_interrupt = false
					contador = contador + 1
					lastTime = currentTime
					if contador <= #caveBot.getWaypoints() then
						caveBot.getWaypoints()[contador]:focus()
					end
				end
				if #result >= 1 then
					path_interrupt = true
				end
				
				if path_interrupt == true then
						g_game.autoWalk(result)
					if postostring(player:getPosition()) == postostring(toposPath) then
						contador = contador + 1
						lastTime = currentTime
						if contador <= #caveBot.getWaypoints() then
							caveBot.getWaypoints()[contador]:focus()
						end
					end
				end
			end
			if not caveWindow:getChildById('PathFind'):isChecked() then
				local toposWalk = g_map.getTile({x = wpX, y = wpY, z = wpZ})
				
				if not toposWalk then
					local walkImpossiblePath = {x = wpX, y = wpY, z = wpZ}
					local walkImpossible = g_map.findPath(player:getPosition(), walkImpossiblePath, 50000, 0)
					
					if #walkImpossible <= 0 then
						path_interrupt = false
						contador = contador + 1
						lastTime = currentTime
						if contador <= #caveBot.getWaypoints() then
							caveBot.getWaypoints()[contador]:focus()
						end
					end
					if #walkImpossible >= 1 then
						path_interrupt = true
					end
					if path_interrupt == true then
						g_game.autoWalk(walkImpossible)
					if postostring(player:getPosition()) == postostring(walkImpossiblePath) then
						contador = contador + 1
						lastTime = currentTime
						if contador <= #caveBot.getWaypoints() then
							caveBot.getWaypoints()[contador]:focus()
						end
					end
				end
				end
				if toposWalk then
				player:autoWalk(toposWalk:getPosition())
				
					if postostring(player:getPosition()) == postostring(toposWalk:getPosition()) then
						contador = contador + 1
						lastTime = currentTime
						if contador <= #caveBot.getWaypoints() then
							caveBot.getWaypoints()[contador]:focus()
						end
					end
				end
			end
		end
		
		if wpArray[2] == "Use" then
			local toThing = g_map.getTile({x = wpX, y = wpY, z = wpZ})
			local toPos = g_map.getTile({x = wpX, y = wpY, z = wpZ})
			
			if not toThing then
				return
			end
			
			g_game.use(toThing:getTopThing())
			
			if getDistanceBetween(player:getPosition(), toPos:getPosition()) == 1 then
				contador = contador + 1
				lastTime = currentTime
				if contador <= #caveBot.getWaypoints() then
					caveBot.getWaypoints()[contador]:focus()
				end
			end
		end
		
		if wpArray[2] == "North" then
			local toPos = g_map.getTile({x = wpX, y = wpY, z = wpZ})
			
			if not toPos then
				return
			end
			if postostring(player:getPosition()) == postostring(toPos:getPosition()) then
				g_game.walk(North)
			end
			if tostring(player:getPosition().z) ~= tostring(toPos:getPosition().z) then
					contador = contador + 1
					lastTime = currentTime
				if contador <= #caveBot.getWaypoints() then
					caveBot.getWaypoints()[contador]:focus()
				end
			end
		end
		
		if wpArray[2] == "South" then
			local toPos = g_map.getTile({x = wpX, y = wpY, z = wpZ})
			
			if not toPos then
				return
			end
			
			if postostring(player:getPosition()) == postostring(toPos:getPosition()) then
				g_game.walk(South)
			end
			if tostring(player:getPosition().z) ~= tostring(toPos:getPosition().z) then
					contador = contador + 1
					lastTime = currentTime
				if contador <= #caveBot.getWaypoints() then
					caveBot.getWaypoints()[contador]:focus()
				end
			end
		end
		
		if wpArray[2] == "East" then
			local toPos = g_map.getTile({x = wpX, y = wpY, z = wpZ})
			
			if not toPos then
				return
			end
			
			if postostring(player:getPosition()) == postostring(toPos:getPosition()) then
				g_game.walk(East)
			end
			if tostring(player:getPosition().z) ~= tostring(toPos:getPosition().z) then
					contador = contador + 1
					lastTime = currentTime
				if contador <= #caveBot.getWaypoints() then
					caveBot.getWaypoints()[contador]:focus()
				end
			end
		end
		
		if wpArray[2] == "West" then
			local toPos = g_map.getTile({x = wpX, y = wpY, z = wpZ})
			
			if not toPos then
				return
			end
			
			if postostring(player:getPosition()) == postostring(toPos:getPosition()) then
				g_game.walk(West)
			end
			if tostring(player:getPosition().z) ~= tostring(toPos:getPosition().z) then
					contador = contador + 1
					lastTime = currentTime
				if contador <= #caveBot.getWaypoints() then
					caveBot.getWaypoints()[contador]:focus()
				end
			end
		end
		
	end, 500)
					
end
end

function updatePosition()
	local pos = g_game:getLocalPlayer():getPosition()
	caveWindow:getChildById('posText'):setText(string.format('%i, %i, %i', pos.x, pos.y, pos.z))
end

function delcave()
	removeEvent(andar)
	lastTime = 0
	andar = nil
end

function addSleep(sleep)
	if not g_game.isOnline() then
		return
	end
	
	local waypoint = sleep..','..sleep..','..sleep..";Sleep;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)
end

function addWalk()
	if not g_game.isOnline() then
		return
	end
	local pos = g_game.getLocalPlayer():getPosition()
	local waypoint = pos.x..","..pos.y..","..pos.z..";Walk;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)
end

function addUse()
	if not g_game.isOnline() then
		return
	end
	local pos = g_game.getLocalPlayer():getPosition()
	local waypoint = pos.x..","..pos.y..","..pos.z..";Use;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)
end

function addStairNorth()
	if not g_game.isOnline() then
		return
	end
	local pos = g_game.getLocalPlayer():getPosition()
	local waypoint = pos.x..","..pos.y..","..pos.z..";North;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)
end

function addStairSouth()
	if not g_game.isOnline() then
		return
	end
	local pos = g_game.getLocalPlayer():getPosition()
	local waypoint = pos.x..","..pos.y..","..pos.z..";South;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)

end

function addStairEast()
	if not g_game.isOnline() then
		return
	end
	local pos = g_game.getLocalPlayer():getPosition()
	local waypoint = pos.x..","..pos.y..","..pos.z..";East;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)
end

function addStairWest()
	if not g_game.isOnline() then
		return
	end
	local pos = g_game.getLocalPlayer():getPosition()
	local waypoint = pos.x..","..pos.y..","..pos.z..";West;"..#caveBot.getWaypoints() + 1
	caveBot.addWaypoint(waypoint)

end
function initPopup()
		modules.game_interface.addMenuHook("1234", tr("Add Waypoint(Walk)"), 
    function(menuPosition, lookThing, useThing, creatureThing)
			local pos = lookThing:getPosition()
			local waypoint = pos.x..","..pos.y..","..pos.z..";Walk;"..#caveBot.getWaypoints() + 1
			caveBot.addWaypoint(waypoint)
    end,
    function(menuPosition, lookThing, useThing, creatureThing)
      return lookThing ~= nil and lookThing:getTile() ~= nil
    end)
	
	modules.game_interface.addMenuHook("1234", tr("Add Waypoint(Use)"), 
    function(menuPosition, lookThing, useThing, creatureThing)
			local pos = lookThing:getPosition()
			local waypoint = pos.x..","..pos.y..","..pos.z..";Use;"..#caveBot.getWaypoints() + 1
			caveBot.addWaypoint(waypoint)
    end,
    function(menuPosition, lookThing, useThing, creatureThing)
      return lookThing ~= nil and lookThing:getTile() ~= nil
    end)
	
	modules.game_interface.addMenuHook("123", tr("Add Stair(North)"), 
    function(menuPosition, lookThing, useThing, creatureThing)
			local pos = lookThing:getPosition()
			local waypoint = pos.x..","..pos.y..","..pos.z..";North;"..#caveBot.getWaypoints() + 1
			caveBot.addWaypoint(waypoint)
    end,
    function(menuPosition, lookThing, useThing, creatureThing)
      return lookThing ~= nil and lookThing:getTile() ~= nil
    end)
	modules.game_interface.addMenuHook("123", tr("Add Stair(South)"), 
    function(menuPosition, lookThing, useThing, creatureThing)
			local pos = lookThing:getPosition()
			local waypoint = pos.x..","..pos.y..","..pos.z..";South;"..#caveBot.getWaypoints() + 1
			caveBot.addWaypoint(waypoint)
    end,
    function(menuPosition, lookThing, useThing, creatureThing)
      return lookThing ~= nil and lookThing:getTile() ~= nil
    end)
	modules.game_interface.addMenuHook("123", tr("Add Stair(East)"), 
    function(menuPosition, lookThing, useThing, creatureThing)
			local pos = lookThing:getPosition()
			local waypoint = pos.x..","..pos.y..","..pos.z..";East;"..#caveBot.getWaypoints() + 1
			caveBot.addWaypoint(waypoint)
    end,
    function(menuPosition, lookThing, useThing, creatureThing)
      return lookThing ~= nil and lookThing:getTile() ~= nil
    end)
	modules.game_interface.addMenuHook("123", tr("Add Stair(West)"), 
    function(menuPosition, lookThing, useThing, creatureThing)
			local pos = lookThing:getPosition()
			local waypoint = pos.x..","..pos.y..","..pos.z..";West;"..#caveBot.getWaypoints() + 1
			caveBot.addWaypoint(waypoint)
    end,
    function(menuPosition, lookThing, useThing, creatureThing)
      return lookThing ~= nil and lookThing:getTile() ~= nil
    end)
	popupStatus = true
end

function terminatePopup()
	if popupStatus then
		 modules.game_interface.removeMenuHook("1234", tr("Add Waypoint(Walk)"))
		modules.game_interface.removeMenuHook("1234", tr("Add Waypoint(Use)"))
		modules.game_interface.removeMenuHook("123", tr("Add Stair(North)"))
		modules.game_interface.removeMenuHook("123", tr("Add Stair(South)"))
		modules.game_interface.removeMenuHook("123", tr("Add Stair(East)"))
		modules.game_interface.removeMenuHook("123", tr("Add Stair(West)"))
	popupStatus = false
	end
end

function organizaArquivo(vetor)
	local aux
	for i=1, #vetor do
		for j=1, #vetor do
			if tonumber(vetor[i]:explode(';')[3]) < tonumber(vetor[j]:explode(';')[3]) then
				aux = vetor[j]
				vetor[j] = vetor[i]
				vetor[i] = aux
			end
		end
	end
	
	return vetor
end