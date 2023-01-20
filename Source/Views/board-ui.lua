import "CoreLibs/object"
import "CoreLibs/graphics"

class('BoardUI').extends()

local gfx <const> = playdate.graphics

local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240

function BoardUI:init()
end

function BoardUI:draw(player)
	local str = ""
	if player == nil
	then
		str = "GAME OVER"
	else
		str = "Player " .. player .. " turn"
	end
	gfx.setColor(gfx.kColorBlack)
	local size = gfx.getTextSize(str)
	gfx.drawText(str, SCREEN_WIDTH / 2 - size / 2, 20)
end