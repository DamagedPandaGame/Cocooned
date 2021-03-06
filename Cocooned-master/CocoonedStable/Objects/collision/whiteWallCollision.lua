--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- whiteWallCollision.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local sound = require("sound")

--------------------------------------------------------------------------------
-- Collide Function - function for white wall collision
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local function collide(collideObject, player, event, mapData, map, gui)
	if player.color == 'white' then
		-- play sound
	    sound.playSound(sound.soundEffects[6])
		event.contact.isEnabled = false
	end
end

--------------------------------------------------------------------------------
-- Finish Up
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local whiteWallCollision = {
	collide = collide
}

return whiteWallCollision

-- end of whiteWallCollision.lua