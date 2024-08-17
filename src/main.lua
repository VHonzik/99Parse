local Diagnostics = {}

function love.load()
  Diagnostics.version = "99 Parse 0.1.WIP"
  Diagnostics.fpsMovingAverageK = 5
  Diagnostics.fpsFIFO = {}
  Diagnostics.fps = 0
end

function Diagnostics.updateFPS(dt)
  local new_fps = math.floor(1.0 / dt)
  table.insert(Diagnostics.fpsFIFO, new_fps)
  -- Keep last K FPS values
  if (#Diagnostics.fpsFIFO > Diagnostics.fpsMovingAverageK) then
    table.remove(Diagnostics.fpsFIFO, 1)
  end
  -- Compute average
  Diagnostics.fps = 0
  for i=1,#Diagnostics.fpsFIFO do
    Diagnostics.fps = Diagnostics.fps + Diagnostics.fpsFIFO[i]
  end
  Diagnostics.fps = math.floor(Diagnostics.fps / #Diagnostics.fpsFIFO)
end

function Diagnostics.draw()
  local width, height = love.window.getMode()
  local resolution="" .. width .. "x" .. height
  love.graphics.print("99 Parse 0.1.TODO", 10, 5)
  love.graphics.print(resolution, 10, 20)
  love.graphics.print(Diagnostics.fps.." fps", 10, 35)
end

function love.update(dt)
  Diagnostics.updateFPS(dt)
end

function love.keypressed(key)
  -- Debugging: Exit when Escape is pressed 
  if key == "escape" then
    love.event.quit(0)
  end
end

function love.draw()
  Diagnostics.draw()
end