import "CoreLibs/object"

import "Views/cursor"

class('GameData').extends()

local PLAYER_1 = 1
local PLAYER_2 = 2

function GameData:init(board_width, board_height)
	self.debugMode = false
	self.board_state = {}
	self.cursor_grid_pos_x = 1
	self.cursor_grid_pos_y = 1
	self.currentPlayer = PLAYER_1
	
	-- initialize empty board
	for i = 1, board_width do
		self.board_state[i] = {}
	
		for j = 1, board_height do
			self.board_state[i][j] = 0
		end
	end
	
	-- set cursor position
	self.cursor = Cursor()
	self.cursor.debugMode = self.debugMode
	self.board_state[self.cursor_grid_pos_x][self.cursor_grid_pos_y] = self.cursor
end

function GameData:move_cursor(delta_grid_x, delta_grid_y)
	-- calculate new position
	local new_grid_x = self.cursor_grid_pos_x + delta_grid_x
	local new_grid_y = self.cursor_grid_pos_y + delta_grid_y
	
	-- test if within bounds
	if new_grid_x < 1
	then
		return
	end
	
	if new_grid_y < 1
	then
		return
	end
	
	if new_grid_x - 1 + self.cursor.shape:width() > #self.board_state
	then
		return
	end
	
	if new_grid_y - 1 + self.cursor.shape:height() > #self.board_state[#self.board_state]
	then
		return
	end
	
	-- TODO: Refactor piece obstruction
	-- 
	--
	-- another player piece occupies the place
	-- if self.board_state[new_grid_x][new_grid_y] ~= 0
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
	
	-- reset old cursor position to 0
	self.board_state[self.cursor_grid_pos_x][self.cursor_grid_pos_y] = 0
	
	-- create new cursor
	-- TODO: This is likely not required
	-- self.cursor = Cursor()
	-- self.cursor.debugMode = self.debugMode
	
	-- update player position
	self.cursor_grid_pos_x = new_grid_x
	self.cursor_grid_pos_y = new_grid_y
	
	-- move player to new spot
	self.board_state[self.cursor_grid_pos_x][self.cursor_grid_pos_y] = self.cursor
end

function GameData:placeBlock()
	
	print("Placing block at:", self.cursor_grid_pos_x, self.cursor_grid_pos_y)
	
	self.board_state[self.cursor_grid_pos_x][self.cursor_grid_pos_y] = self.currentPlayer
	print("- For player:", self.board_state[self.cursor_grid_pos_x][self.cursor_grid_pos_y])
	
	self:resetCursor()
	self:changePlayer()
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
	
	for x in pairs(self.board_state)
	do
		for y in pairs(self.board_state[x])
		do
			if self.board_state[x][y] == 0
			then
				self.cursor = Cursor()
				self.cursor.debugMode = self.debugMode
				self.board_state[x][y] = self.cursor
				self.cursor_grid_pos_x = x
				self.cursor_grid_pos_y = y
				return
			end
		end
	end
	
	-- if we reach here, no spots available
	self:gameOver()
end
	
	
	