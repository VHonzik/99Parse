local assets = require('assets')
local rendering = require('rendering')

local combatText = {}
combatText.__index = combatText
combatText.text = ""

CombatText = combatText

function combatText.new(object)
  local combatTextInstance = object or {}
  setmetatable(combatTextInstance, combatText)

  combatTextInstance.x = rendering.renderresolution.w * 0.5 + math.random(-100, 100)
  combatTextInstance.y = rendering.renderresolution.h * 0.5 + math.random(-50, 50)

  local degrees = 50 + math.random()*30
  local angle = math.rad(degrees)
  if (math.random() < 0.5) then angle=math.pi-angle end

  local speed = 600.0
  combatTextInstance.velocity = {}
  combatTextInstance.velocity.x = math.cos(angle) * speed
  combatTextInstance.velocity.y = -math.sin(angle) * speed
  combatTextInstance.acceleration = {x=50.0, y=700}
  if combatTextInstance.velocity.x > 0 then combatTextInstance.acceleration.x = -combatTextInstance.acceleration.x end
  combatTextInstance.markedForDestruction = false

  return combatTextInstance
end

function combatText.draw(self)
  love.graphics.setFont(assets.F_WashYourHands_72)
  love.graphics.print(self.text, self.x, self.y)
  love.graphics.setNewFont(12)
end

function combatText.update(self, dt)
  self.velocity.x = self.velocity.x + self.acceleration.x * dt
  self.velocity.y = self.velocity.y + self.acceleration.y * dt

  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt

  if (self.y >= rendering.renderresolution.h + 100) then
    self.markedForDestruction = true
  end
end

return CombatText