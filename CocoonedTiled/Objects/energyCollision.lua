
function collide(collideObject, player, event, mapData, map)
	audio.play(orbPickupSound)
	event.contact.isEnabled = false
	player:addInventory(collideObject)
 	collideObject:removeSelf()
 	collideObject = nil
end

function removeObject(map, index, player)

end

local runeCollision = {
	collide = collide
}

return runeCollision