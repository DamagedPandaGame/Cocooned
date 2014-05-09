--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- timer.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local gameData = require("Core.gameData")
local levelNames = require("utils.levelNames")
local animation = require("Core.animation")
--------------------------------------------------------------------------------
-- Variables - variables for loading panes
--------------------------------------------------------------------------------
local gameTimer = {}

local overlay
local theTimer
local clockFormat
local counter = 0

--------------------------------------------------------------------------------
-- End Game Timer Listener
--------------------------------------------------------------------------------
local function endCountFunc(event)
	local params = event.source.params
	local textTrans	
	local wolfTrans
	
	-- Subtract 1 sec every time the listener is called
	counter = counter - 1
	-- While counter is greater than 0
	if counter > 1 then
		physics.pause()
		wolfTrans = transition.to(params.wolfParam, {time=100, x=params.wolfParam.x-50})
		textTrans = transition.to(params.counterParam, {time=2500, x=display.contentCenterX-350})
	elseif counter == 0 then
		transition.cancel(wolfTrans)
		-- Clean up wolf
		params.wolfParam.alpha = 0
		params.wolfParam:removeSelf()
		params.wolfParam = nil
	elseif counter == -10 then
		-- Remove timer text
		if params.counterParam then
			params.counterParam:removeSelf()
		end
		-- Clean up timer
		timer.cancel(theTimer)
		theTimer = nil
		overlay.alpha = 0
		overlay:removeSelf()
		overlay = nil
		-- Start physics
		physics.start()
		-- Send boolean to gameLoop
		gameData.levelRestart = true
	end
	print(counter)
end

--------------------------------------------------------------------------------
-- End Game Counter Function
--------------------------------------------------------------------------------
local function endGame(gui)
	-- Create local wolfAnimation sprite
	local wolfAnim = display.newSprite(animation.sheetOptions.wolfSheet, animation.spriteOptions.wolf)	
		  -- Start wolf off-screen
		  wolfAnim.x = display.contentCenterX + 600
		  wolfAnim.y = display.contentCenterY
		  -- Enlarge the size of the wolf
		  wolfAnim:scale(3, 3)
		  wolfAnim:setSequence("move")
		  wolfAnim:play()

	-- Create overlay object
	overlay = display.newRect(display.contentCenterX, display.contentCenterY, 1460, 860)
	overlay:setFillColor(0,0,0)
	
	-- Set counter value
	counter = 30
	
	-- Create text object
	local counterText = display.newText("Time's Up!", 0, 0, native.systemFontBold, 150)
	-- Center text object
	counterText.x = wolfAnim.x + 600
	counterText.y = wolfAnim.y
	-- Set color to black
	counterText:setFillColor(1, 1, 1)	
	-- Global class timer; pass in paramters: gui, counterText, mapData
	theTimer = timer.performWithDelay(100, endCountFunc, counter+10)
	theTimer.params = {guiParam = gui, counterParam = counterText, wolfParam = wolfAnim}	
	-- Insert text object to gui.front layer to allow easy erase
	gui.middle.alpha = 0.5
	gui.back.alpha = 1
	overlay.alpha = 0.8
	gui.front:insert(overlay)
	gui.front:insert(wolfAnim)
	gui.front:insert(counterText)
end

local i = 0
--------------------------------------------------------------------------------
-- Game Counter Listener [for in-game purposes]
--------------------------------------------------------------------------------
local function gameCountFunct(event)
	i = i+1
	print("call game timer: ", i)
	-- Load in passed parameters from inGame()
	local params = event.source.params
	-- Localize event paramater
	local textObj = params.counterParam
	-- While gameTimer is greater than 0
	if gameData.gameTime > 0 then
		if gameData.gameTime < 10 then
			textObj:setFillColor(1,0,0)
		end
		-- Subtract one second from global gameTimer
		gameData.gameTime = gameData.gameTime - 1
		-- Format gameTimer to time-stamp	
		clockFormat = os.date("!%M:%S", gameData.gameTime)
		textObj.text = clockFormat
	elseif gameData.gameTime == 0 then
		-- clean everything
		textObj:removeSelf()
		timer.cancel(theTimer)
		theTimer = nil
		-- run end game timer/transition
		endGame(params.guiParam)
	end
