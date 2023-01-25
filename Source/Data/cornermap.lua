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
		print("in bounds")
		-- eligible place
		local adjData = self.inputData[y][x]
		if adjData == 0
		then
			print("setting x, y to", x, y, piecePlayer)
			self.data[y][x] = piecePlayer
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
						-- local posX = x + adjX
						-- local posY = y + adjY
						-- 
						-- if adjY == 0
						-- then
						-- 	-- NOT eligible spot
						-- 	outputData[posY][posX] = -1
						-- elseif adjX == 0
						-- then
						-- 	-- NOT eligible spot
						-- 	outputData[posY][posX] = -1
						-- elseif posX <= #inputData[1] and posY <= #inputData and posX >= 1 and posY >= 1
						-- then
						-- 	-- eligible place
						-- 	local adjData = inputData[posY][posX]
						-- 	if adjData == 0
						-- 	then
						-- 		outputData[posY][posX] = self.currentPlayer
						-- 	end
						-- end
					end
				end
				
			end
			
		end
	end
	
end

-- archive below
function CornerMap:createCornerMap(inputData, sizeX, sizeY)
	
	local outputData = self:createBlankCornerData(sizeX, sizeY)
	local prevDataX = nil
	
	for y=1, sizeY
	do
		for x=1, sizeX
		do
			-- find open corners
			-- check if spot is occupied and eligible to be a matched corner
			local data = inputData[y][x]
			
			if data ~= 0 and data ~= nil
			then
				-- nearby spaces are empty
				-- check all adjacent squares
				-- -1,-1 -> 1,1
				
				for adjY=-1, 1
				do
					for adjX=-1, 1
					do
						local posX = x + adjX
						local posY = y + adjY
						
						if adjY == 0
						then
							-- NOT eligible spot
							outputData[posY][posX] = -1
						elseif adjX == 0
						then
							-- NOT eligible spot
							outputData[posY][posX] = -1
						elseif posX <= #inputData[1] and posY <= #inputData and posX >= 1 and posY >= 1
						then
							-- eligible place
							local adjData = inputData[posY][posX]
							if adjData == 0
							then
								outputData[posY][posX] = self.currentPlayer
							end
						end
					end
				end
				
			end
			
			prevDataX = data
			
		end
	end
	
	return outputData
end