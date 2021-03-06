--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocofourdgame.com/)
-- fifteen.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
-- GameData variables/booleans (gameData.lua)
local gameData = require("Core.gameData")
-- generator for objects (generateObjects.lua)
local generate = require("Objects.generateObjects")
-- variable access for shadows
local shadows = require("utils.shadows")

--------------------------------------------------------------------------------
-- Level fifteen Variables
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local fifteen = { 
	-- boolean for which pane is being used
	-- { Middle, Up, Down, Right, Left }
	panes = {true,true,true,true,true},
	-- Check to see which runes are available
	-- Choices: "none", "blueRune", "greenRune", "pinkRune", "purpleRune", "yellowRune"
	--             nil,    rune[1],     rune[2],    rune[3],      rune[4],      rune[5]
	runeAvailable = {["M"]= {"none"}, 
					 ["U"]= {"pinkRune", "purpleRune"}, 
					 ["D"]= {"purpleRune"}, 
					 ["R"]= {"purpleRune"}, 
					 ["L"]= {"greenRune"}},
	timer = 300,
	playerCount = 2,
	playerPos = {{["x"]=12, ["y"]=16},
				 {["x"]=30, ["y"]=12},},
	-- number of wisps in the level
	wispCount = 38,
	-- number of objects in each pane (M,D,U,R,L)
	-- if there is a certain object in that pane, set the quantity of that object here
	-- else leave it at 0
	["M"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["wolf"] = 0,
		["fish1"] = 0,
		["fish2"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0,
		["exitPortal"] = 0,
		["enemy"] = 0,
		["fixedIceberg"] = 0,
		["worldPortal"] = 0
	},
	["D"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["wolf"] = 0,
		["fish1"] = 0,
		["fish2"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0,
		["exitPortal"] = 0, 
		["enemy"] = 0,
		["fixedIceberg"] = 0,
		["worldPortal"] = 0
	},
	["U"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 2,
		["wolf"] = 0,
		["fish1"] = 1,
		["fish2"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0,
		["exitPortal"] = 0, 
		["enemy"] = 0,
		["fixedIceberg"] = 0,
		["worldPortal"] = 0
	},
	["R"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["wolf"] = 0,
		["fish1"] = 0,
		["fish2"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0,
		["exitPortal"] = 1, 
		["enemy"] = 0,
		["fixedIceberg"] = 0,
		["worldPortal"] = 0
	},	
	["L"] = {
		["blueAura"] = 0,
		["redAura"] = 0,
		["greenAura"] = 0,
		["wolf"] = 0,
		["fish1"] = 0,
		["fish2"] = 0,
		["blueTotem"] = 0,
		["redTotem"] = 0,
		["greenTotem"] = 0,
		["switch"] = 0,
		["switchWall"] = 0,
		["exitPortal"] = 0, 
		["enemy"] = 0,
		["fixedIceberg"] = 2,
		["worldPortal"] = 0
	}
}

-- variable that holds objects of pane for later use
local objectList
local mObjectslocal 

--------------------------------------------------------------------------------
-- load pane function
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
-- loads objects depending on which pane player is in
-- this is where the objects locations are set in each pane
local function load(mapData, map, rune, objects, wisp, water, wall, auraWall, players, player)
	objectList = objects
	-- Check which pane
	if mapData.pane == "M" then
		-- Wisps
		wisp[1].x, wisp[1].y = generate.tilesToPixels(17, 2)
		wisp[2].x, wisp[2].y = generate.tilesToPixels(21, 3)
		wisp[3].x, wisp[3].y = generate.tilesToPixels(25, 2)
		wisp[4].x, wisp[4].y = generate.tilesToPixels(29, 3)
		wisp[5].x, wisp[5].y = generate.tilesToPixels(11, 21)
		wisp[6].x, wisp[6].y = generate.tilesToPixels(15, 22)
		wisp[7].x, wisp[7].y = generate.tilesToPixels(19, 21)
		wisp[8].x, wisp[8].y = generate.tilesToPixels(23, 22)

		-- set shadow angle for the pane
		shadows.x = 1
		shadows.y = 18

		generate.gWisps(wisp, map, mapData, 1, 8, fifteen.wispCount)
		generate.gWater(map, mapData)
	elseif mapData.pane == "R" then
		-- Breakable rune
		rune[4].x, rune[4].y = generate.tilesToPixels(4, 21)			
		rune[4].isVisible = true

		-- Exit Portal
		-- Exit portal
		objects["exitPortal1"]:setSequence("still")
		objects["exitPortal1"].x, objects["exitPortal1"].y = generate.tilesToPixels(21, 11)

		-- set shadow angle for the pane
		shadows.x = 1
		shadows.y = 18

		generate.gWater(map, mapData)
		generate.gBreakWalls(map, mapData, "breakWall")	
		--generate.gWisps(wisp, map, mapData, 24, 39, fifteen.wispCount)
	elseif mapData.pane == "L" then
		-- Breakable rune
		rune[2].x, rune[2].y = generate.tilesToPixels(35, 2)			
		rune[2].isVisible = true

		-- Icebergs
		objects["fixedIceberg1"].x, objects["fixedIceberg1"].y = generate.tilesToPixels(30, 2)
		objects["fixedIceberg1"].time = 3800 --not needed if free
		objects["fixedIceberg1"].movement = "free" --fixed or free

		objects["fixedIceberg2"].x, objects["fixedIceberg2"].y = generate.tilesToPixels(37, 8)
		objects["fixedIceberg2"].time = 3800 --not needed if free
		objects["fixedIceberg2"].movement = "free" --fixed or free

		-- set shadow angle for the pane
		shadows.x = 1
		shadows.y = 18

		generate.gWater(map, mapData)
	elseif mapData.pane == "U" then
		-- Wisps
		wisp[9].x, wisp[9].y = generate.tilesToPixels(8, 12)
		wisp[10].x, wisp[10].y = generate.tilesToPixels(18, 22)
		wisp[11].x, wisp[11].y = generate.tilesToPixels(20, 20)
		wisp[12].x, wisp[12].y = generate.tilesToPixels(24, 20)
		wisp[13].x, wisp[13].y = generate.tilesToPixels(28, 21)
		wisp[14].x, wisp[14].y = generate.tilesToPixels(6, 9)
		wisp[15].x, wisp[15].y = generate.tilesToPixels(4, 5)
		wisp[16].x, wisp[16].y = generate.tilesToPixels(10, 14)
		wisp[17].x, wisp[17].y = generate.tilesToPixels(14, 15)
		wisp[18].x, wisp[18].y = generate.tilesToPixels(17, 15)
		wisp[19].x, wisp[19].y = generate.tilesToPixels(23, 14)
		wisp[20].x, wisp[20].y = generate.tilesToPixels(32, 12)
		wisp[21].x, wisp[21].y = generate.tilesToPixels(31, 4)

		-- Fish
		objects["fish11"].x, objects["fish11"].y = generate.tilesToPixels(25, 10)
 		objects["fish11"].eX, objects["fish11"].eY = generate.tilesToPixels(29, 16)
 		objects["fish11"].time = 1375

		-- Slow time rune
		rune[3].x, rune[3].y = generate.tilesToPixels(12, 22)			
		rune[3].isVisible = true

		-- Auras 
		objects["greenAura1"]:setSequence("move")
		objects["greenAura1"]:play()
		objects["greenAura1"].x, objects["greenAura1"].y = generate.tilesToPixels(14, 3)

		-- Auras 
		objects["greenAura2"]:setSequence("move")
		objects["greenAura2"]:play()
		objects["greenAura2"].x, objects["greenAura2"].y = generate.tilesToPixels(24, 3)

		-- Shrink rune
		--rune[4].x, rune[4].y = generate.tilesToPixels(33, 9)			
		--rune[4].isVisible = true

		-- Shrink rune
		rune[4].x, rune[4].y = generate.tilesToPixels(35, 22)			
		rune[4].isVisible = true

		-- set shadow angle for the pane
		shadows.x = 1
		shadows.y = 18

		generate.gWisps(wisp, map, mapData, 9, 21, fifteen.wispCount)
		generate.gAuraWalls(map, mapData, "greenWall")
		generate.gWater(map, mapData)
	elseif mapData.pane == "D" then
		-- Wisps
		wisp[22].x, wisp[22].y = generate.tilesToPixels(7, 6)
		wisp[23].x, wisp[23].y = generate.tilesToPixels(9, 11)
		wisp[24].x, wisp[24].y = generate.tilesToPixels(10, 13)
		wisp[25].x, wisp[25].y = generate.tilesToPixels(11, 17)
		wisp[26].x, wisp[26].y = generate.tilesToPixels(5, 14)
		wisp[27].x, wisp[27].y = generate.tilesToPixels(18, 14)
		wisp[28].x, wisp[28].y = generate.tilesToPixels(21, 14)
		wisp[29].x, wisp[29].y = generate.tilesToPixels(23, 14)
		wisp[30].x, wisp[30].y = generate.tilesToPixels(28, 14)
		wisp[31].x, wisp[31].y = generate.tilesToPixels(29, 5)
		wisp[32].x, wisp[32].y = generate.tilesToPixels(23, 19)
		wisp[33].x, wisp[33].y = generate.tilesToPixels(37, 6)
		wisp[34].x, wisp[34].y = generate.tilesToPixels(36, 10)
		wisp[35].x, wisp[35].y = generate.tilesToPixels(35, 13)
		wisp[36].x, wisp[36].y = generate.tilesToPixels(35, 16)
		wisp[37].x, wisp[37].y = generate.tilesToPixels(35, 21)
		wisp[38].x, wisp[38].y = generate.tilesToPixels(21, 2)

		-- Shrink rune
		rune[4].x, rune[4].y = generate.tilesToPixels(7, 6)			
		rune[4].isVisible = true

		-- set shadow angle for the pane
		shadows.x = 1
		shadows.y = 18
		generate.gWater(map, mapData)
		generate.gWisps(wisp, map, mapData, 22, 38, fifteen.wispCount)
	end

	-- generates all objects in pane when locations are set
	generate.gObjects(fifteen, objects, map, mapData, rune, player)
	-- generate all moveable objects in pane when locations are set
	mObjects = generate.gMObjects(fifteen, objects, map, mapData)
	-- destroy the unused objects
	generate.destroyObjects(fifteen, rune, wisp, water, wall, objects)

	-- set which panes are avaiable for player
	map.front.panes = fifteen.panes
	map.front.itemGoal = 5

end

--------------------------------------------------------------------------------
-- destroy ALL objects function
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
-- destroys all objects in pane
-- called when switching panes to reset memory usage
local function destroyAll() 

	-- destroy all wisps
	for i=1, #wisp do
		display.remove(wisp[i])
		wisp[i] = nil
	end
	
	for i=1, #water do
		display.remove(water[i])
		water[i] = nil
	end
	
	for i=1, #wall do
		display.remove(wall[i])
		wall[i] = nil
	end

	-- destroy all moveable objects and stop moving them
	for i=1, #mObjects do
		if mObjects[i].moveable == true then
			mObjects[i]:endTransition()
			mObjects[i].object.stop = true
		else
			mObjects[i].count = 0
		end
	end
end

--------------------------------------------------------------------------------
-- Finish Up
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
fifteen.load = load
fifteen.destroyAll = destroyAll

return fifteen
-- end of fifteen.lua