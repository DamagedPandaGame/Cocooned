--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- objects.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- GameData variables/booleans (gameData.lua)
local gameData = require("gameData")
local goals = require("goals")
local bonus = require("levels.bonus")
local fourteen = require("levels.fourteen")
local fifteen = require("levels.fifteen")
local one = require("levels.one")

local objects = {}



--------------------------------------------------------------------------------
-- Object - Load all objects
--------------------------------------------------------------------------------
local function init()
	physics.setGravity(0,0)
	
	-- Load runes
	rune = {
		[1] = display.newImage("mapdata/Items/blueRune.png"),
		[2] = display.newImage("mapdata/Items/greenRune.png"),
		[3] = display.newImage("mapdata/Items/pinkRune.png"),
		[4] = display.newImage("mapdata/Items/purpleRune.png"),
		[5] = display.newImage("mapdata/Items/yellowRune.png")
	}
	
	-- Assign object name
	rune[1].name = "blueRune"
	rune[2].name = "greenRune"
	rune[3].name = "pinkRune"
	rune[4].name = "purpleRune"
	rune[5].name = "yellowRune"
	
	-- load object sprites
	sheetList = {}

	sheetList.energy = graphics.newImageSheet("mapdata/art/coins.png", 
				 {width = 66, height = 56, sheetContentWidth = 267, sheetContentHeight = 56, numFrames = 4})
	sheetList["redAura"] = graphics.newImageSheet("mapdata/art/redAuraSheet.png", 
				 {width = 103, height = 103, sheetContentWidth = 2060, sheetContentHeight = 103, numFrames = 20})
	sheetList["greenAura"] = graphics.newImageSheet("mapdata/art/greenAuraSheet.png", 
				 {width = 103, height = 103, sheetContentWidth = 2060, sheetContentHeight = 103, numFrames = 20})

	
	-- Attach collision event to object
	-- Disable visibility
	for i=1, #rune do
		physics.addBody(rune[i], "dynamic", {bounce=0})
		rune[i].isVisible = false
		rune[i].collectable = true
		rune[i].func = "runeCollision"
	end
	
	return true
end

function createAnimations(count, name, objectList)
	for i = 1, count do
		objectList[name .. i] = display.newSprite(sheetList[name], spriteOptions[name])
		objectList[name .. i].name = name
		objectList[name .. i]:setSequence("move")
		objectList[name .. i]:play()
	end
	return true
end

function createSprites(count, name, objectList)
	for i = 1, count do
		print("creating:", count, name, i)
		objectList[name .. i] = display.newImage("mapdata/art/" .. name .. ".png")
		objectList[name .. i].name = name .. i
	end
	return true
end

local function createObjects(objectNumbers, pane)
	local energy = {}
	local objects = {}
	for i=1, tonumber(objectNumbers.energyCount) do
		energy[i] = display.newSprite(sheetList.energy, spriteOptions.energy)
		energy[i].isVisible = false
		energy[i].x, energy[i].y = 100, 100
	end	
	for i = 1, 3 do
		createAnimations(objectNumbers[pane][objectNames[i]], objectNames[i], objects)
	end
	for i = 4, 9 do
		createSprites(objectNumbers[pane][objectNames[i]], objectNames[i], objects)
	end
	return objects, energy
end

--------------------------------------------------------------------------------
-- Object Main
--------------------------------------------------------------------------------
local function main(mapData, map)
	init()
	
	-- Check levelNum then redirect
	if mapData.levelNum == "1" then
		print("loading level 1")
		objects, energy = createObjects(one, mapData.pane)
		one.load(mapData.pane, map, rune, objects, energy)
	elseif mapData.levelNum == "bonus" then
		bonus.load(mapData.pane, map, sheetList)
	elseif mapData.levelNum == "14" then
		fourteen.load(mapData.pane, map, rune, objects, sheetList)
	elseif mapData.levelNum == "15" then
		--objects.createObjects(fifteen.getObjects())
		print("loading level 15")
		objects, energy = createObjects(fifteen, mapData.pane)
		fifteen.load(mapData.pane, map, rune, objects, energy)
	else
		print("OBJECTS FOR LVL:", mapData.levelNum, "NOT MADE")
	end
end


--------------------------------------------------------------------------------
-- Object Clean Up
--------------------------------------------------------------------------------
local function destroy(mapData)
	for i=0, #rune do
		display.remove(rune[i])
		rune[i] = nil
	end
	print("DESTROY ALL OBJECTS!!!!!!!!")
	if mapData.levelNum == "1" then
		one.destroyAll()
	end
end

objects.main = main
objects.destroy = destroy

return objects