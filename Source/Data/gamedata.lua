import "CoreLibs/object"

import "Views/cursor"

class('GameData').extends()

local PLAYER_1 = 1
local PLAYER_2 = 2

function GameData:init(board_width, board_height)
	self.debugMode = false
	self.boardState = {}
	self.currentPlayer = PLAYER_1
	
	-- initialize empty board
	for i = 1, board_width do
		self.boardState[i] = {}
	
		for j = 1, board_height do
			self.boardState[i][j] = 0
		end
	end
	
	-- set cursor position
	self.cursor = Cursor()
	self.cursor.debugMode = self.debugMode
end

function GameData:move_cursor(delta_grid_x, delta_grid_y)
	-- calculate new position
	local new_grid_x = self.cursor.gridPosX + delta_grid_x
	local new_grid_y = self.cursor.gridPosY + delta_grid_y
	
	-- test if within bounds
	if new_grid_x < 1
	then
		return
	end
	
	if new_grid_y < 1
	then
		return
	end
	
	if new_grid_x - 1 + self.cursor.shape:width() > #self.boardState
	then
		return
	end
	
	if new_grid_y - 1 + self.cursor.shape:height() > #self.boardState[#self.boardState]
	then
		return
	end
	
	-- TODO: Refactor piece obstruction
	-- 
	--
	-- another player piece occupies the place
	-- if self.boardState[new_grid_x][new_grid_y] ~= 0
	-- then
	-- 	print("Can't move into occupied space")
	-- 	-- move along the same axis additional spaces
	-- 	if delta_grid_x ~= 0
	-- 	then
	-- 		if delta_grid_x > 0
	-- 		then
	-- 			self:move_cursor(delta_grid_x+1, 0)
	-- 		else
	-- 			self:move_cursor(delta_grid_x-1, 0)
	-- 		end
	-- 	else
	-- 		if delta_grid_y > 0
	-- 		then
	-- 			self:move_cursor(0, delta_grid_y+1)
	-- 		else
	-- 			self:move_cursor(0, delta_grid_y-1)
	-- 		end
	-- 	end
	-- 	return
	-- end
	
	-- reset cursor position to 1,1
	-- self.cursor.gridPosX = 1
	-- self.cursor.gridPosY = 1
	
	-- update player position
	self.cursor.gridPosX = new_grid_x
	self.cursor.gridPosY = new_grid_y
end

function GameData:checkPlaceBlock()
	print("Checking if we can place block at:", self.cursor.gridPosX, self.cursor.gridPosY)
	
	-- add player cubes to board
	for y=1, #self.cursor.shape.data
	do
		for x=1, #self.cursor.shape.data[y]
		do
			-- Only check if we can add piece if shape data is not 0
			if self.cursor.shape.data[y][x] ~= 0
			then
				local data = self:getBoardDataAt(self.cursor.gridPosX + x - 1, self.cursor.gridPosY + y - 1)
				-- does something already occupy that space?
				if data ~= 0
				then
					print("Can't place block here!")
					print("Conflict at", self.cursor.gridPosX + x - 1, self.cursor.gridPosY + y - 1)
					return false
				end
			end
		end
	end
	
	return true
end

function GameData:placeBlock()
	print("Placing block at:", self.cursor.gridPosX, self.cursor.gridPosY)
	
	-- add player cubes to board
	for y=1, #self.cursor.shape.data
	do
		for x=1, #self.cursor.shape.data[y]
		do
			-- Only add piece if shape data is not 0
			if self.cursor.shape.data[y][x] ~= 0
			then
				self:setBoardDataAt(self.cursor.gridPosX + x - 1, self.cursor.gridPosY + y - 1, self.currentPlayer)
			end
		end
	end
	
	self:resetCursor()
	self:changePlayer()
end

function GameData:findCorners()
end

-- 1 indexed
function GameData:getBoardDataAt(x, y)
	print("Get board data at", x, y)
	return self.boardState[y][x]
end

-- 1 indexed
function GameData:setBoardDataAt(x, y, data)
	print("Set board data at", x, y, data)
	self.boardState[y][x] = data
end

function GameData:handleCrankInput(angle)
	if angle >= 0 and angle < 45
	then
		self.cursor.shape:rotateNorth()
	elseif angle >= 45 and angle < 135
	then
		self.cursor.shape:rotateEast()
	elseif angle >= 135 and angle < 225
	then
		self.cursor.shape:rotateSouth()
	elseif angle >= 225 and angle < 315
	then
		self.cursor.shape:rotateWest()
	elseif angle >= 315 and angle < 360
	then
		self.cursor.shape:rotateNorth()
	end
end

function GameData:changePlayer()
	
	-- don't overwrite game over state
	if self.currentPlayer == nil
	then
		return
	end
	
	if self.currentPlayer == PLAYER_1
	then
		self.currentPlayer = PLAYER_2
	else
		self.currentPlayer = PLAYER_1
	end
	
	print("Changed to", self.currentPlayer)
end

function GameData:gameOver()
	print("game over!")
	self.currentPlayer = nil
end

function GameData:resetCursor()
	
	self.cursor = Cursor()
	self.cursor.debugMode = self.debugMode
	self.cursor.gridPosX = 1
	self.cursor.gridPosY = 1
	
	print("TODO: Implement game end check")
	
	-- for y in pairs(self.boardState)
	-- do
	-- 	for x in pairs(self.boardState[y])
	-- 	do
	-- 		if self.boardState[y][x] == 0
	-- 		then
	-- 			self.cursor = Cursor()
	-- 			self.cursor.debugMode = self.debugMode
	-- 			self.boardState[y][x] = self.cursor
	-- 			self.cursor_grid_pos_x = x
	-- 			self.cursor_grid_pos_y = y
	-- 			return
	-- 		end
	-- 	end
	-- end
	
	-- if we reach here, no spots available
	-- self:gameOver()
end
	
	
	