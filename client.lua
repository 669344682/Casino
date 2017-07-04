local screenWidth, screenHeight = guiGetScreenSize()
local scale = ((screenWidth/1920)+(screenHeight/1080))/2




function dxDrawCircle(posX, posY, radius, width, angleAmount, startAngle, stopAngle, color, postGUI, text)
	if(startAngle == stopAngle) then
		return false
	end
 
	local function clamp( val, lower, upper )
		if ( lower > upper ) then lower, upper = upper, lower end
		return math.max( lower, math.min( upper, val ) )
	end
 
	radius = type( radius ) == "number" and radius or 50
	width = type( width ) == "number" and width or 5
	angleAmount = type( angleAmount ) == "number" and angleAmount or 1
	startAngle = clamp( type( startAngle ) == "number" and startAngle or 0, 0, 360 )
	stopAngle = clamp( type( stopAngle ) == "number" and stopAngle or 360, 0, 360 )
	color = color or tocolor( 255, 255, 255, 200 )
	postGUI = type( postGUI ) == "boolean" and postGUI or false
 
	if ( stopAngle < startAngle ) then
		local tempAngle = stopAngle
		stopAngle = startAngle
		startAngle = tempAngle
	end
 
	local n = 0
	for i = startAngle, stopAngle, angleAmount do
		local startX = math.cos( math.rad( i ) ) * ( radius - width )
		local startY = math.sin( math.rad( i ) ) * ( radius - width )
		local endX = math.cos( math.rad( i ) ) * ( radius + width )
		local endY = math.sin( math.rad( i ) ) * ( radius + width )
		dxDrawLine(startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI)
		if(text) then
			dxDrawText(n, (startX/1.17)+posX,(startY/1.17)+posY, (startX/1.17)+posX,(startY/1.17)+posY, tocolor(160,160,160,255), scale/2, "default-bold", "center", "center")
			n=n+1
		end
	end
	return true
end










local ActionCasinoMarker = false
local RouletteRing = false
local RouletteLight = false
local RoulTick = {}

function onClientColShapeHit(thePlayer)
	if(thePlayer == getLocalPlayer()) then
		if(getElementData(source, "Casino")) then
			local dat = fromJSON(getElementData(source, "Casino"))
			if(dat[2] == "SLOT") then
				triggerEvent("ToolTip", localPlayer, "Однорукий бандит #457C3B$100#FFFFFF\nНажми Enter чтобы сыграть")
				bindKey("enter", "down", PlayCasino) 
				ActionCasinoMarker = source
			elseif(dat[2] == "Roulette") then
				triggerEvent("ToolTip", localPlayer, "Рулетка #457C3B$100#FFFFFF\nНажми Enter чтобы сыграть")
				bindKey("enter", "down", PlayCasino) 
				ActionCasinoMarker = source
			end
		end
	end
end
addEventHandler("onClientColShapeHit", getRootElement(), onClientColShapeHit)

function PlayCasino(casino, game)
	triggerServerEvent("PlayCasino", localPlayer, localPlayer, getElementData(ActionCasinoMarker, "Casino"))
end

function onClientColShapeLeave(thePlayer)
	if(source == ActionCasinoMarker) then
		if(thePlayer == getLocalPlayer()) then
			if(getElementData(source, "Casino")) then
				unbindKey("enter", "down", PlayCasino) 
			end
		end
	end
end
addEventHandler("onClientColShapeLeave", getRootElement(), onClientColShapeLeave)


function RoulettePlay(coord)
	setCameraMatrix(coord[1], coord[2], coord[3], coord[4], coord[5], coord[6])
	addEventHandler("onClientKey", root, RouletteKey)
	addEventHandler("onClientHUDRender", root, DrawRoulette)
end
addEvent("RoulettePlay", true)
addEventHandler("RoulettePlay", getRootElement(), RoulettePlay)



function RouletteTick(tick, color)
	RoulTick = {tick, color}
end
addEvent("RouletteTick", true)
addEventHandler("RouletteTick", getRootElement(), RouletteTick)


function DrawRoulette()
	if(RoulTick[1]) then
		local tw = dxGetTextWidth("6666", scale*3, "default-bold", true)
		local th = dxGetFontHeight(scale*3, "default-bold")
		
		dxDrawRectangle(screenWidth/2-(tw), 100*scale-(th/2), tw*2,th*2, tocolor(255,255,255,255))	
		
		dxDrawCircle(screenWidth/2, 100*scale+(th/2), th/3,th/3, 1, 0, 360, tocolor(RoulTick[2][1], RoulTick[2][2], RoulTick[2][3], RoulTick[2][4]))
		dxDrawText(RoulTick[1], 3, 100*scale+3, screenWidth, screenHeight, tocolor(0, 0, 0, 255), scale*3, "default-bold", "center", "top", nil, nil, nil, true)
		dxDrawText(RoulTick[1], 0, 100*scale, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*3, "default-bold", "center", "top", nil, nil, nil, true)
	end
end

function RouletteKey(button, press)
	if(press) then
		if(button == "escape") then
			RoulTick = {}
			setCameraTarget(localPlayer)
			destroyElement(RouletteRing)
			destroyElement(RouletteLight)
			removeEventHandler("onClientKey", root, RouletteKey)
			removeEventHandler("onClientHUDRender", root, DrawRoulette)
			
			triggerServerEvent("EndRoulette", localPlayer, localPlayer)
			cancelEvent()
		elseif(button == "w") then
			triggerServerEvent("RouletteControl", localPlayer, localPlayer, "up")
			cancelEvent()
		elseif(button == "s") then
			triggerServerEvent("RouletteControl", localPlayer, localPlayer, "down")
			cancelEvent()
		elseif(button == "a") then
			triggerServerEvent("RouletteControl", localPlayer, localPlayer, "left")
			cancelEvent()
		elseif(button == "d") then
			triggerServerEvent("RouletteControl", localPlayer, localPlayer, "right")
			cancelEvent()
		elseif(button == "enter") then
			triggerServerEvent("RouletteControl", localPlayer, localPlayer, "push")
		elseif(button == "space") then
			triggerServerEvent("RouletteControl", localPlayer, localPlayer, "rotate")
		end
	end
end


function SetRoulettePos(x,y,z,i)
	if(not isElement(RouletteRing)) then
		RouletteRing = createObject(1316, x,y,z+0.02)
		setElementInterior(RouletteRing, i)
		setObjectScale(RouletteRing, 0.06)
		RouletteLight = createLight(0, x,y,z, 0.25, 255,255,0, 0,0,0, false)
	else
		setElementPosition(RouletteRing, x,y,z+0.02)
		setElementPosition(RouletteLight, x,y,z)
	end
end
addEvent("SetRoulettePos", true)
addEventHandler("SetRoulettePos", getRootElement(), SetRoulettePos)


toggleAllControls(true)  -- убрать потом




