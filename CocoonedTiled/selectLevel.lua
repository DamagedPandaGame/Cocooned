--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- selectLvl.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Load in files
--------------------------------------------------------------------------------
local math_abs = math.abs
local physics = require("physics") 
local animation = require("animation")
local dusk = require("Dusk.Dusk")
local gameData = require("gameData")

local selectLevel = {
	levelNum = 0,
	pane = "M",
	version = 0,
}

-- Local Variables
local levelGUI
local dPad
local map, bg
local player
local silKipcha
local playerSheet
local cameraTRK

local kCircle = {} -- Color Circle Array
local levels = {}  -- Level Indicator Array
local lockedLevels = {}

-- Local Booleans
local trackPlayer = true
local trackInvisibleBoat = false
local allowPlay = true


local function stopAnimation(event)
	print("4")
	player:setSequence("still")
	player:play()
	allowPlay = true
end

-- Quick function to make all buttons uniform
local function newButton(parent) 
	print("3")
	local butt = display.newRoundedRect(parent, 0, 0, 40, 40, 5) 
	      butt:setFillColor(105*0.00392156862, 210*0.00392156862, 231*0.00392156862) 
		  butt:setStrokeColor(1, 1, 1)
		  butt.strokeWidth = 3
		  butt:scale(0.8, 0.8)
   return butt 
end

-- Point in rect, using Corona objects rather than a list of coordinates
local function pointInRect(point, rect) 
	print("2")
	return (point.x <= rect.contentBounds.xMax) and 
		   (point.x >= rect.contentBounds.xMin) and 
		   (point.y <= rect.contentBounds.yMax) and 
		   (point.y >= rect.contentBounds.yMin) 
end

local function setCameratoPlayer(event)
	map.updateView()
	if trackPlayer then
		trackInvisibleBoat = false
		-- Set up map camera
		map.setCameraFocus(player)
		map.setTrackingLevel(0.1)

		movex = cameraTRK.x - player.x
		movey = cameraTRK.y - player.y

		--bg.x = bg.x + movex
		--bg.y = bg.y + movey
		
		cameraTRK.x = player.x
		cameraTRK.y = player.y
	elseif trackInvisibleBoat then
		trackPlayer = false
		map.setCameraFocus(cameraTRK)
		map.setTrackingLevel(0.1)
	end
	--[[
	local vx, vy = cameraTRK:getLinearVelocity()

	--movement of bg
	if vx < 0 then	bg.x = bg.x + 8.25
	elseif vx > 0 then bg.x = bg.x - 8.25
	elseif vy < 0 then bg.y = bg.y + 8.25
	elseif vy > 0 then bg.y = bg.y - 8.25
	end
	]]
end

