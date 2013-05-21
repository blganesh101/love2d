require "block"

BlockImages =
				{
					love.graphics.newImage("images/red.png"),
					love.graphics.newImage("images/blue.png"),
					love.graphics.newImage("images/yellow.png"),
					love.graphics.newImage("images/green.png"),
					love.graphics.newImage("images/turquoise.png"),
					love.graphics.newImage("images/orange.png"),
					love.graphics.newImage("images/pink.png")
				}
				
Shape = {}

function Shape:new()
	math.random()
	o = {
			blockArray = {},
			angle = 1,
			shapeType = math.random(7)
		}
	setmetatable(o, self)
    self.__index = self
    return o
end

function Shape:getBlock(t)
	o = {
			blockArray = {},
			angle = 1,
			shapeType = t
		}
	setmetatable(o, self)
    self.__index = self
    return o
	
end




function Shape:initShape()

	for i = 1, 4 do
		table.insert(self.blockArray,  Block:new())
		self.blockArray[i].image = BlockImages[self.shapeType]
	end
	
	buildShapeType(self.blockArray, self.shapeType)
end


function Shape:initShapeCol(t)

	for i = 1, 4 do
		table.insert(self.blockArray,  Block:new())
		self.blockArray[i].image = BlockImages[self.shapeType]
	end
	
	buildShapeTypeCol(self.blockArray, self.shapeType,t)
end

function Shape:draw()
	for i, v in ipairs(self.blockArray) do
		v:draw()
	end
end

function Shape:checkHitFloor()
	local flag = false
	for i, v in ipairs (self.blockArray) do
		if (v.row + 1) > 18 then
			return true
		else
			flag = false
		end
	end
	return flag
end

function Shape:checkHitWall(e)
	if e == "left" then
		for i,v in ipairs(self.blockArray) do
			if v.coll - 1 < 1 then
				return true
			else
				for j, w in ipairs(DrawList) do
					if v.coll - 1 == w.coll and v.row == w.row then
						return true
					end
				end
			end
		end
		return false
	end
	
	if e == "right" then
		for i,v in ipairs(self.blockArray) do
			if v.coll + 1 > 10 then
				return true
			else
				for j, w in ipairs(DrawList) do
					if v.coll + 1 == w.coll and v.row == w.row then
						return true
					end
				end
			end
		end
		return false
	end
	
end

function Shape:checkOnScreen()
	for i,v in ipairs(self.blockArray) do
		if v.row > 0 then
			return true
		end
	end
	return false
end

function Shape:move(e)

	if e == "left" then
		for i,v in ipairs(self.blockArray) do
			v:setTableVal(v.coll - 1, v.row)
		end
	end
	
	if e == "right" then
		for i,v in ipairs(self.blockArray) do
			v:setTableVal(v.coll + 1, v.row)
		end
	end
end

function Shape:down()
	for i,v in ipairs (self.blockArray) do
		v:setTableVal(v.coll, v.row + 1)
	end
end

function Shape:setTableVal(coll, row)
	for i,v in ipairs (self.blockArray) do
		v:setTableVal(v.coll, v.row + 1)
	end
end

