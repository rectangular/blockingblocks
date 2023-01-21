import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/animation"

class('Cursor').extends()

local gfx <const> = playdate.graphics

local CUBE_SIZE = 20

function Cursor:init()
	-- self.blinker = gfx.animation.blinker.new()
	-- self.blinker.loop = true
	-- self.blinker:start()
	self.shape = {
		{1, 2, 3, 4},
		{5, 6, 7, 8},
	}
	self.debug = true
end

function Cursor:printTable(table)
	for x=1, #shape
	do
		print(shape[x])
	end
end

function Cursor:printTable2D(table)
	for x=1, #table
	do
		printTable(table[x])
	end
end

function Cursor:rotate(shape, clockwise)
	
	if clockwise == false
	then
		return shape
	end
	
	if clockwise
	then
		local left = 1
		local right = #shape
		
		while left < right
		do
			for i=1, right - 1
			do
				local i = i - 1
				local top = left
				local bottom = right
				
				-- save the top left corner
				local topLeft = shape[top][left + i]
				
				-- move bottom left into top left
				local bottomLeft = shape[bottom - i][left]
				shape[top][left + i] = bottomLeft
				
				-- move the bottom right into bottom left
				local bottomRight = shape[bottom][right - i]
				shape[bottom - i][left] = bottomRight
				
				-- move the top right into bottom right
				local topRight = shape[top + i][right]
				shape[bottom][right - i] = topRight
				
				-- move the top left into top right
				shape[top + i][right] = topLeft
			end
			right = right - 1
			left = left + 1
		end
	end
		
	
	print("Shape done:")
	self:printTable2D(shape)
	
	return shape
end

function Cursor:draw(x, y, currentPlayer, rotateClockwise)
	
	
	if rotateClockwise ~= nil
	then
		self.shape = self:rotate(self.shape, rotateClockwise)
	end	
	
	for shape_grid_y in pairs(self.shape)
	do
		for shape_grid_x in pairs(self.shape[shape_grid_y])
		do
			local grid_x = x - (1 * shape_grid_x)
			local grid_y = y - (1 * shape_grid_y)
			
			local pixel_x = CUBE_SIZE*shape_grid_x-CUBE_SIZE+grid_x + 1
			local pixel_y = CUBE_SIZE*shape_grid_y-CUBE_SIZE+grid_y + 1
			
			if self.debug
			then
				-- show numbers
				gfx.setColor(gfx.kColorBlack)
				gfx.drawRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
				gfx.drawText(self.shape[shape_grid_y][shape_grid_x], pixel_x + 6, pixel_y + 2)
			else
			
				if self.shape[shape_grid_y][shape_grid_x] == 0
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