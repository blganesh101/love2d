DrawList = {}
Game = {}
Game.height = 640
Game.width = 320
Game.score = 0
Game.speed = 1
Game.lineCount = 0
Game.nextIncreatment = 5
Game.displayMenu = true
Game.paused = false
Game.EOG = false

Game.flagCount = 0

require "shape"

tmr = 0

--  load the basic graphics
function love.load()
	love.graphics.setCaption("Tetris")
	love.graphics.setBackgroundColor(205,183,158)	
	love.graphics.setMode(Game.width, Game.height, false, true, 0)
	love.graphics.setColorMode("replace")
	love.graphics.newImage("images/background.jpg")
	currentBlock = Shape:new()
	currentBlock:initShape()
end


--menu to play tetris
function showMenu()
	love.graphics.setColor(0, 0, 0, 220)
	love.graphics.rectangle("fill", 0, 0, 320, 590 )
	love.graphics.printf("TETRIS" , 80, 160, 150, "center")
	love.graphics.printf("Press Enter to start New Game" , 60, 250, 200, "center")
end


--pause screen configuration
function showPauseScreen()
	love.graphics.setColor(0, 0, 0, 220)
	love.graphics.rectangle("fill", 0, 140, 320, 80 )
	love.graphics.printf("Game Paused", 80, 160, 150, "center")
	love.graphics.printf("press F1 to Un-pause" , 60, 180, 200, "center")
end

-- game over
function showGameOver()
	love.graphics.setColor(0, 0, 0, 220)
	love.graphics.rectangle("fill", 0, 140, 320,  100 )
	love.graphics.printf("Game Over" , 80, 160, 150, "center")
	love.graphics.printf("Your Score was: " .. Game.score , 60, 180, 200, "center")
	love.graphics.printf("Enter for new game." , 60, 200, 200, "center")
end

--score window

function showScore()
	love.graphics.setColor(0, 0, 0, 220)
	love.graphics.rectangle("fill", 0, 570, 320, 70 )
	love.graphics.printf("Score: " .. Game.score , 10, 600, 80, "left")
	love.graphics.printf("Speed: " .. Game.speed .. "s" , 80, 600, 80, "left")
end


--new game
function newGame()
	DrawList = {}
	currentBlock = Shape:new()
	currentBlock:initShape()
	Game.speed = 0.5
	Game.score = 0
	Game.EOG = false
	Game.paused = false
	Game.displayMenu = false
	
end


function checkGameOver()
	for i,v in ipairs(DrawList) do
		if v.row <= 1 then
			return true
		end
	end
	return false
end

--love upadte method
function love.update(dt)
	math.randomseed(os.time() + dt)
	tmr = tmr + dt

	if Game.paused == false and Game.EOG == false then
	
		if tmr >= Game.speed then
			if currentBlock:checkHitFloor() == false and checkHitBlock() == false then
				currentBlock:down()
				tmr = 0
			else
				makeNewBlock()
			end
		end
		
		local linesThisDelta = checkLine()
		Game.lineCount = Game.lineCount + linesThisDelta
		--print ("Game.lineCount",Game.lineCount)
		Game.EOG = checkGameOver()
		Game.score = Game.score + (linesThisDelta * 10)
		
		if Game.lineCount >= Game.nextIncreatment and linesThisDelta ~= 0 then
			Game.speed = Game.speed - 0.1
			local r = Game.lineCount % 5
			Game.nextIncreatment = (Game.lineCount - r) + 5
		end		
	end
end

function love.draw()
	
	for i,v in ipairs(DrawList) do
		v:draw()
	end
	currentBlock:draw()
	--Draw the menus and score
	if Game.displayMenu ==  true then
		Game.paused = true
		showMenu()
	elseif Game.displayMenu == false and Game.paused ==  true then
		showPauseScreen()
	end
	
	if Game.EOG == true then
		showGameOver()
	end
	
	showScore()
end

