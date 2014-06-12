--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- redTotemCollision.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local sound = require("sound")

--------------------------------------------------------------------------------
-- Collide Function - function for red totem collision
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
function collide(collideObject, player, event, mapData, map, gui)
	--sound.playSound(event, sound.totemSound)
	if player[1].color ~= 'red' then
		player:totemRepel(collideObject)
	end
end

--------------------------------------------------------------------------------
-- Finish Up
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local redTotemCollision = {
	collide = collide
}

return redTotemCollision

-- end of redTotemCollision.lua