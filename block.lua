
Block = {}

function Block:new()
	  o = {
			  image = nil,
			  row = 1,
			  coll = 1,
			  x = 0, --width in px -32
			  y = 0
		   }

      setmetatable(o, self)
      self.__index = self
      return o
end

function Block:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 0, 0)
end

function Block:setTableVal(coll, row)
	self.coll = coll
	self.row = row
	self.x = (coll - 1) * 32
	self.y = (row - 1) * 32
	--print(self.coll,",",self.row)
end

function Block:setCoordinates(x, y)
	self.x = x
	self.y = y
end
