-- find the row size
for x=1, #shape
do
	for y=1, #shape[x]
	do
		rowSize += 1
		print("rowSize", rowSize)
	end
	break
end

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