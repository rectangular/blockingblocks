import "CoreLibs/object"

import "Utils/rotator"

local NORTH = 1
local EAST = 2
local SOUTH = 3
local WEST = 4

class('Shape').extends()

function Shape:init(shapeData)
	self.data = shapeData
	self.direction = NORTH
end

function Shape:rotateCW()
	self.data = swapXY(self.data)
	self.data = flipX(self.data)
end

function Shape:rotateCCW()
	print("CCW rotation is not implemented yet!")
end

function Shape:rotateTo(moveToDirection)	
	-- return if no change
	if moveToDirection == self.direction then return end
	
	local delta = self.direction - moveToDirection
	
	if self.direction > moveToDirection
	then
		delta = delta - 4
	end
	
	delta = math.abs(delta)
	
	for i=1, delta
	do
		self:rotateCW()
	end
	
	self.direction = moveToDirection
end

function Shape:rotateNorth()
	self:rotateTo(NORTH)
end

function Shape:rotateEast()
	self:rotateTo(EAST)
end

function Shape:rotateSouth()
	self:rotateTo(SOUTH)
end

function Shape:rotateWest()
	self:rotateTo(WEST)
end

function Shape:width()
	return #self.data[1]
end

function Shape:height()
	return #self.data
end
	

-- To consider:
-- - calculate corners
-- - calculate point value
