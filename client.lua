﻿local ActionCasinoMarker = false
addEvent("ToolTip", true)


function onClientColShapeHit(thePlayer)
	if(thePlayer == getLocalPlayer()) then
		if(getElementData(source, "Casino")) then
			triggerEvent("ToolTip", localPlayer, "Однорукий бандит $100\nНажми Enter чтобы сыграть")
			bindKey("enter", "down", PlayCasino) 
			ActionCasinoMarker = source
		end
	end
end
addEventHandler("onClientColShapeHit", getRootElement(), onClientColShapeHit)

function PlayCasino(casino, game)
	triggerServerEvent("PlayCasino", localPlayer, localPlayer, getElementData(ActionCasinoMarker, "Casino"))
end

function onClientColShapeLeave(thePlayer)
	if(thePlayer == getLocalPlayer()) then
		if(getElementData(source, "Casino")) then
			unbindKey("enter", "down", PlayCasino) 
		end
	end
end
addEventHandler("onClientColShapeLeave", getRootElement(), onClientColShapeLeave)