function Shape:rotate()
	blocks = self.blockArray
	t = self.shapeType
	a = self.angle
	
	coll = blocks[1].coll
	row = blocks[1].row
	--no need to rotate a square... it has 4 planes of symmetry
	if t == 2 then
		--shape is a straight line
		
		if a == 1 then
			--make it go horizontal
			coll = coll - 2
			row = row + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll - 2) and v.row == (blocks[1].row + 2)) or
				(v.coll == (blocks[2].coll - 2 + 1) and v.row == (blocks[2].row + 2)) or
				(v.coll == (blocks[3].coll - 2 + 2) and v.row == (blocks[3].row + 2)) or
				(v.coll == (blocks[4].coll - 2 + 3) and v.row == (blocks[4].row + 2))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll + 3 <= 10) and row + 3 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll + 1, row)
				blocks[3]:setTableVal(coll + 2, row)
				blocks[4]:setTableVal(coll + 3, row)
				self.angle = 2
			end
		elseif a == 2 then
			--make it go vertical
			coll = coll + 2
			row = row - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll + 2) and v.row == (blocks[1].row - 2)) or
				(v.coll == (blocks[2].coll + 2) and v.row == (blocks[2].row - 2 + 1)) or
				(v.coll == (blocks[3].coll + 2) and v.row == (blocks[3].row - 2 + 2)) or
				(v.coll == (blocks[4].coll + 2) and v.row == (blocks[4].row - 2 + 3))
				then
					return false
				end
			end
			
			if (coll >= 1 or coll + 3 <= 10) and row + 3 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row + 1)
				blocks[3]:setTableVal(coll, row + 2)
				blocks[4]:setTableVal(coll, row + 3)
				self.angle = 1
			end
		end
	elseif t == 3 then
		--shape is a t shape
		
		if a == 1 then
			row = row - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row - 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row - 2 + 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row - 2 + 2)) or
				(v.coll == (blocks[4].coll) and v.row == (blocks[4].row))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll + 2 <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row + 1)
				blocks[3]:setTableVal(coll, row + 2)
				blocks[4]:setTableVal(blocks[4].coll, blocks[4].row)
				self.angle = 2
			end
		elseif a == 2 then
			coll = coll + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll + 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll + 2 - 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll + 2 - 2) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll) and v.row == (blocks[4].row))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll - 1, row)
				blocks[3]:setTableVal(coll - 2, row)
				blocks[4]:setTableVal(blocks[4].coll, blocks[4].row)
				self.angle = 3
			end
		elseif a == 3 then
			row = row + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row + 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row + 2 - 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row + 2 - 2)) or
				(v.coll == (blocks[4].coll) and v.row == (blocks[4].row))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then	
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row - 1)
				blocks[3]:setTableVal(coll, row - 2)
				blocks[4]:setTableVal(blocks[4].coll, blocks[4].row)
				self.angle = 4
			end
		elseif a == 4 then
			coll =  coll - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll - 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll - 2 + 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll - 2 + 2) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll) and v.row == (blocks[4].row))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll + 1, row)
				blocks[3]:setTableVal(coll + 2, row)
				blocks[4]:setTableVal(blocks[4].coll, blocks[4].row)
				self.angle = 1
			end
		end
		
	elseif t == 4 then
	
		--shape is a forward L
		if a == 1 then
			coll = coll + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll + 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll + 2 - 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll + 2 - 2) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll + 2 - 2) and v.row == (blocks[4].row + 1))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll - 1, row)
				blocks[3]:setTableVal(coll - 2, row)
				blocks[4]:setTableVal(coll - 2, row + 1)
				self.angle = 2
			end
		elseif a == 2 then
			row = row + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row + 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row + 2 - 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row + 2 - 2)) or
				(v.coll == (blocks[4].coll - 1) and v.row == (blocks[4].row + 2 - 2))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then	
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row - 1)
				blocks[3]:setTableVal(coll, row - 2)
				blocks[4]:setTableVal(coll - 1, row - 2)
				self.angle = 3
			end
		elseif a == 3 then
			coll =  coll - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll - 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll - 2 + 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll - 2 + 2) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll - 2 + 2) and v.row == (blocks[4].row - 1))
				then
					return false
				end
			end
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll + 1, row)
				blocks[3]:setTableVal(coll + 2, row)
				blocks[4]:setTableVal(coll + 2, row - 1)
				self.angle = 4
			end
		elseif a == 4 then
			row = row - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row - 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row - 2 + 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row - 2 + 2)) or
				(v.coll == (blocks[4].coll + 1) and v.row == (blocks[4].row - 2 + 2))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll + 2 <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row + 1)
				blocks[3]:setTableVal(coll, row + 2)
				blocks[4]:setTableVal(coll + 1, row + 2)
				self.angle = 1
			end
		end
	elseif t == 5 then
		--shape is a backward L
		if a == 1 then
			coll = coll + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll + 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll + 2 - 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll + 2 - 2) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll + 2) and v.row == (blocks[4].row + 1))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll - 1, row)
				blocks[3]:setTableVal(coll - 2, row)
				blocks[4]:setTableVal(coll, row + 1)
				self.angle = 2
			end
		elseif a == 2 then
			row = row + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row + 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row + 2 - 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row + 2 - 2)) or
				(v.coll == (blocks[4].coll - 1) and v.row == (blocks[4].row + 2))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then	
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row - 1)
				blocks[3]:setTableVal(coll, row - 2)
				blocks[4]:setTableVal(coll - 1, row)
				self.angle = 3
			end
		elseif a == 3 then
			coll =  coll - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll - 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll - 2 + 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll - 2 + 2) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll - 2) and v.row == (blocks[4].row - 1))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll + 1, row)
				blocks[3]:setTableVal(coll + 2, row)
				blocks[4]:setTableVal(coll, row - 1)
				self.angle = 4
			end
		elseif a == 4 then
			row = row - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row - 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row - 2 + 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row - 2 + 2)) or
				(v.coll == (blocks[4].coll + 1) and v.row == (blocks[4].row))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll + 2 <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row + 1)
				blocks[3]:setTableVal(coll, row + 2)
				blocks[4]:setTableVal(coll + 1, row)
				self.angle = 1
			end
		end
	elseif t == 6 then
		if a == 1 then
			coll = coll + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll + 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll + 2 - 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll + 2 - 2) and v.row == (blocks[4].row + 1))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll - 1, row)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll - 2, row + 1)
				self.angle = 2
			end
		elseif a == 2 then
			row = row + 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row + 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row + 2 - 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll - 1) and v.row == (blocks[4].row + 2 - 2))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then	
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row - 1)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll - 1, row - 2)
				self.angle = 3
			end
		elseif a == 3 then
			coll =  coll - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll - 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll - 2 + 1) and v.row == (blocks[2].row)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll - 2 + 2) and v.row == (blocks[4].row - 1))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll + 1, row)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll + 2, row - 1)
				self.angle = 4
			end
		elseif a == 4 then
			row = row - 2
			
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row - 2)) or
				(v.coll == (blocks[2].coll) and v.row == (blocks[2].row - 2 + 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll + 1) and v.row == (blocks[4].row - 2 + 2))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll + 2 <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row + 1)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll + 1, row + 2)
				self.angle = 1
			end
		end
	elseif t == 7 then
		if a == 1 then
			row = row + 2
						
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row + 2)) or
				(v.coll == (blocks[2].coll - 1) and v.row == (blocks[2].row + 2)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll - 2) and v.row == (blocks[4].row + 2 - 1))
				then
					return false
				end
			end
			
			if (coll >= 1 and coll <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll - 1, row)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll - 2, row - 1)
				self.angle = 2
			end
		elseif a == 2 then
			coll = coll - 2
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll - 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll - 2) and v.row == (blocks[2].row - 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll - 2 + 1) and v.row == (blocks[4].row - 2))
				then
					return false
				end
			end
			if (coll >= 1 and coll <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row - 1)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll + 1, row - 2)
				self.angle = 3
			end
		elseif a == 3 then
			row = row - 2
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll) and v.row == (blocks[1].row - 2)) or
				(v.coll == (blocks[2].coll + 1) and v.row == (blocks[2].row - 2)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll + 2) and v.row == (blocks[4].row - 2 + 1))
				then
					return false
				end
			end
			if (coll >= 1 and coll <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll + 1, row)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll + 2, row + 1)
				self.angle = 4
			end
		elseif a == 4 then
			coll = coll + 2
			for i,v in ipairs (DrawList) do
				if 
				(v.coll == (blocks[1].coll + 2) and v.row == (blocks[1].row)) or
				(v.coll == (blocks[2].coll + 2) and v.row == (blocks[2].row + 1)) or
				(v.coll == (blocks[3].coll) and v.row == (blocks[3].row)) or
				(v.coll == (blocks[4].coll + 2 - 1) and v.row == (blocks[4].row + 2))
				then
					return false
				end
			end
			if (coll >= 1 and coll <= 10) and row + 2 <= 20 then
				blocks[1]:setTableVal(coll, row)
				blocks[2]:setTableVal(coll, row + 1)
				blocks[3]:setTableVal(blocks[3].coll, blocks[3].row)
				blocks[4]:setTableVal(coll - 1, row + 2)
				self.angle = 1
			end
		end
		
		local flag = false
		for i,v in ipairs (blocks) do
			if v.coll > 10 then
				flag = true
			end
		end
		
		if flag ==  true then
			for i,v in ipairs(blocks) do
				v:setTableVal(v.coll - 1, v.row)
			end
		end
	end
