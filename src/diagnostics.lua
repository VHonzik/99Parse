local diagnostics = {}

function diagnostics.load()
  diagnostics.version = "99 Parse 0.1.WIP"
  diagnostics.fpsK = 5
  diagnostics.fpsInvK = 1.0 / diagnostics.fpsK
  diagnostics.fpsFIFO = {}
  diagnostics.fps = 0
  diagnostics.fpsSkipCounter = 5
end

function diagnostics.updateFPS(dt)
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
  local width, height = love.window.getMode()
  local resolution="" .. width .. "x" .. height
  love.graphics.print("99 Parse 0.1.TODO", 10, 5)
  love.graphics.print(resolution, 10, 20)
  love.graphics.print(math.floor(diagnostics.fps).." fps", 10, 35)
end

return diagnostics