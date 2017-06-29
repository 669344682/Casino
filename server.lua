-- model, x,y,z, rx,ry,rz, i, d
local CasinoGame = {
	["The Four Dragons"] = {
		["SLOT1"] = {
			[1] = {2327, 1965.09, 998.20, 992.99, 0,0,80, 10, 0},
			[2] = {2327, 1965.11, 998.32, 992.99, 0,0,80, 10, 0},
			[3] = {2327, 1965.13, 998.44, 992.99, 0,0,80, 10, 0},
		},
		["SLOT2"] = {
			[1] = {2347, 1962.35, 991.81, 992.99, 0,0,54, 10, 0},
			[2] = {2347, 1962.42, 991.89, 992.99, 0,0,54, 10, 0},
			[3] = {2347, 1962.48, 991.97, 992.99, 0,0,54, 10, 0},
		},
		["SLOT3"] = {
			[1] = {2347, 1957.64, 987.13, 992.99, 0,0,32, 10, 0},
			[2] = {2347, 1957.75, 987.20, 992.99, 0,0,32, 10, 0},
			[3] = {2347, 1957.85, 987.28, 992.99, 0,0,32, 10, 0},
		},
		["SLOT4"] = {
			[1] = {2347, 1964.58, 998.54, 992.99, 0,0,259, 10, 0}, 
			[2] = {2347, 1964.55, 998.42, 992.99, 0,0,259, 10, 0}, 
			[3] = {2347, 1964.53, 998.30, 992.99, 0,0,259, 10, 0},
		},
		["SLOT5"] = {
			[1] = {2347, 1961.89, 992.08, 992.99, 0,0,235, 10, 0},
			[2] = {2347, 1961.95, 992.18, 992.99, 0,0,235, 10, 0},
			[3] = {2347, 1962.02, 992.28, 992.99, 0,0,235, 10, 0},
		},
		["SLOT6"] = {
			[1] = {2347, 1957.33, 987.58, 992.99, 0,0,213, 10, 0}, 
			[2] = {2347, 1957.43, 987.65, 992.99, 0,0,213, 10, 0}, 
			[3] = {2347, 1957.53, 987.72, 992.99, 0,0,213, 10, 0}, 
		}, 
		["SLOT7"] = {
			[1] = {2347, 1965.12, 1037.25, 992.99, 0,0,101, 10, 0},
			[2] = {2347, 1965.10, 1037.37, 992.99, 0,0,101, 10, 0},
			[3] = {2347, 1965.07, 1037.49, 992.99, 0,0,101, 10, 0},
		},
		["SLOT8"] = {
			[1] = {2347, 1962.46, 1043.56, 992.99, 0,0,123, 10, 0},
			[2] = {2347, 1962.40, 1043.65, 992.99, 0,0,123, 10, 0},
			[3] = {2347, 1962.34, 1043.74, 992.99, 0,0,123, 10, 0},
		},
		["SLOT9"] = {
			[1] = {2347, 1957.54, 1048.50, 992.99, 0,0,145, 10, 0},
			[2] = {2347, 1957.64, 1048.44, 992.99, 0,0,145, 10, 0},
			[3] = {2347, 1957.74, 1048.37, 992.99, 0,0,145, 10, 0},
		},
	}
}






local CasinoObjectInfo = {
	[2327] = {
		[0] = "Cherry",
		[18] = "Bar",
		[36] = "Cherry",
		[54] = "Blueberry",
		[72] = "Seven",
		[90] = "Melon",
		[108] = "Seven",
		[126] = "Blueberry",
		[144] = "Bell",
		[162] = "Melon",
		[180] = "Cherry",
		[198] = "Double Bar",
		[216] = "Cherry",
		[234] = "Tripple Bar",
		[252] = "Seven",
		[270] = "Blueberry",
		[288] = "Bar",
		[306] = "Seven",
		[324] = "Melon",
		[342] = "Bell"
	},
	[2347] = {
		[0] = "Double Gold",
		[20] = "69",
		[40] = "Gold",
		[60] = "Bell",
		[80] = "Cherry",
		[100] = "Blueberry",
		[120] = "Cherry",
		[140] = "Blueberry",
		[160] = "Bell",
		[180] = "69",
		[200] = "Bell",
		[220] = "Gold",
		[240] = "Cherry",
		[260] = "Blueberry",
		[280] = "69",
		[300] = "Blueberry",
		[320] = "Bell",
		[340] = "Cherry",
	}
}

