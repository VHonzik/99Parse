local diagnostics = {}

local version = require('version')

function diagnostics.load()
  diagnostics.version = "99 Parse "..version.fullString
  diagnostics.fpsK = 5
  diagnostics.fpsInvK = 1.0 / diagnostics.fpsK
  diagnostics.fpsFIFO = {}
  diagnostics.fps = 0
  diagnostics.fpsSkipCounter = 5
  diagnostics.lastTouch = {}
  diagnostics.spellClick = {}
end

function diagnostics.update(dt)
  diagnostics.updatefps(dt)
  if next(diagnostics.spellClick) ~= nil then
    diagnostics.spellClick.timer = diagnostics.spellClick.timer - dt
    if diagnostics.spellClick.timer <= 0 then
      diagnostics.spellClick = {}
    end
  end
end

function diagnostics.updatefps(dt)
  -- Skip first few frames since during initialization dts can be quite large
  if diagnostics.fpsSkipCounter > 0 then
    diagnostics.fpsSkipCounter = diagnostics.fpsSkipCounter - 1
    return
  end
  local newFps = math.floor(1.0 / dt)
  table.insert(diagnostics.fpsFIFO, newFps)
  -- Compute average FPS over last K entries
  -- Until we have K values use Cummulative avergage then switch to Simple moving average
  if (#diagnostics.fpsFIFO <= diagnostics.fpsK) then -- Cummulative average
    local n = #diagnostics.fpsFIFO-1
    local nCA = n * diagnostics.fps
    diagnostics.fps = (newFps + nCA) / (n+1)
  else  -- Simple moving average
    local smaPrev = diagnostics.fps
    local pDiff = (newFps - diagnostics.fpsFIFO[1])
    diagnostics.fps =  smaPrev + diagnostics.fpsInvK * pDiff
    table.remove(diagnostics.fpsFIFO, 1)
  end
end

function diagnostics.draw()
  local width, height = love.graphics.getDimensions()
  local resolution="" .. width .. "x" .. height

  local x = 20
  local y = 10
  love.graphics.print(diagnostics.version, x, y)
  y = y + 15
  love.graphics.print(resolution, x, y)
  y = y + 15
  love.graphics.print(math.floor(diagnostics.fps).." fps", x, y)
  y = y + 15
  if next(diagnostics.lastTouch) ~= nil then
    local prefix = "Touch"
    if not diagnostics.lastTouch.pressed then prefix="Touch release" end
    local coordinates = " x:"..math.floor(diagnostics.lastTouch.x).." y:"..math.floor(diagnostics.lastTouch.y)
    love.graphics.print(prefix..coordinates, x, y)
    y = y + 15
  end
  if next(diagnostics.spellClick) ~= nil then
    love.graphics.print("Clicked spell:"..diagnostics.spellClick.id, x, y)
    y = y + 15
  end
end
 
function diagnostics.touchpressed(x, y)
  diagnostics.lastTouch.x = x
  diagnostics.lastTouch.y = y
  diagnostics.lastTouch.pressed = true
end
 
function diagnostics.touchreleased(x, y)
  diagnostics.lastTouch.x = x
  diagnostics.lastTouch.y = y
  diagnostics.lastTouch.pressed = false
end

function diagnostics.spellrelease(i)
  diagnostics.spellClick.id = i
  diagnostics.spellClick.timer = 2.0
end

function diagnostics.nothingrelease()
  diagnostics.spellClick = {}
end

return diagnostics