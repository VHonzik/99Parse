-- Include debugger if env variable DEBUG_99PARSE is set to 1
-- ./run.sh script sets it automatically
-- Breakpoints are added by calling the object: `dgb()`
local debug = os.getenv("DEBUG_99PARSE") == "1"
if debug then
  dbg = require 'debugger'
end

local diagnostics = require('diagnostics')
local rendering = require('rendering')
local assets = require('assets')
require("abilityslot")
require("combattext")

local abilitySlots = {}
local combatTexts = {}

function love.load()
  assets.load()
  rendering.load()
  diagnostics.load()

  -- Create ability slots and register them to render
  for i = 0, 4 do
    local y = 40 + (assets.T_ArcaneBlast:getHeight() + 35) * i
    local abilitySlot = AbilitySlot:new{icon=assets.T_ArcaneBlast, x=50, y=y}
    table.insert(abilitySlots, abilitySlot)
    rendering.pushback(abilitySlot)
  end

  -- Register diagnostics to render
  rendering.pushback(diagnostics)
end

function love.update(dt)
  rendering.update()
  diagnostics.update(dt)
  for _, combatText in ipairs(combatTexts) do
    combatText:update(dt)
  end

  for i = #combatTexts, 1, -1 do
    if combatTexts[i].destroyed then
      table.remove(combatTexts, i)
    end
  end
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

function CreateCombatText(text)
  local ct = CombatText:new{text=text}
  table.insert(combatTexts, ct)
  return ct
end

function Press(x,y)
  local renderX, renderY = rendering.screentorender(x,y)

  for _, abilitySlot in ipairs(abilitySlots) do
    if (abilitySlot:inside(renderX, renderY)) then
      abilitySlot:press()
    end
  end
end

function Release(x,y)
  local renderX, renderY = rendering.screentorender(x,y)

  local clickedSomething = false
  for i, abilitySlot in ipairs(abilitySlots) do
    if (abilitySlot:inside(renderX, renderY)) then
      diagnostics.spellrelease(i)
      CreateCombatText(""..i)
      clickedSomething = true
    end
    abilitySlot:release()
  end

  if (not clickedSomething) then
    diagnostics.nothingrelease()
  end
end

function love.touchpressed(_, x, y, _, _, _)
  diagnostics.touchpressed(x, y)
  Press(x,y)
end

function love.touchreleased(_, x, y, _, _, _)
  diagnostics.touchreleased(x, y)
  Release(x, y)
end

function love.mousepressed(x, y, button, istouch, _)
  -- Simulate touch with primary mouse, useful for development
  if (button == 1) and (not istouch) then
    diagnostics.touchpressed(x, y)
    Press(x,y)
  end
end

function love.mousereleased( x, y, button, istouch, _)
  -- Simulate touch with primary mouse, useful for development
  if (button == 1) and (not istouch) then
    diagnostics.touchreleased(x, y)
    Release(x, y)
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