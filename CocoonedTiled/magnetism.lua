--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- magnetism.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- magnetism call
local function onMagnetism( event)
	-- send both ball position values to distance function
	distance(imageObject.x, collideObject.x, imageObject.y, collideObject.y)

	if distanceFrom(imageObject, collideObject) < 150 then
		imageObject:applyLinearImpulse(.5, .5, imageObject.x)
	end
end

local magnetism = {
	onMagnetism = onMagnetism
}

return magnetism