-- Select Level Loop
local function selectLoop(event)
	print("hello")

	-- Start physics
	physics.start()
	physics.setGravity(0, 0)
	--------------------------------------------------------------------------------
	-- Initialize local variables
	--------------------------------------------------------------------------------
	levelGUI = display.newGroup()
	levelGUI.front = display.newGroup()
	levelGUI.back = display.newGroup()
	dPad = display.newGroup()
	
	-- Create Arrays
	kCircle = {} -- Color Circle Array
	levels = {}  -- Level Indicator Array
	lockedLevels = {} -- Locked Levels Array
		
	-- Load Map
	map = dusk.buildMap("mapdata/levels/LS/levelSelect.json")
	map:scale(0.5, 0.5)

	bg = display.newImage("mapdata/art/bg.png", 0, 0, true)
	bg.x = 280
	bg.y = 150
	bg:scale(0.4, 0.4)
	--
	-- Load image sheet
	playerSheet = graphics.newImageSheet("mapdata/graphics/AnimationRollSprite.png", 
				   {width = 72, height = 72, sheetContentWidth = 648, sheetContentHeight = 72, numFrames = 9})
						   
	-- Create player
	player = display.newSprite(playerSheet, spriteOptions.player)
	player.speed = 250
	player.title = "player"
	player:scale(0.8, 0.8)

	-- Create play button
	silKipcha = display.newImage("graphics/sil_kipcha.png", 0, 0, true)
	silKipcha.x = 490
	silKipcha.y = 260
	silKipcha:scale(0.8, 0.8)
	silKipcha.name = "sillykipchatrixareforkids"

	-- Create invisible camera tracker
	cameraTRK = display.newImage("mapdata/art/invisibleBoat.png", 0, 0, true)
	cameraTRK.speed = 500
	
	-- Create dPad
	dPad.result = "n"
	dPad.prevResult = "n"
	
	-- Create dPad buttons and position them
	dPad.l = newButton(dPad); dPad.l.x, dPad.l.y = -32, 0 
	dPad.r = newButton(dPad); dPad.r.x, dPad.r.y = 32, 0
	dPad.u = newButton(dPad); dPad.u.x, dPad.u.y = 0, -32
	dPad.d = newButton(dPad); dPad.d.x, dPad.d.y = 0, 32
	
	-- Assign names to dPad
	dPad.l.name = "l"
	dPad.r.name = "r"
	dPad.u.name = "u"
	dPad.d.name = "d"
	
	-- Position dPad buttons
	dPad.x = display.screenOriginX + dPad.contentWidth * 0.5 + 10
	dPad.y = display.contentHeight - dPad.contentHeight * 0.5 - 10
		
	-- Create level numbers
	lvlNumber = {	
		[1] = "T", [2] = "1", [3] = "2",
		[4] = "3", [5] = "4", [6] = "5",
		[7] = "6", [8] = "7", [9] = "8",
		--[10] = "9", [11] = "10", [12] = "11",
		--[13] = "12", [14] = "13", [15] = "14",
		--[16] = "15", [17] = "F"
	}
	
	-- Level numbers' position
	textPos = {
		--      X (T=150),       Y,(T = 105)
		[1] = 70,   [2] = 115,  -- T
		[3] = 340,  [4] = 115,  -- 1
		[5] = 610,  [6] = 115,  -- 2
		[7] = 880,  [8] = 115,  -- 3
		[9] = 1145, [10] = 115, -- 4
		[11] = 340, [12] = 330, -- 5
		[13] = 610, [14] = 330, -- 6
		[15] = 880, [16] = 330, -- 7
		[17] = 1145, [18] = 330, -- 8
		[19] = 340, [20] = 545,  -- 9
		[21] = 610, [22] = 545, -- 10
		[23] = 880, [24] = 545,  -- 11
		[25] = 1145, [26] = 545,  -- 12
		[27] = 340, [28] = 760,  -- 13
		[29] = 610, [30] = 760,  -- 14
		[31] = 880, [32] = 760,  -- 15
		[33] = 1145, [34] = 760,  -- 16
	}
		
	for i=1, #lvlNumber do
		-- Make & assign attributes to the 10 circles (kCircle[array])
		kCircle[i] = display.newCircle(textPos[2*i-1] + 500, textPos[2*i], 35)
		kCircle[i].name = lvlNumber[i]
		kCircle[i]:setFillColor(105*0.00392156862, 210*0.00392156862, 231*0.00392156862)
		kCircle[i]:setStrokeColor(1, 1, 1)
		kCircle[i].strokeWidth = 5

		-- Along with its text indicator (levels[array])
		levels[i] = display.newText(lvlNumber[i], textPos[2*i-1]+ 500, textPos[2*i], native.Systemfont, 35)
		levels[i]:setFillColor(0, 0, 0)
		map.layer["tiles"]:insert(kCircle[i])
		map.layer["tiles"]:insert(levels[i])
		
		-- Unlock && lock levels
		if i~=1 and i~=2 and i~=3 and 
		   i~=4 and i~=5 and i~=6 and 
		   i~=8 and i~=16 then
		   
			lockedLevels[i] = display.newImage("graphics/lock.png")
			lockedLevels[i].x = kCircle[i].x
			lockedLevels[i].y = kCircle[i].y
			lockedLevels[i]:scale(0.2, 0.2)
			map.layer["tiles"]:insert(lockedLevels[i])
			kCircle[i].isAwake = false
		else
			kCircle[i].isAwake = true
		end
	end
	
	-- Add physics
	physics.addBody(player, "static", {radius = 0.1}) -- to player
	print("Added cameraTRK to physics")
	physics.addBody(cameraTRK, "dynamic", {radius = 0.1}) -- to invisible camera
	
	-- Turn off collision for invisible camera
	cameraTRK.isSensor = true
	cameraTRK.isAwake = true
	
	-- Set player start position
	player.x = textPos[1] + 500
	player.y = textPos[1] + 255
	
	-- Insert objects/groups to their proper display group
	levelGUI:insert(levelGUI.back)
	levelGUI:insert(levelGUI.front)
	levelGUI.back:insert(map)
	levelGUI.back:insert(bg)
	levelGUI.front:insert(silKipcha)
	levelGUI.front:insert(dPad)

	bg:toBack()
	
	selectLevel.levelNum = kCircle[1].name
	kCircle[1].isAwake = true
	kCircle[1]:setFillColor(167*0.00392156862, 219*0.00392156862, 216*0.00392156862)
	
	-- Insert objects into map layer "tiles"
	map.layer["tiles"]:insert(player)
	map.layer["tiles"]:insert(cameraTRK)
	
	for i=1, #kCircle do
		kCircle[i]:addEventListener("tap", tapOnce)
	end
	
	silKipcha:addEventListener("tap", tapOnce)
	dPad:addEventListener("touch", tapOnce)
	Runtime:addEventListener("enterFrame", setCameratoPlayer)