end

--------------------------------------------------------------------------------
-- In-Game Timer Function
--------------------------------------------------------------------------------
local function inGame(gui, mapData)
	-- load in level file according to mapData.levelNumber
	local level = require("levels." .. levelNames[mapData.levelNum])
	-- Make global gameTimer = level default timer
	gameData.defaultTime = level.timer
	gameData.gameTime = gameData.defaultTime
	print("gameData.defaultTime", gameData.defaultTime)
	-- Create local wispCounter = level wisp amount
	local wispCounter = level.wispCount
	-- Format gameTimer to time-stamp
	clockFormat = os.date("!%M:%S", gameData.gameTime)
	-- Create counter text object for game timer
	local counterText = display.newText(clockFormat, 0, 0, native.systemFontBold, 100)
	counterText.x = display.contentCenterX
	counterText.y = 50
	counterText:setFillColor(0, 0, 0)
	counterText.name = "timer"
	-- Initialize & run timer
	theTimer = timer.performWithDelay(1000, gameCountFunct, gameData.gameTime*wispCounter)
	theTimer.params = {guiParam = gui, counterParam = counterText}
	-- Insert text object to gui.front
	gui.front:insert(counterText)
end

--------------------------------------------------------------------------------
-- Pre-Game Timer Counter Listener
--------------------------------------------------------------------------------
local function counterFunc(event)
	local params = event.source.params
	-- Subtract 1 sec every time the listener is called
	counter = counter - 1
	-- While counter is greater than 0
	if counter > 0 then
		params.counterParam.text = counter
		-- Slowly fade in overlay image
		overlay.alpha = overlay.alpha - 0.05
	elseif counter == 0 then
		-- Change 0 to "START"
		params.counterParam.text = "START!"
		params.guiParam.middle.alpha = 1
		params.guiParam.back.alpha = 1
		overlay.alpha = overlay.alpha - 0.05
	elseif counter == -1 then
		-- Remove timer text
		if params.counterParam then
			params.counterParam:removeSelf()
		end		
		-- Revert background alphas
		overlay.alpha = 0
		overlay:removeSelf()
		overlay = nil
		-- Start physics/Add listeners in gameLoop
		physics.start()		
		gameData.preGame = false
		-- Clean up timer
		timer.cancel(theTimer)
		theTimer = nil
		-- Call in game timer
		inGame(params.guiParam, params.mapDataParam)
	end
	--print(counter)
end

--------------------------------------------------------------------------------
-- Pre-game timer function 
--------------------------------------------------------------------------------
local function preGame(gui, mapData)
	-- counter = desired time + 2 sec (from loading).
	counter = 4
	-- Create text object
	local counterText = display.newText(counter, 0, 0, native.systemFontBold, 150)
	-- Center text object
	counterText.x = display.contentCenterX
	counterText.y = display.contentCenterY
	-- Create overlay object
	overlay = display.newRect(display.contentCenterX, display.contentCenterY, 1460, 860)
	overlay:setFillColor(1,1,1)
	-- Set color to black
	counterText:setFillColor(0, 0, 0)	
	-- Global class timer; pass in paramters: gui, counterText, mapData
	theTimer = timer.performWithDelay(1000, counterFunc, counter+1)
	theTimer.params = {guiParam = gui, counterParam = counterText, mapDataParam = mapData}	
	-- Insert text object to gui.front layer to allow easy erase
	overlay.alpha = 0.8
	gui.front:insert(overlay)
	gui.front:insert(counterText)
end

gameTimer.preGame = preGame
gameTimer.inGame = inGame

return gameTimer