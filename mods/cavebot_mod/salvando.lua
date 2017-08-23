
function salva()
	local arq = "/cavebot/arquivo.otml"

	arquivo = g_configs.load(arq)

	local wpObjs = caveBot.getWaypoints()
	local wp = {}

	for k,v in pairs(caveBot.getWaypoints()) do
		wp[k] = v:getText()
	end

	arquivo:setNode('Waypoints', wp)
	arquivo:save()
end

function carregar()
	local arq = "/cavebot/arquivo.otml"

	arquivo = g_configs.load(arq)
	
	local arqLoad = arquivo:getNode('Waypoints')
	
	for k,v in pairs(arqLoad) do 
		caveBot.addWaypoint(v)
	end
end



if not g_resources.directoryExists(writeDir) then
    g_resources.makeDir(writeDir)
  end