function love.keypressed(e)
	
	if currentBlock:checkHitWall(e) == false then
		currentBlock:move(e)
	end
	
	if e == "down" then
		if currentBlock:checkOnScreen() == true then
			local flag = false
			while flag == false do
				if currentBlock:checkHitFloor() == false and checkHitBlock() == false then
					currentBlock:down()
				else
					makeNewBlock()
					flag = true
				end
			end
		end
	end
	
	if e == "up" then
		currentBlock:rotate()
	end
	

	if Game.paused == true or Game.displayMenu ==  true or Game.EOG == true then
		if e == "kpenter" or e == "return" then
			newGame()
		end
	end
	
	if e == "f1" then
		if Game.paused == true then
			Game.paused = false
		else
			Game.paused = true
		end
	end
end


function checkHitBlock()
	for i,v in ipairs(DrawList) do
		for j,w in ipairs(currentBlock.blockArray) do
			if w.row + 1 == v.row and w.coll == v.coll then
				return true
			end
		end
	end
	return false
end


function makeNewBlock()
	for i,v in ipairs(currentBlock.blockArray) do
		table.insert(DrawList, v)
	end
	--getNextBlock()
	
	local noOfLines = 0
	local lineCount = 0
	local lineVals = {}
	local colVals = {}
	
	for i=1,20 do
		colVals[i]={}
	end
	
	
	--build colVals matrix so that from that we could identify empty nodes
	for i = 1, 20 do
		local lineCount = 0
		local c = 0;
		for j,v in ipairs(DrawList) do
			if v.row == i then
				colVals[i][v.coll]=1
				--print(i,v.coll)
				lineCount = lineCount + 1		
			end
			
			--print(i,j)
			
		end
		--print(lineCount)
		table.insert(lineVals, lineCount)
	end

	local topRow = 18
	
	
	-- calculate the topmost row, so that we can cut short the other loops and save processing
	for i = 1, 18 do
		for j = 1,20 do
			if colVals[i][j]==1 then 
				if i  <= topRow then
					topRow = i;
				end
			 end
		end
		
	end
	
	local scoreLine = topRow
	local nilFlag = true
	
	
	-- find the row num which use is most probably to score the point, so that we can block that line fill 
	for i = topRow, 18 do
		nilFlag = true
		for j = 1,20 do
			if colVals[i][j]==nil then 
				for k = topRow,i do
					if colVals[k][j] == 1 then
						--print(k,j)
						nilFlag = false
					end
				end
			 end
		end
		if nilFlag == true then 
			scoreLine = i
		end
		
	end
	
	
	
	
	-- identify the num of adjacent empty spaces so that we can fire a appropriate worst block
	
	local c = 0
	local count = 0
	local emptyCount = 0
	--print("scoreLine: ",scoreLine)
	for j = 1,10 do
		if colVals[scoreLine][j] == nil then 
				c = c + 1
				emptyCount = emptyCount + 1
				--print("c ",j,c)
				if c >= count then 
					count = c
				end
					
		else
			c = 0	
		end
	end
	
	
	
	if count == 1 and emptyCount == 1 then -- only single empty cell, shoot a cube 
		currentBlock = Shape:getBlock(1)
		currentBlock:initShape()	
	elseif count == 2 and emptyCount == 2 then -- only single two-cell empty, shoot a line
		currentBlock = Shape:getBlock(2)
		currentBlock:initShape()
	elseif count == 3 and emptyCount == 3 then -- only single three-cell empty, shoot a Z or S
			currentBlock = Shape:getBlock(6)
			currentBlock:initShape()			
	else
		currentBlock = Shape:new() -- all other cases take a random block
		currentBlock:initShape()
			
	end

end
		
		


-- function to check the line for removing the successfull complettion
function checkLine()
	local noOfLines = 0
	local lineCount = 0
	local lineVals = {}
	local aboveVals = {}
	
	for i = 1, 20 do
		for j,v in ipairs(DrawList) do
			if v.row == i then
				lineCount = lineCount + 1
				table.insert(lineVals, j)
			elseif v.row < i then
				table.insert(aboveVals, v)
			end
		end
		
		if lineCount == 10 then
			for j,v in ipairs(lineVals) do
				--print("line clear")
				--love.graphics.line()
				table.remove(DrawList, v - j + 1)
			end
			for j,v in ipairs(aboveVals) do
				v:setTableVal(v.coll, v.row + 1)
			end
			noOfLines = noOfLines + 1
		end
		
		lineCount = 0
		lineVals = {}
		aboveVals = {}
	end
	
	--print("no of lines ",noOfLines)
	
	return noOfLines
end


