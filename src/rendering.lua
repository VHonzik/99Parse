local rendering = {}

local fpsCapInv = 1.0 / 30.0
local fpsCapInvNudge = fpsCapInv * 0.01


function rendering.load()
  rendering.renderresolution = {}
  rendering.renderresolution.w = 1920
  rendering.renderresolution.h = 1080

  rendering.canvas = love.graphics.newCanvas(rendering.renderresolution.w, rendering.renderresolution.h)
  rendering.frameStart = 0

  rendering.screenresolution = {}
  rendering.screenresolution.w = rendering.renderresolution.w
  rendering.screenresolution.h = rendering.renderresolution.h
end


function rendering.pre()
  love.graphics.setCanvas(rendering.canvas)
  love.graphics.clear()
  love.graphics.push()
end

function rendering.post()
  love.graphics.pop()
  love.graphics.setCanvas()

  local scaleX, scaleY = rendering.renderScale()
  love.graphics.draw(rendering.canvas, 0, 0, 0, scaleX, scaleY)
end

function rendering.renderScale()
  local scaleX = rendering.screenresolution.w / rendering.renderresolution.w
  local scaley = rendering.screenresolution.h / rendering.renderresolution.h
  return scaleX, scaley
end

function rendering.startFrame()
  if love.timer then
    rendering.frameStart = love.timer.getTime()
  end
end

function rendering.endFrame()
  if love.timer then
    local frameDuration = love.timer.getTime() - rendering.frameStart
    if frameDuration < fpsCapInv then
      love.timer.sleep(fpsCapInv - frameDuration - fpsCapInvNudge)
    end
  end
end

function rendering.update()
  rendering.screenresolution.w, rendering.screenresolution.h = love.graphics.getDimensions()
end

function rendering.screenToRender(x,y)
  local renderX = x * rendering.renderresolution.w / rendering.screenresolution.w
  local renderY = y * rendering.renderresolution.h / rendering.screenresolution.h
  return renderX, renderY
end

return rendering