end

function buildShapeType(blocks, t)
	blocks[1]:setTableVal(5, 0)
	local coll = blocks[1].coll
	local row = blocks[1].row
	if t == 1 then
		--shape is a cube
		blocks[2]:setTableVal(coll + 1, row)
		blocks[3]:setTableVal(coll, row + 1)
		blocks[4]:setTableVal(coll + 1, row + 1)

	elseif t == 2 then
		--shape is a straight line
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll, row + 2)
		blocks[4]:setTableVal(coll, row + 3)
		
	elseif t == 3 then
		--shape is a t shape
		blocks[2]:setTableVal(coll + 1, row)
		blocks[3]:setTableVal(coll + 2, row)
		blocks[4]:setTableVal(coll + 1, row - 1)
		
	elseif t == 4 then
		--shape is a forward L
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll, row + 2)
		blocks[4]:setTableVal(coll + 1, row + 2)
		
	elseif t == 5 then
		--shape is a backwards L
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll, row + 2)
		blocks[4]:setTableVal(coll + 1, row)
		
	elseif t == 6 then
		--shape is a forward Z
		
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll + 1, row + 1)
		blocks[4]:setTableVal(coll + 1, row + 2)
		
	elseif t == 7 then
		--blocks[1]:setTableVal(2, 0)
		--shape is a backwards Z
		--blocks[1]:setTableVal(coll+1, 0)
		blocks[2]:setTableVal(coll , row + 1)
		blocks[3]:setTableVal(coll -1 , row + 1)
		blocks[4]:setTableVal(coll -1, row + 2)
	end

