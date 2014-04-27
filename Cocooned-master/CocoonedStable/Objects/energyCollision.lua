--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- energyCollision.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local sound = require("sound")
--------------------------------------------------------------------------------
-- Collide Function - remove wisp object if collected
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local function collide(collideObject, player, event, mapData, map, gui)
	sound.playSound(sound.soundEffects[8])
	event.contact.isEnabled = false
		
	player:addInventory(collideObject)
 	collideObject:removeSelf()
 	collideObject = nil
end

--------------------------------------------------------------------------------
-- FInish Up
--------------------------------------------------------------------------------
-- Updated by: Marco
--------------------------------------------------------------------------------
local energyCollision = {
	collide = collide
}

return energyCollision
-- end of wispCollision.lua