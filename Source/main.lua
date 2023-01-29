-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "Data/gamedata"
import "Views/board"

-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- Performance will be slightly enhanced, too.
-- NOTE: Because it's local, you'll have to do it in every .lua source file.

local gfx <const> = playdate.graphics

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.

local BOARD_SIZE = 7

local gd = GameData(BOARD_SIZE,BOARD_SIZE)
local board = Board(BOARD_SIZE,BOARD_SIZE)

local myInputHandlers = {

	AButtonDown = function()
		-- check if game over
		-- TODO: better game over state
		if gd.gameIsRunning == false
		then
			return
		end
		
		-- check if you can place a block
		if gd:checkPlaceBlockAtCursorPosition()
		then
			gd:placeBlock()
		end
	end,
	
	BButtonDown = function()
	end,

	downButtonUp = function()
		gd:move_cursor(0, 1)
	end,
	
	upButtonUp = function()
		gd:move_cursor(0, -1)
	end,
	
	leftButtonUp = function()
		gd:move_cursor(-1, 0)
	end,
	
	rightButtonUp = function()
		gd:move_cursor(1, 0)
	end,
}

-- A function to set up our game environment.

function myGameSetUp()
	
	playdate.inputHandlers.push(myInputHandlers)
	
	local menu = playdate.getSystemMenu()
	menu:addMenuItem("Reset game", 
		function ()
			gd = GameData(BOARD_SIZE,BOARD_SIZE)
		end
	)
	menu:addMenuItem("Debug", 
		function ()
			local debug = nil
			if gd.debugMode then debug = false else debug = true end
				
			board.debugMode = debug
			gd.debugMode = debug
		end
	)

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			-- x,y,width,height is the updated area in sprite-local coordinates
			-- The clip rect is already set to this area, so we don't need to set it ourselves
			
			-- gfx.clear(gfx.kColorWhite)
			-- board:draw()
			
		end
	)
end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetUp()

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()
	
	gfx.sprite.update()
	playdate.timer.updateTimers()
	
	gd:handleCrankInput(playdate.getCrankPosition())
	
	gfx.clear(gfx.kColorWhite)
	board:draw(gd.boardState, gd.gameIsRunning, gd.cornerMap, gd.cursor, gd.currentPlayer)
end