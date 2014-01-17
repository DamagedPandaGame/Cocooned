--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- gameLoop.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Localize
--------------------------------------------------------------------------------
local require = require

local physics = require("physics")
physics.start()
physics.setGravity(0, 10)
--physics.setDrawMode("hybrid")

local math_abs = math.abs

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

-- Local Variables

-- Global Variables
global = {
	gameActive = false,
	gui,
	map,
}

-- ball variables and add ball image
local ball = display.newImage("mapdata/graphics/ball 1.png")

-- level variable
local mapData = {
	levelNum = 1,
	pane = "M",
}

--------------------------------------------------------------------------------
-- add in main menu
--------------------------------------------------------------------------------

local main = require("menu")

--------------------------------------------------------------------------------
-- add in mechanics
--------------------------------------------------------------------------------

local switchPaneMechanic = require("switchPane")
local movementMechanic = require("accelerometer")

local json = require("json")

local player = require("player")
local player1 = player.create()
local player2 = player.create()
player1:changeColor('green')
player2.name = "test"

print("player name = ", player1.name)
print("player color = ", player1.color)


--------------------------------------------------------------------------------
-- Creating display group
--------------------------------------------------------------------------------
gui = display.newGroup()
gui.front = display.newGroup()
gui.back = display.newGroup()

gui:insert(gui.back)
gui:insert(gui.front)

--------------------------------------------------------------------------------
-- Load Map
--------------------------------------------------------------------------------
local dusk = require("Dusk.Dusk")

map = dusk.buildMap("mapdata/levels/temp/M.json")
gui.back:insert(map)

map.layer["tiles"]:insert(ball)

print(map.layer["objects"])

ball.x, ball.y = map.tilesToPixels(map.playerLocation.x + 0.5, map.playerLocation.y + 0.5)

--------------------------------------------------------------------------------
-- Game Functions:
------- controlMovement
------- swipeMechanics
--------------------------------------------------------------------------------

-- control mechanic
controlMovement = function (event) 

	-- call accelerometer to get data
	physicsParam = movementMechanic.onAccelerate(event)
	--print(physicsParam.xGrav)

	--change physics gravity
	physics.setGravity(physicsParam.xGrav, physicsParam.yGrav)
end

-- swipe mechanic
swipeMechanics = function (event)
	-- call swipe mechanic
	local newPane = switchPaneMechanic.switchP(event, mapData)
	
	-- if touch ended then change map if pane is switched
	if "ended" == event.phase then
		mapData.pane = newPane
		map = dusk.buildMap("mapdata/levels/temp/" .. mapData.pane .. ".json")
		map.layer["tiles"]:insert(ball)
	end
end

--------------------------------------------------------------------------------
-- gameloop
--------------------------------------------------------------------------------
if gameActive == nil then
	gameActive = false
	-- game is NOT active go to menu.
	main.MM(event)
end

local function gameLoop (event)
	if gameActive then
		physics.start()
		physics.addBody(ball, {radius = 38, bounce = .25})
		map.updateView()
	end
end

--------------------------------------------------------------------------------
-- Finish Up - Call gameLoop every 30 fps
--------------------------------------------------------------------------------

Runtime:addEventListener("enterFrame", gameLoop)

--------------------------------------------------------------------------------
-- Memory Check (http://coronalabs.com/blog/2011/08/15/corona-sdk-memory-leak-prevention-101/)
--------------------------------------------------------------------------------
local prevTextMem = 0
local prevMemCount = 0
local monitorMem = function()
collectgarbage()
local memCount = collectgarbage("count")
	if (prevMemCount ~= memCount) then
		print( "MemUsage: " .. memCount)
		prevMemCount = memCount
	end
	local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
	if (prevTextMem ~= textMem) then
		prevTextMem = textMem
		print( "TexMem: " .. textMem )
	end
end

Runtime:addEventListener( "enterFrame", monitorMem )
--------------------------------------------------------------------------------
-- END MEMORY CHECKER
--------------------------------------------------------------------------------

return global
