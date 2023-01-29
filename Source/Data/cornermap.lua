import "CoreLibs/object"

class('CornerMap').extends()

local NOT_CORNER = -1
local NOT_DETERMINED = 0
local PLAYER_1 = 1
local PLAYER_2 = 2

function CornerMap:init(inputData, sizeX, sizeY, currentPlayer)
	self.sizeX = sizeX
	self.sizeY = sizeY
	self.inputData = inputData
	self.currentPlayer = currentPlayer
	self.data = self:createBlankCornerData(sizeX, sizeY)
	self.controlled = {
		[PLAYER_1] = 0,
		[PLAYER_2] = 0,
	}
	self:constructMap()
end

function CornerMap:createBlankCornerData(sizeX, sizeY)
	local outputData = {}
	
	for y=1, sizeY
	do
		outputData[y] = {}
		for x=1, sizeX
		do
			outputData[y][x] = NOT_DETERMINED
		end
	end
	
	return outputData
end

function CornerMap:inBounds(x, y, width, height)
	
	if x <= width and y <= height and x >= 1 and y >= 1
	then
		return true
	end
	
	return false
end

function CornerMap:markAdjacentPiece(x, y, piecePlayer)
	
	if self:inBounds(x, y, #self.inputData[1], #self.inputData)
	then
		-- eligible place
		local adjData = self.inputData[y][x]
		if adjData == 0
		then
			self.data[y][x] = piecePlayer
			self.controlled[piecePlayer] = self.controlled[piecePlayer] + 1
		end
	end
end

function CornerMap:constructMap()
	
	for y=1, self.sizeY
	do
		for x=1, self.sizeX
		do
			-- find open corners
			-- check if spot is occupied and eligible to be a matched corner
			local squareData = self.inputData[y][x]
			
			if squareData ~= 0 and squareData ~= nil
			then
				-- nearby spaces are empty
				-- check all adjacent squares
				-- -1,-1 -> 1,1
				
				for adjY=-1, 1
				do
					for adjX=-1, 1
					do
						self:markAdjacentPiece(x + adjX, y + adjY, squareData)
					end
				end
				
			end
			
		end
	end
	
end

-- Return true a player controls any of these coordinates; otherwise return false
function CornerMap:checkPlayerMapControl(player, coordinates)
	-- coordinates is table of coordinates {{x: 8, y: 27}, {x: 9, y: 27}}
	for i=1, #coordinates
	do
		local coords = coordinates[i]
		if coords.x <= self.sizeX and coords.y <= self.sizeY
		then
			if self.data[coords.y][coords.x] == player
			then
				return true
			end
		end
	end
	
	return false
end