function swapXY(shape)
	
	print("Swapping X -> Y")
	
	local newShape = {}
	
	for y=#shape, 1, -1
	do
		for x=#shape[y], 1, -1
		do
			if newShape[x] == nil
			then
				newShape[x] = {}
			end
			newShape[x][y] = shape[y][x]
		end
	end
	
	return newShape
	
end

function flipX(shape)
	
	print("Flipping X")
	
	local newShape = {}
	
	for y=1, #shape
	do
		newShape[y] = {}
		for x=1, #shape[y]
		do
			local value = shape[y][x]
			table.insert(newShape[y], 1, value)
		end
	end
	
	return newShape
end

function rotateSquare(shape)
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
	
	return shape
end