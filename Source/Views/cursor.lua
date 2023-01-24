import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/animation"

import "Utils/rotator"
import "Data/shape"

class('Cursor').extends()

local gfx <const> = playdate.graphics

local CUBE_SIZE = 20

function Cursor:init()
	-- self.blinker = gfx.animation.blinker.new()
	-- self.blinker.loop = true
	-- self.blinker:start()
	self.shape = Shape({
		{1, 1, 1, 1},
		{0, 1, 1, 0},
		{0, 0, 1, 0},
	})
	self.debugMode = false
end

function Cursor:draw(x, y, currentPlayer)
	
	for shape_grid_y in pairs(self.shape.data)
	do
		for shape_grid_x in pairs(self.shape.data[shape_grid_y])
		do
			local grid_x = x - (1 * shape_grid_x)
			local grid_y = y - (1 * shape_grid_y)
			
			local pixel_x = CUBE_SIZE*shape_grid_x-CUBE_SIZE+grid_x + 1
			local pixel_y = CUBE_SIZE*shape_grid_y-CUBE_SIZE+grid_y + 1
			
			if self.debugMode
			then
				-- show numbers
				gfx.setColor(gfx.kColorBlack)
				gfx.drawRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
				gfx.drawText(self.shape.data[shape_grid_y][shape_grid_x], pixel_x + 6, pixel_y + 2)
			else
			
				if self.shape.data[shape_grid_y][shape_grid_x] == 0
				then
					gfx.setColor(gfx.kColorBlack)
					-- gfx.drawRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
				else
				
					if currentPlayer == 1
					then
						gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
					else
						gfx.setColor(gfx.kColorBlack)
					end
					
					gfx.fillRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
					gfx.setColor(gfx.kColorBlack)
					gfx.drawRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
				end
			end
			
		end
	end
	
end