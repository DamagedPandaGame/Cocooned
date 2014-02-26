--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cocooned by Damaged Panda Games (http://signup.cocoonedgame.com/)
-- player.lua
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local floor = math.floor
local atan2 = math.atan2
local pi = math.pi

local inventoryMechanic = require("inventoryMechanic")
local gameData = require("gameData")
--default player prototype
playerInstance = {
	x=0,
	y=0,
	magnetized='nuetral', -- {negative, nuetral, positive}
	color='white',
	image = 'null',
	name = 'hello',
	radius = 38, --default radius
	bounce = .25,
	imageObject = '',
	hasItem={},
	tapPosition=0,
	inventory = inventoryMechanic.createInventory(),
	xGrav = 0,
	yGrav = 0,
	speedConst = 10,
	movement="accel",
	deathTimer = nil,
	slowDownTimer = nil,
	speedUpTimer = nil,
	deathScreen = nil,
	curse = 1,
	escape = "center",
	small = false,
	breakable = false
}


local function rotateTransition(imageObject, rotationDelta, timeDelta)
        transition.to( imageObject, { rotation=rotationDelta, time=timeDelta, transition=easing.inOutCubic, tag='rotation' } )
end 

--call this to create a new player, but make sure to change parameters
function create(o)
	o = o or {} -- create object if user does not provide one
	return playerInstance:new(o)
end

function playerInstance:destroy()
	if self.deathScreen ~= nil then
		self.deathScreen:pause()
		self.deathScreen:removeSelf()
		self.deathScreen = nil
	end
	self.imageObject:removeSelf()
	self.imageObject = nil
	self.inventory:destroy()
	self.inventory = nil

end

--returns a player instance
function playerInstance:new (o) 
      	setmetatable(o, self)
    	self.__index = self
    	return o
end

--basic function that changes color
function playerInstance:changeColor (color)
		colors={['white']={1,1,1},['red']={1,0.5,0.5},['green']={0.5,1,0.5},['blue']={0.5,0.5,1}}
		--print(self.color)
    	self.color = color
    	c=colors[color]
    	self.imageObject:setFillColor(c[1],c[2],c[3])
end

-- repels the player if they hit a totem pole
function playerInstance:totemRepel (collideObject)
		print((self.imageObject.x - collideObject.x)/1000)
		self.imageObject:applyLinearImpulse((self.imageObject.x - collideObject.x)/175, (self.imageObject.y - collideObject.y)/175, self.imageObject.x, self.imageObject.y) 
		self.imageObject.angularVelocity = 0
end

-- repels the player if there is wind
function playerInstance:windRepel ()
		self.imageObject:applyLinearImpulse(2, 2, self.imageObject.x, self.imageObject.y)
		self.imageObject.angularVelocity = 0
end

-- attracts the player if they are near a totem pole
function playerInstance:attract (goTo)
		--self.imageObject:applyLinearImpulse(-1, -1, self.imageObject.x, self.imageObject.y)
		self.imageObject:setLinearVelocity(goTo, goTo, goTo, goTo)
		self.imageObject.angularVelocity = 0
end

function changeBack(player)
	physics.removeBody(player)
	player:scale(2,2)
	physics.addBody(player, {radius = 36, bounce = .25})
	physics.setGravity(0,0)
	player.linearDamping = 1.5
	player.density = .3
end

function playerInstance:unshrink()
	self.small = false
	local delayShrink = function() return changeBack( self.imageObject ) end
	timer.performWithDelay(20, delayShrink)
end

function changeSize(player)
	physics.removeBody(player)
	player:scale(0.5,0.5)
	physics.addBody(player, {radius = 10, bounce = .25, density = 0.7})
end

function playerInstance:shrink()
	self.small = true
	local delayShrink = function() return changeSize( self.imageObject ) end
	timer.performWithDelay(20, delayShrink)
end

function playerInstance:slowTime(map)
	for check = 1, map.layer["tiles"].numChildren do
		if map.layer["tiles"][check].moveable == true then
			map.layer["tiles"][check].time = 20000
		end
	end
end

function playerInstance:breakWalls(map)
	self.breakable = true
	local timer = timer.performWithDelay(10, changeType)
		  timer.params = {param1 = map}
end

function changeType(event)
	local params = event.source.params
	
	for check = 1, params.param1.layer["tiles"].numChildren do
		if params.param1.layer["tiles"][check].name == "orangeWall" then
			params.param1.layer["tiles"][check].bodyType = "dynamic"
		end
	end
end

function playerInstance:rotate (x,y)
		transition.cancel('rotation')
		angle = (floor(atan2(y, x) * ( 180 / pi))) 
		self.imageObject.rotation = angle +90
end

function playerInstance:addInventory(item, map) 
	self.inventory:addItem(item, map)
end

function playerInstance:addRune(item, map)
	self.inventory:addRune(item, map)
end

local player  = {
	create = create
}

return player






 