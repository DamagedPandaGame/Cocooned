--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- moveableObject.lua
--------------------------------------------------------------------------------
local sound = require("sound")
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local forward, back

--------------------------------------------------------------------------------
-- Moveable Objectt Instance - moveabled object table
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local moveObject = {
	object = '',
	startX = 0,
	startY = 0,
	endX = 0,
	endY = 0,
	time = 0,
	stop = false,
	name = '',
	listener = ''
}



--------------------------------------------------------------------------------
-- Move forward - function that transitions object to end point
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function moveforward(obj)
	--print("moveF:")
	if obj.stop ~= true then
		obj.isVisible = true
		--if string.find(obj.name, "fish") then
			--forward = transition.to(obj, {time = obj.time, x = obj.endX, y = obj.endY, onComplete = function() moveBackward end})
		--else
		forward = transition.to(obj, {time = obj.time, x = obj.endX, y = obj.endY, onComplete = function() splash(obj, "backward") end})
		--end
		if obj.name ~= "iceberg" then
			sound.stopChannel(1)
			sound.playSound(sound.soundEffects[13])
			obj:rotate(180)
		end
	end
end


function splash(obj, direction) 
	local fishSheet = graphics.newImageSheet("mapdata/art/animation/splashSheet.png", {width = 400, height = 329, sheetContentWidth = 6000, sheetContentHeight = 329, numFrames = 15})
	local tempSplash=display.newSprite(fishSheet, 
		{frames = {1,2,3,4,5}, name = "move", time = 250, start=1, count=15, loopCount=1}
		)
	obj.map.front:insert(tempSplash)
	tempSplash:play()
	tempSplash:scale(.4, .4)
	tempSplash.x = obj.x
	tempSplash.y = obj.y
	obj.isVisible = false

	if direction == "backward" then
		local timerback = timer.performWithDelay(250, function() tempSplash:removeSelf(); tempSplash = nil; moveBackward(obj); end)
	else
		local timerforward = timer.performWithDelay(250, function() tempSplash:removeSelf(); tempSplash = nil; moveforward(obj); end)
	end
end


--------------------------------------------------------------------------------
-- Move Backward - function that transitions object to start point
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function moveBackward(obj)
	--print("moveB:")

	if obj.stop ~= true then
		--if string.find(obj.name, "fish") then
		--	back = transition.to(obj, {time = obj.time, x = obj.startX, y = obj.startY, onComplete =  function() hasMoved = true; obj:setSequence("jumpingin"); obj.sequence="jumpingin"; obj:play() end})
		--else
		obj.isVisible = true
		back = transition.to(obj, {time = obj.time, x = obj.startX, y = obj.startY, onComplete = function() splash(obj, "forward") end})
		--end
		if obj.name ~= "iceberg" then
			sound.stopChannel(1)
			sound.playSound(sound.soundEffects[13])
			obj:rotate(180)
		end
	end
	--obj:rotate(180)
end

--------------------------------------------------------------------------------
-- Create Moveable Object
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
--call this to create a new moveable object, but make sure to change parameters
local function create(o)
	o = o or {}
	return moveObject:new(o)
end

--------------------------------------------------------------------------------
-- New - function that creates a new moveable object table
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function moveObject:new(o)
	setmetatable(o, self)
	self.__index = self
	return o
end

--------------------------------------------------------------------------------
-- New - function that creates a new iventory table
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function moveObject:endTransition()
	--print("ended transition", self.object.name)
	transition.cancel(forward)
	transition.cancel(back)
	self.object:removeSelf()
	self.obj = nil
end

--------------------------------------------------------------------------------
-- Start Transition - function that starts movement of object
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function moveObject:startTransition(obj)
	moveforward(obj)
end


--------------------------------------------------------------------------------
-- Finish Up
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local moveableObject = {
	create = create
}

return moveableObject

-- end of moveableOject.lua