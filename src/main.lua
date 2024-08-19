-- Include debugger if env variable DEBUG_99PARSE is set to 1
-- ./run.sh script sets it automatically
-- Breakpoints are added by calling the object: `dgb()`
local debug = os.getenv("DEBUG_99PARSE") == "1"
if debug then
  local dbg = require 'debugger'
end

local diagnostics = require('diagnostics')
local rendering = require('rendering')

function love.load()
  rendering.load()
  diagnostics.load()

  -- Register objects to render
  rendering.pushback(diagnostics)
end

function love.update(dt)
  rendering.update()
  diagnostics.update(dt)
end

function love.keypressed(key)
  if debug then
    -- Exit when Escape is pressed, useful for development
    if (key == "escape" and debug) then
      love.event.quit(0)
    end
  end
end

function Spellclick(x,y)
  local renderX, renderY = rendering.screentorender(x,y)
  local blastW, blastH = ArcaneBlast:getDimensions()

  local clickedSomething = false
  for i = 1, 5 do
    local startX = 50
    local startY = 50+((255*0.6)+50)*(i-1)
    if (renderX >= startX and renderX <= startX + blastW) and (renderY >= startY and renderY <= startY + blastH) then
      diagnostics.spellclick(i)
      clickedSomething = true
    end
  end

  if (not clickedSomething) then
    diagnostics.nothingclick()
  end
end

function love.touchpressed(_, x, y, _, _, _)
  diagnostics.touchpressed(x, y)
  Spellclick(x,y)
end

function love.mousepressed(x, y, button, istouch, presses)
  -- Simulate touch with primary mouse, useful for development
  if (button == 1) and (not istouch) then
    diagnostics.touchpressed(x, y)
    Spellclick(x,y)
  end
end

function love.draw()
  rendering.draw()
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
    -- Measure frame time
    rendering.startframe()

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
		rendering.endframe()
	end

end