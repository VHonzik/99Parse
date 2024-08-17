-- Include debugger if env variable DEBUG_99PARSE is set to 1
-- ./run.sh script sets it automatically
-- Breakpoints are added by calling the object: `dgb()`
local debug = os.getenv("DEBUG_99PARSE") == "1"
if debug then
  local dbg = require 'debugger'
end

local diagnostics = require('diagnostics')

function love.load()
  diagnostics.load()
end

function love.update(dt)
  diagnostics.updateFPS(dt)
end

function love.keypressed(key)
  if debug then
    -- Exit when Escape is pressed, useful for development
    if (key == "escape" and debug) then
      love.event.quit(0)
    end
  end
end

function love.draw()
  diagnostics.draw()
end