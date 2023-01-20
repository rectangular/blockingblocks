import "CoreLibs/object"
import "CoreLibs/graphics"

import "Views/board-ui"

class('Board').extends()

local gfx <const> = playdate.graphics

local ui = BoardUI()

-- Playdate screen is 400x240
local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240
local CUBE_SIZE = 20 -- this should be dynamic at some point

function Board:init(width, height)
	self.width = width
	self.height = height
	self.rotateShape = false
end

function Board:draw(state, player)
	
	local offset_x = self:get_px_offset_x()
	local offset_y = self:get_px_offset_y()
	
	gfx.pushContext()
	
	ui:draw(player)
		
	-- draw the background grid
	for x in pairs(state)
	do
		for y in pairs(state[x])
		do
			-- overlap by 1px so there isn't a double pixel border
			local grid_x = offset_x - (1 * x)
			local grid_y = offset_y - (1 * y)
			
			local pixel_x = CUBE_SIZE*x-CUBE_SIZE+grid_x
			local pixel_y = CUBE_SIZE*y-CUBE_SIZE+grid_y
			
			local cube_item = state[x][y]
			
			gfx.setColor(gfx.kColorBlack)
			gfx.drawRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
			
			if cube_item == 0
			then
				-- do nothing
			elseif cube_item == 1 
			then
				-- draw player 1 cube
				gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
				gfx.fillRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
				gfx.setColor(gfx.kColorBlack)
				gfx.drawRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
			elseif cube_item == 2
			then
				-- draw player 2 cube
				gfx.setColor(gfx.kColorBlack)
				gfx.fillRect(pixel_x, pixel_y, CUBE_SIZE, CUBE_SIZE)
			else
				cube_item:draw(pixel_x, pixel_y, player, self.rotateShape)
			end
		end
	end
	self.rotateShape = false
	gfx.popContext()
end

function Board:get_px_offset_x()
	return (SCREEN_WIDTH - self:get_px_width()) / 2
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