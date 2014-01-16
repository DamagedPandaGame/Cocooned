-- accelerometer movement
--TODO: change class parameters to take in object and intensity? -negative if backwards?
--to change gravity for certain objects use object.gravityScale(int) 0= no gravity 1= full gravity
local physicsParam = {
	xGrav = 0,
	yGrav = 0
}
local function onAccelerate( event)
	local xGrav=1
	local yGrav=1
	if event.yInstant > 0.1 then
		xGrav = -1
	elseif event.yInstant < -0.1 then
		xGrav = 1
	elseif event.yGravity > 0.1 then
		xGrav = -1
	elseif event.yGravity < -0.1 then
		xGrav = 1
		else
			xGrav = 0
	end
	if event.xInstant > 0.1 then
		yGrav = -1
	elseif event.xInstant < -0.1 then
		yGrav = 1
	elseif event.xGravity > 0.1 then
		yGrav = -1
	elseif event.xGravity < -0.1 then
		yGrav = 1
		else
			yGrav = 0
	end
	print('onAccelerate called')
	physicsParam.xGrav=50*xGrav
	physicsParam.yGrav=50*yGrav
	return physicsParam
end

--[[ check if accel needs to be checked 
if accelerometerON == true then
		whenever accelerometer data changes, call on accelerate
		
	end]]
local accelerometer = {
	onAccelerate = onAccelerate
}

return accelerometer
