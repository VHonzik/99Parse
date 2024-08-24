local assets = require('assets')
local rendering = require('rendering')

local ct = {}
ct.__index = ct

-- Package name
CombatText = ct

function ct:new(object)
  object = object or {}
  setmetatable(object, self)

  object.x = rendering.renderresolution.w * 0.5 + math.random(-100, 100)
  object.y = rendering.renderresolution.h * 0.5 + math.random(-50, 50)

  local degrees = 50 + math.random()*30
  local angle = math.rad(degrees)
  if (math.random() < 0.5) then angle=math.pi-angle end
  local speed = 600.0
  object.velocity = {}
  object.velocity.x = math.cos(angle) * speed
  object.velocity.y = -math.sin(angle) * speed
  object.acceleration = {x=50.0, y=700}
  if object.velocity.x > 0 then object.acceleration.x = -object.acceleration.x end
  object.destroyed = false

  rendering.pushback(object)

  return object
end

function ct:draw()
  love.graphics.setFont(assets.F_WashYourHands_72)
  love.graphics.print(self.text, self.x, self.y)
  love.graphics.setNewFont(12)
end

function ct:destroy()
  self.destroyed = true
  rendering.erase(self)
end

function ct:update(dt)
  self.velocity.x = self.velocity.x + self.acceleration.x * dt
  self.velocity.y = self.velocity.y + self.acceleration.y * dt

  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt

  if (self.y >= rendering.renderresolution.h + 100) then
    self:destroy()
  end
end



return CombatText