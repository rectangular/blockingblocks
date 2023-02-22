import "CoreLibs/object"
import "CoreLibs/graphics"

class('BoardUI').extends()

local gfx <const> = playdate.graphics

local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240

function BoardUI:init()
end

function BoardUI:draw(gameWinner, player, cornerMap)
	
	local str = ""
	if gameWinner ~= nil
	then
		str = "GAME OVER\n\nPlayer " .. gameWinner .. " wins!"
	else
		str = "Player " .. player .. " turn"
	end
	
	if gameWinner == nil and cornerMap ~= nil
	then
		str = str .. "\n\n" .. "Open: " .. cornerMap.controlled[player]
	end
	
	gfx.setColor(gfx.kColorBlack)
	local size = gfx.getTextSize(str)
	-- local offsetX = SCREEN_WIDTH / 2 - size / 2
	local offsetX = SCREEN_WIDTH / 2 + 40
	gfx.drawText(str, offsetX, 20)
end