end
	

-- When player tap's levels once:
function tapOnce(event)
	print("5")

	-- kCircles button detection
	for i=1, #kCircle do
		if event.target.name == kCircle[i].name then
			trackPlayer = true
			if event.numTaps == 1 and kCircle[i].isAwake then
			
				selectLevel.levelNum = kCircle[i].name
				allowPlay = false
				-- Move kipcha to the selected circle
				transition.to(player, {time = 1000, x = kCircle[i].x, y = kCircle[i].y, onComplete=stopAnimation})
				player.rotation = 90
				player:setSequence("move")
				player:play()
			
				kCircle[i]:setFillColor(167*0.00392156862, 219*0.00392156862, 216*0.00392156862)
					
				-- Send signal to refresh sent mapData
				gameData.inLevelSelector = true
			end
		else
			for j=1, #kCircle do
				if kCircle[j].name ~= event.target.name then
					kCircle[j]:setFillColor(105*0.00392156862, 210*0.00392156862, 231*0.00392156862)
				end
			end
		end
	end
	
	-- dPad Button detection
	if event.target.name == dPad.l.name or dPad.r.name or dPad.u.name or dPad.d.name then
		if event.target.isFocus or "began" == event.phase then
			dPad.prevResult = dPad.result
			-- Set result according to where touch is
					if pointInRect(event, dPad.l) then dPad.result = "l"
				elseif pointInRect(event, dPad.r) then dPad.result = "r"
				elseif pointInRect(event, dPad.u) then dPad.result = "u"
				elseif pointInRect(event, dPad.d) then dPad.result = "d"
			end
		end

		-- Just a generic touch listener
		if "began" == event.phase then	
			display.getCurrentStage():setFocus(event.target)
			event.target.isFocus = true
			trackPlayer = false
			trackInvisibleBoat = true	
		elseif event.target.isFocus then
			if "ended" == event.phase or "cancelled" == event.phase then
				display.getCurrentStage():setFocus(nil)
				event.target.isFocus = false
				dPad.result = "n"
				dPad.l.alpha = 1; dPad.r.alpha = 1; 
				dPad.u.alpha = 1; dPad.d.alpha = 1
			end
		end

		-- Did the direction change?
		if dPad.prevResult ~= dPad.result then 
			dPad.changed = true 
		end
		
		-- Set player velocity according to movement result
		if dPad.result == "l" then cameraTRK:setLinearVelocity(-cameraTRK.speed, 0)
		elseif dPad.result == "r" then cameraTRK:setLinearVelocity(cameraTRK.speed, 0)
		elseif dPad.result == "u" then cameraTRK:setLinearVelocity(0, -cameraTRK.speed)
		elseif dPad.result == "d" then cameraTRK:setLinearVelocity(0, cameraTRK.speed)
		elseif dPad.result == "n" then cameraTRK:setLinearVelocity(0, 0)
		end
		
		print(cameraTRK.speed)
	end
	
	
	-- Kipcha Play button detection
	if allowPlay then
		-- If player taps silhouette kipcha, start game
		if event.target.name == silKipcha.name then

--------------------------------------------------------------------------------
-- remove all objects
--------------------------------------------------------------------------------
					
			trackPlayer = true
			trackInvisibleBoat = false

			-- remove eventListeners		
			silKipcha:removeEventListener("tap", tapOnce)
			Runtime:removeEventListener("enterFrame", setCameratoPlayer)
			dPad:removeEventListener("touch", tapOnce)
			
			--	Clean up on-screen items
			levelGUI:removeSelf()
			levelGUI = nil
			dPad:removeSelf()
			dPad = nil
			player:removeSelf()
			player = nil
			cameraTRK:removeSelf()
			cameraTRK = nil
			silKipcha:removeSelf()
			silKipcha = nil
			
			-- remove and destroy all circles
			for p=1, #kCircle do
				display.remove(kCircle[p])
				display.remove(levels[p])
				display.remove(lockedLevels[p])
				kCircle[p]:removeEventListener("tap", tapOnce)
				map.layer["tiles"]:remove(kCircle[p])
				map.layer["tiles"]:remove(levels[p])
			end
			kCircle = nil

			-- destroy map object
			map.destroy()
			map:removeSelf()
			map = nil

			physics.stop()
			
			-- Send data to start game
			gameData.gameStart = true
		end
	end
		
	return true
end


selectLevel.selectLoop = selectLoop

return selectLevel
