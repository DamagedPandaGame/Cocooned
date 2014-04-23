--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- moveableObject.lua
--------------------------------------------------------------------------------
-- lua file that creates moveable objects for pane
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
	stop = false
}

--------------------------------------------------------------------------------
-- Move forward - function that transitions object to end point
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local function moveforward(obj)
	
	--print("moveF:", obj.name)
	if obj.stop ~= true then
		forward = transition.to(obj, {time = obj.time, x = obj.endX, y = obj.endY, onComplete = moveBackward})
		obj:rotate(180)
	end
	--
end

--------------------------------------------------------------------------------
-- Move Backward - function that transitions object to start point
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function moveBackward(obj)

	--print("moveB:", obj.name)
	if obj.stop ~= true then
		back = transition.to(obj, {time = obj.time, x = obj.startX, y = obj.startY, onComplete = moveforward})
		obj:rotate(180)
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