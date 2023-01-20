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
	self.shape = {{1, 0}, {1, 0}, {1, 1}}
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
		for y=1, #table[x]
		do
			print(table[x][y])
		end
	end
end

function Cursor:rotate(shape, clockwise)
	
	if clockwise == false
	then
		return shape
	end
	
	print("--- Rotating. Clockwise?", clockwise)
	print("Starting shape:")
	self:printTable2D(shape)
	
	local newShape = {}
	local trailingRemoved = {}
	local leadingRemoved = {}
	local rowSize = #shape - 1
	
	if clockwise
	then
		for x=1, rowSize
		do
			for x=1, #shape
			do
				local row = shape[x]
				rowSize = #row - 1
				
				-- remove all the trailing numbers from all but the last row
				if x < #shape
				then
					local popped = table.remove(row, #row)
					table.insert(trailingRemoved, #trailingRemoved + 1, popped)
				end
				
				-- remove all the leading numbers from all but the last row
				if x > 1
				then
					local popped = table.remove(row, 1)
					table.insert(leadingRemoved, #leadingRemoved + 1, popped)
				end
				
			end
			
			for x=1, #shape
			do
				local row = shape[x]
				
				-- insert all the leading numbers at the end of all rows but the last
				if x <= #shape
				then
					local toInsert = table.remove(leadingRemoved, 1)
					if toInsert ~= nil
					then
						table.insert(row, 1, toInsert)
					end
				end
				
				-- insert all the trailing numbers at the end of all rows but the first
				if x > 1
				then
					local toInsert = table.remove(trailingRemoved, 1)
					if toInsert ~= nil
					then
						table.insert(row, #row + 1, toInsert)
					end
				end

			end
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
	
	for shape_grid_x in pairs(self.shape)
	do
		for shape_grid_y in pairs(self.shape[shape_grid_x])
		do
			local grid_x = x - (1 * shape_grid_x)
			local grid_y = y - (1 * shape_grid_y)
			
			local pixel_x = CUBE_SIZE*shape_grid_x-CUBE_SIZE+grid_x + 1
			local pixel_y = CUBE_SIZE*shape_grid_y-CUBE_SIZE+grid_y + 1
			
			if self.shape[shape_grid_x][shape_grid_y] == 0
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
			
			-- DEMO NUMBER
			-- gfx.setColor(gfx.kColorBlack)
			-- gfx.drawRect(pixel_x+2, pixel_y+2, CUBE_SIZE-4, CUBE_SIZE-4)
			-- gfx.drawText(self.shape[shape_grid_x][shape_grid_y], pixel_x + 6, pixel_y + 2)
			
		end
	end
	
end