import "CoreLibs/object"
import "CoreLibs/graphics"

import "Views/board-ui"

class('Board').extends()

local gfx <const> = playdate.graphics

local ui = BoardUI()

-- Playdate screen is 400x240
local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240
local CUBE_SIZE = 16 * 2 -- this should be dynamic at some point

function Board:init(width, height)
	self.width = width
	self.height = height
	self.debugMode = false
end

function Board:draw(state, gameWinner, cornerMap, cursor, player)
	
	local offset_x = self:get_px_offset_x()
	local offset_y = self:get_px_offset_y()
	
	gfx.pushContext()
	
	ui:draw(gameWinner, player, cornerMap)
		
	-- draw the background grid
	for y in pairs(state)
	do
		for x in pairs(state[y])
		do
			-- overlap by 1px so there isn't a double pixel border
			local grid_x = offset_x - x
			local grid_y = offset_y - y
			
			local pixel_x = CUBE_SIZE*x-CUBE_SIZE+grid_x
			local pixel_y = CUBE_SIZE*y-CUBE_SIZE+grid_y
			
			local cube_item = state[y][x]
			
			gfx.setColor(gfx.kColorBlack)
			gfx.drawRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
			
			if cube_item == 0
			then
				-- do nothing; blank space
			elseif cube_item == 1 
			then
				-- draw player 1 cube on board
				gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
				gfx.fillRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
				gfx.setColor(gfx.kColorBlack)
				gfx.drawRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
			elseif cube_item == 2
			then
				-- draw player 2 cube on board
				gfx.setColor(gfx.kColorBlack)
				gfx.fillRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
			end
		end
	end
	
	-- draw the corners
	-- draw the background grid
	if cornerMap ~= nil
	then
		for y in pairs(cornerMap.data)
		do
			for x in pairs(cornerMap.data[y])
			do
				if cornerMap.data[y][x] > 0
				then
					-- overlap by 1px so there isn't a double pixel border
					local grid_x = offset_x - x
					local grid_y = offset_y - y
					
					local pixel_x = CUBE_SIZE*x-CUBE_SIZE+grid_x
					local pixel_y = CUBE_SIZE*y-CUBE_SIZE+grid_y
					
					if cornerMap.data[y][x] == player
					then
						gfx.setColor(gfx.kColorBlack)
						gfx.fillCircleInRect(pixel_x + 6, pixel_y + 6, CUBE_SIZE - 12, CUBE_SIZE - 12)
					end
				end
			end
		end
	end
	
	-- draw cursor
	cursor:draw(offset_x, offset_y, player)
	
	gfx.popContext()
end

function Board:get_px_offset_x()
	-- return (SCREEN_WIDTH - self:get_px_width()) / 2
	return 16
end

function Board:get_px_offset_y()
	return (SCREEN_HEIGHT - self:get_px_height()) / 2
end

function Board:get_px_width()
	return self.width * CUBE_SIZE - self.width
end

function Board:get_px_height()
	return self.height * CUBE_SIZE - self.height
end