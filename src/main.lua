local game = require("game")

function love.load()
  game.load()
end

function love.update(dt)
  game.update(dt)
end

function love.keypressed(key)
  if debug then
    -- Exit when Escape is pressed, useful for development
    if (key == "escape") then
      love.event.quit(0)
    end

    if (key == "pause") then
      dbg()
    end
  end
end

function love.touchpressed(_, x, y, _, _, _)
  game.press(x,y)
end

function love.touchreleased(_, x, y, _, _, _)
  game.release(x, y)
end

function love.mousepressed(x, y, button, istouch, _)
  -- Simulate touch with primary mouse, useful for development
  if (button == 1) and (not istouch) then
    game.press(x,y)
  end
end

function love.mousereleased( x, y, button, istouch, _)
  -- Simulate touch with primary mouse, useful for development
  if (button == 1) and (not istouch) then
    game.release(x, y)
  end
end

function love.draw()
  game.draw()
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop
	return function()
    game.startFrame()

		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end
		game.endFrame()
	end

end