--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- two.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- GameData variables/booleans (gameData.lua)
local gameData = require("gameData")
local moveableObject = require("moveableObject")


local two = { 
	energyCount = 30,
	["M"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["moveWall"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0
	},
	["D"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["moveWall"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0
	},
	["U"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["moveWall"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0
	},
	["R"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["moveWall"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0
	},	
	["L"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["moveWall"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0
	}
}

local objectList

local function generateEnergy(energy, map, startIndex, endIndex)
	for i=startIndex, endIndex do
		--print("Create energy at: ", energy[i].name)
		energy[i].speed = 50
	   	energy[i].isVisible = true
	   	energy[i].func = "energyCollision"
	   	energy[i].collectable = true
	   	energy[i].name = "energy" .. i
		map.layer["tiles"]:insert(energy[i])
		energy[i]:setSequence("move")
		energy[i]:play()
		physics.addBody(energy[i], "static", {bounce=0})
	end
end

local function generateObjects(objects, map, pane, runes)
	for i = 1, #objectNames do
		local name = objectNames[i]
		print("generating:", two[pane][name])
		for j = 1, two[pane][name] do
			map.layer["tiles"]:insert(objects[name .. j])
			objects[name .. j].func = name .. "Collision"
			physics.addBody(objects[name ..j], "static", {bounce = 0})
			objects[name ..j].collType = "passThru"
		end
	end

	for i = 1, #rune do
		if rune[i].isVisible == true then
			map.layer["tiles"]:insert(rune[i])
		end
	end
end

local mObjects = {}

local function generateMoveableObjects(objects, map, pane)
	mObjects = {}
	for i = 1, two[pane]["moveWall"] do
		mObjects[i] = moveableObject.create()
		mObjects[i].object = objects["moveWall" .. i]

		local startX, startY = objects["moveWall" .. i].x, objects["moveWall" .. i].y
		--print("startX:", startX)
		local endX, endY = objects["moveWall" .. i].eX, objects["moveWall" .. i].eY
		local time = objects["moveWall" .. i].time

		mObjects[i].object.startX, mObjects[i].object.startY = startX, startY
		mObjects[i].object.endX, mObjects[i].object.endY = endX, endY
		mObjects[i].object.time = time
		mObjects[i]:startTransition(mObjects[i].object)
	end
	

end

local function destroyObjects(rune, energy, objects) 

	-- deleted extra runes
	for i = 1, #rune do
		if rune[i].isVisible == false then
			rune[i]:removeSelf()
			rune[i] = nil
		end
	end

	-- deleted extra energies
	for i = 1, two.energyCount do
		--print("energyCount:", i)
		if energy[i].isVisible == false then
			energy[i]:removeSelf()
			energy[i] = nil
		end
	end
end

local function load(pane, map, rune, objects, energy)
	objectList = objects
	
	-- Check which pane
	if pane == "M" then
	
	elseif pane == "U" then
	
	elseif pane == "D" then

	elseif pane == "R" then

	elseif pane == "L" then
		
	end
end

local function destroyAll() 

	for i=1, #energy do
		display.remove(energy[i])
		energy[i] = nil
	end
	for i=1, #mObjects do
		mObjects[i]:endTransition()
	end
end

two.load = load
two.destroyAll = destroyAll
two.takeWallsDown = takeWallsDown

return two