end


function buildShapeTypeCol(blocks, t,col)
	blocks[1]:setTableVal(col, 0)
	local coll = blocks[1].coll
	local row = blocks[1].row
	if t == 1 then
		--shape is a cube
		blocks[2]:setTableVal(coll + 1, row)
		blocks[3]:setTableVal(coll, row + 1)
		blocks[4]:setTableVal(coll + 1, row + 1)

	elseif t == 2 then
		--shape is a straight line
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll, row + 2)
		blocks[4]:setTableVal(coll, row + 3)
		
	elseif t == 3 then
		--shape is a t shape
		blocks[2]:setTableVal(coll + 1, row)
		blocks[3]:setTableVal(coll + 2, row)
		blocks[4]:setTableVal(coll + 1, row - 1)
		
	elseif t == 4 then
		--shape is a forward L
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll, row + 2)
		blocks[4]:setTableVal(coll + 1, row + 2)
		
	elseif t == 5 then
		--shape is a backwards L
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll, row + 2)
		blocks[4]:setTableVal(coll + 1, row)
		
	elseif t == 6 then
		--shape is a forward Z
		
		blocks[2]:setTableVal(coll, row + 1)
		blocks[3]:setTableVal(coll + 1, row + 1)
		blocks[4]:setTableVal(coll + 1, row + 2)
		
	elseif t == 7 then
		--blocks[1]:setTableVal(2, 0)
		--shape is a backwards Z
		--blocks[1]:setTableVal(coll+1, 0)
		blocks[2]:setTableVal(coll , row + 1)
		blocks[3]:setTableVal(coll -1 , row + 1)
		blocks[4]:setTableVal(coll -1, row + 2)
	end

end
