require("levelFinished")


function collide(collideObject, player, event, mapData, map)
	event.contact.isEnabled = false
	player:addInventory(collideObject)
 	collideObject:removeSelf()

 	checkWin(player, map)

 	if map.tutorial == true then
 		require("tutorial")
 		printTutorial()
 	end
end

function removeObject(map, index, player)

end

local runeCollision = {
	collide = collide
}

return runeCollision