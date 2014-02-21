require("levelFinished")
local gameData = require("gameData")
local sound = require("sound")

local function endAnimation( event )
 
  if ( event.phase == "ended" ) then
    local thisSprite = event.target  --"event.target" references the sprite
    thisSprite:removeSelf()  --play the new sequence; it won't play automatically!
  end
end

function collide(collideObject, player, event, mapData, map)
	audio.stop()
	sound.playSound(event, sound.runePickupSound)
	event.contact.isEnabled = false
	player:addInventory(collideObject)
	local runeCollide = display.newSprite(sheetOptions.runeSheet, spriteOptions.runeAnimation)
	runeCollide.x, runeCollide.y = collideObject.x - 45, collideObject.y
	runeCollide:setSequence("move")
	runeCollide:play()

	if collideObject.name == "blueRune" then
		gameData.blueG = true
		player:breakWalls(map)
	elseif collideObject.name == "pinkRune" then
		player:slowTime(map)		
	elseif collideObject.name == "greenRune" then
		gameData.greenG = true
	elseif collideObject.name == "yellowRune" then
		player:shrink()
	end
	
 	collideObject:removeSelf()

 	--runeCollide:addEventListener( "sprite", endAnimation )

 	checkWin(player, map, mapData)

end



function removeObject(map, index, player)

end

local runeCollision = {
	collide = collide
}

return runeCollision