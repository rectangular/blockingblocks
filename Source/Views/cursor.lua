import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/animation"

import "Utils/rotator"
import "Data/shape"

class('Cursor').extends()

local gfx <const> = playdate.graphics

local CUBE_SIZE = 16
local CUBE_INSET = 3
local CUBE_ELEVATION = 0

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
	self.gridPosX = 1
	self.gridPosY = 1
end

function Cursor:draw(boardOffsetX, boardOffsetY, currentPlayer)
	
	-- convert grid position of top left piece into pixels
	-- e.g. 2,2 -> 20,20
	local gridPosPxX = (self.gridPosX - 1) * CUBE_SIZE
	local gridPosPxY = (self.gridPosY - 1) * CUBE_SIZE
	
	for shapeY in pairs(self.shape.data)
	do
		for shapeX in pairs(self.shape.data[shapeY])
		do
			-- find grid position offset of top left piece by 1px overlap on board; include cube elevation offset
			-- e.g. 20,20 -> 19,19; 30,30 -> 28,28
			local pieceGridPosPxX = gridPosPxX - (shapeX + self.gridPosX - 1) - CUBE_ELEVATION
			local piecegGridPosPxY = gridPosPxY - (shapeY + self.gridPosY - 1) - CUBE_ELEVATION
			
			-- combine both board and shape offsets
			local shapeOffsetX = boardOffsetX + pieceGridPosPxX
			local shapeOffsetY = boardOffsetY + piecegGridPosPxY
			
			-- calculate pixel of each piece of the shape
			local pixelX = CUBE_SIZE * shapeX - CUBE_SIZE + shapeOffsetX
			local pixelY = CUBE_SIZE * shapeY - CUBE_SIZE + shapeOffsetY
			
			if self.debugMode
			then
				-- show numbers
				gfx.setColor(gfx.kColorBlack)
				gfx.drawRect(pixelX+CUBE_INSET, pixelY+CUBE_INSET, CUBE_SIZE-(CUBE_INSET*2), CUBE_SIZE-(CUBE_INSET*2))
				gfx.drawText(self.shape.data[shapeY][shapeX], pixelX + 6, pixelY + 2)
			else
			
				if self.shape.data[shapeY][shapeX] == 0
				then
					-- gfx.setColor(gfx.kColorBlack)
					-- gfx.drawRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
				else
				
					if currentPlayer == 1
					then
						gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
					else
						gfx.setColor(gfx.kColorBlack)
					end
					
					gfx.fillRect(pixelX+CUBE_INSET, pixelY+CUBE_INSET, CUBE_SIZE-(CUBE_INSET*2), CUBE_SIZE-(CUBE_INSET*2))
					gfx.setColor(gfx.kColorBlack)
					gfx.drawRect(pixelX+CUBE_INSET, pixelY+CUBE_INSET, CUBE_SIZE-(CUBE_INSET*2), CUBE_SIZE-(CUBE_INSET*2))
				end
			end
			
		end
	end
	
end