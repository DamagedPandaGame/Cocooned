--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- greenTotemCollision.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local sound = require("sound")

--------------------------------------------------------------------------------
-- Collide Function - function for green totem collsion
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local function collide(collideObject, player, event, mapData, map, gui)
	--sound.playSound(event, sound.totemSound)
	print("collided with greenTotem")
	if player[1].color ~= 'green' then
		player[1]:totemRepel()
	end
end

--------------------------------------------------------------------------------
-- Finish Up
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local greenTotemCollision = {
	collide = collide
}

return greenTotemCollision

-- end of greenTotemCollision.lua