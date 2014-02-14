--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- touchMechanic.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local dusk = require("Dusk.Dusk")
local gameData = require("gameData")
local miniMapMechanic = require("miniMap")
local print = print

--------------------------------------------------------------------------------
-- Variables for touch mechanics
--------------------------------------------------------------------------------

-- variable for miniMap mechanic for previous tap time
local tapTime = 0
local canSwipe = true

--------------------------------------------------------------------------------
-- touchScreen function
--------------------------------------------------------------------------------
function swipeScreen(event, mapData, player, miniMap)


	-- phase name
	local phase = event.phase
	local tempPane = mapData.pane

--------------------------------------------------------------------------------
-- swipe mechanic
--------------------------------------------------------------------------------



	--get swipe length for x and y
	local swipeLength = math.abs(event.x - event.xStart)
	local swipeLengthY = math.abs(event.y - event.yStart)

	-- move miniMap to show feedback of panes moving
	local swipeX = event.x - event.xStart
	local swipeY = event.y - event.yStart
	-- function call to move miniMap

	--miniMapMechanic.updateMiniMap(mapData, miniMap, swipeX, swipeY)

	local swipeDirection

	-- Load Ball shrinking animation
	--[[
	local switchPanesSheet = graphics.newImageSheet( "mapdata/graphics/switchPanesSheet.png", {width = 72, height = 72, sheetContentWidth = 792, sheetContentHeight = 72, numFrames = 6} )
 
	local paneSwitch = display.newSprite( switchPanesSheet, spriteOptions.paneSwitch )
	paneSwitch.x = display.contentWidth/2  --center the sprite horizontally
	paneSwitch.y = display.contentHeight/2  --center the sprite vertically
		
	paneSwitch = display.newSprite(switchPanesSheet, spriteOptions.paneSwitch)
	paneSwitch.speed = 8
	paneSwitch.isVisible = false
	paneSwitch.isBodyActive = true
    paneSwitch.collision = onLocalCollision
    paneSwitch:setSequence( "move" )
    --]]

	--miniMapMechanic.updateMiniMap(mapData, miniMap, swipeX, swipeY)


	-- if event touch is ended, check which way was swiped 
	-- change pane is possible
	if "ended" == phase or "cancelled" == phase then

		if mapData.pane == "M" then
			if event.xStart > event.x and swipeLength > swipeLengthY and swipeLength > 150 then
				--paneSwitch:play()
				mapData.pane = "L"
			elseif event.xStart < event.x and swipeLength > swipeLengthY and swipeLength > 150 then
				--paneSwitch:play()
				mapData.pane = "R"
			elseif event.yStart > event.y and swipeLength < swipeLengthY and swipeLengthY > 150 then
				--paneSwitch:play()
				mapData.pane = "D"
			elseif event.yStart < event.y and swipeLength < swipeLengthY and swipeLengthY > 150 then
				--paneSwitch:play()
				mapData.pane = "U"
			end
		elseif mapData.pane == "L" then
			if event.xStart < event.x and swipeLength > swipeLengthY and swipeLengthY < 150 then
				--paneSwitch:play()
				mapData.pane = "M"
			elseif swipeLength > 150 and swipeLengthY > 150 and swipeX > 0 then
				if event.yStart > event.y then
					--paneSwitch:play()
					mapData.pane = "D"
				elseif event.yStart < event.y then
					--paneSwitch:play()
					mapData.pane = "U"
				end
			end
		elseif mapData.pane == "R" then
			if event.xStart > event.x and swipeLength > swipeLengthY and swipeLengthY < 150 then
				--paneSwitch:play()
				mapData.pane = "M"
			elseif swipeLength > 150 and swipeLengthY > 150 and swipeX < 0 then
				--paneSwitch:play()
				if event.yStart > event.y then
					--paneSwitch:play()
					mapData.pane = "D"
				elseif event.yStart < event.y then
					--paneSwitch:play()
					mapData.pane = "U"
				end
			end
		elseif mapData.pane == "U" then
			if event.yStart > event.y and swipeLength < swipeLengthY and swipeLength < 150 then
				--paneSwitch:play()
				mapData.pane = "M"
			elseif swipeLengthY > 150 and swipeLength > 150 and swipeY < 0 then
				--paneSwitch:play()
				if event.xStart < event.x then
					--paneSwitch:play()
					mapData.pane = "R"
				elseif event.xStart > event.x then
					--paneSwitch:play()
					mapData.pane = "L"
				end
			end
		elseif mapData.pane == "D" then
			if event.yStart < event.y and swipeLength < swipeLengthY and swipeLength < 150 then
				--paneSwitch:play()
				mapData.pane = "M"
			elseif swipeLengthY > 150 and swipeLength > 150 and swipeY > 0 then
				if event.xStart < event.x then
					--paneSwitch:play()
					mapData.pane = "R"
				elseif event.xStart > event.x then
					--paneSwitch:play()
					mapData.pane = "L"
				end
			end
		end
		--miniMapMechanic.resetMiniMap(miniMap, mapData, player)
		print("swipe", mapData.pane)
		
	end

	-- if switching panes, move miniMap cursor to that pane and set alpha to 0
	if tempPane ~= mapData.pane then
		--miniMapMechanic.resetMiniMap(miniMap, mapData, player)
		
		if gameData.isShowingMiniMap then
			miniMap.alpha = 0
			gameData.isShowingMiniMap = false
		end
	end

end

--------------------------------------------------------------------------------
-- tap mechanic
--------------------------------------------------------------------------------
function tapScreen(event, miniMap, physics) 
	-- if tapped twice, show miniMap or if showing, hide it
	if event.numTaps >= 2 then
		-- show miniMap 
		if gameData.isShowingMiniMap == false then
			print("show")
			physics.pause()
			gameData.isShowingMiniMap = true
			miniMap.alpha = 0.75
		else
		--hide miniMap
			print("hide")
			physics.start()
			gameData.isShowingMiniMap = false
			miniMap.alpha = 0
		end

	end
end


local touchMechanic = {
	swipeScreen = swipeScreen,
	tapScreen = tapScreen
}

return touchMechanic

--end of touch mechanic