local CasinoPrice = {
	["Blueberry"] = 2,
	["Cherry"] = 4,
	["Bar"] = 7,
	["Gold"] = 7,
	["Bell"] = 10,
	["Double Bar"] = 15,
	["Double Gold"] = 15,
	["69"] = 20,
	["Tripple Bar"] = 25,
	["Melon"] = 30,
	["Seven"] = 30
}



function RotateBandits(obj, times) -- Возвращает значение
	local MaxCombo = 360/getArrSize(CasinoObjectInfo[getElementModel(obj)])
	local rx,ry,rz = getElementRotation(obj)
	rx = math.round(rx)
	local out = rx+(times*MaxCombo)
	if(out >= 360) then
		out = out-(360*math.floor(out/360))
	end

	setTimer(function(obj)
		local x,y,z = getElementPosition(obj)
		local rx,ry,rz = getElementRotation(obj)
		rx = math.round(rx)
		setElementRotation(obj,rx+MaxCombo,ry,rz, "default")
	end, 50, times, obj)
	return CasinoObjectInfo[getElementModel(obj)][out]
end



function PlayCasino(thePlayer, dat)
	dat = fromJSON(dat)
	local casino, game = dat[1], dat[2]
	if(not isTimer(CasinoGame[casino][game]["timer"])) then
		if(triggerEvent("AddPlayerMoney", thePlayer, thePlayer, -100)) then
			local MaxCombo = 360/getArrSize(CasinoObjectInfo[getElementModel(CasinoGame[casino][game][1])])
			local r1,r2,r3 = math.random(1,MaxCombo), math.random(MaxCombo,MaxCombo*2), math.random(MaxCombo*2,MaxCombo*3)
			victory = false
			local ro1, ro2, ro3 = RotateBandits(CasinoGame[casino][game][1], r1), RotateBandits(CasinoGame[casino][game][2], r2), RotateBandits(CasinoGame[casino][game][3], r3)
			if(ro1 == ro2) then
				victory = CasinoPrice[ro1]*CasinoPrice[ro2]
				if(ro2 == ro3) then
					victory = CasinoPrice[ro1]*CasinoPrice[ro2]*CasinoPrice[ro3]
				end
			end
			CasinoGame[casino][game]["timer"] = setTimer(function(thePlayer, victory)
				if(victory) then
					triggerEvent("AddPlayerMoney", thePlayer, thePlayer, victory, "ВЫИГРЫШ")
				end
			end, 1000+(50*r3), 1, thePlayer, victory)
		end
	end
end
addEvent("PlayCasino", true)
addEventHandler("PlayCasino", root, PlayCasino)



for CasinoName, data in pairs(CasinoGame) do
	for name, obj in pairs(data) do
		local col = createColSphere(obj[2][2], obj[2][3], obj[2][4], 1)
		setElementData(col, "Casino", toJSON({CasinoName, name}))
		for i, dat in pairs(obj) do
			CasinoGame[CasinoName][name][i] = createObject(dat[1], dat[2], dat[3], dat[4], dat[5], dat[6], dat[7])
			setElementInterior(CasinoGame[CasinoName][name][i], dat[8])
			setElementDimension(CasinoGame[CasinoName][name][i], dat[9])
		end
	end
end



function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getArrSize(arr)
	local i = 0
	for _,_ in pairs(arr) do i=i+1 end
	return i
end