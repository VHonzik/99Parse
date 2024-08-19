local rendering = {}

local fpsCapInv = 1.0 / 30.0
local fpsCapInvNudge = fpsCapInv * 0.01

function rendering.load()
  rendering.renderresolution = {}
  rendering.renderresolution.w = 1920
  rendering.renderresolution.h = 1080
  BgImage = love.graphics.newImage("Background1920.jpg")
  ArcaneBlast = love.graphics.newImage("ArcaneBlast.jpg")
  rendering.canvas = love.graphics.newCanvas(rendering.renderresolution.w, rendering.renderresolution.h)
  rendering.queue = {}
  rendering.frameStart = 0

  rendering.screenresolution = {}
  rendering.screenresolution.w = rendering.renderresolution.w
  rendering.screenresolution.h = rendering.renderresolution.h
end

function rendering.pushback(object)
  table.insert(rendering.queue, object)
end

function rendering.draw()
  love.graphics.setCanvas(rendering.canvas)
    love.graphics.clear()
      love.graphics.push()
      love.graphics.draw(BgImage, 0, 0)
      for i = 0, 4 do
        love.graphics.draw(ArcaneBlast, 50, 50+((255*0.6)+50)*i)
      end
      for _,object in ipairs(rendering.queue) do
        object.draw()
      end
    love.graphics.pop()
  love.graphics.setCanvas()

  local scaleX, scaleY = rendering.renderscale()
  love.graphics.draw(rendering.canvas, 0, 0, 0, scaleX, scaleY)
end

function rendering.renderscale()
  local scaleX = rendering.screenresolution.w / rendering.renderresolution.w
  local scaley = rendering.screenresolution.h / rendering.renderresolution.h
  return scaleX, scaley
end

function rendering.startframe()
  if love.timer then
    rendering.frameStart = love.timer.getTime()
  end
end

function rendering.endframe()
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

function rendering.screentorender(x,y)
  local renderX = x * rendering.renderresolution.w / rendering.screenresolution.w
  local renderY = y * rendering.renderresolution.h / rendering.screenresolution.h
  return renderX, renderY
end

return rendering