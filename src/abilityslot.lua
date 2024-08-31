local assets = require('assets')

local as = {}
as.__index = as
as.x = 0
as.y = 0
as.ability = nil
as.pressed = false

AbilitySlot = as

function as:new(object)
  object = object or {}
  setmetatable(object, self)
  return object
end

function as:draw()
  love.graphics.draw(self.ability.icon, self.x, self.y)
  if self.ability.onCooldown then
    local angle = self.ability:getCooldownT() * math.pi * 2
    assets.S_RadialFade:send("target_angle", angle)
    love.graphics.setShader(assets.S_RadialFade)
      love.graphics.draw(assets.T_AbilitySlotCooldown, self.x, self.y)
    love.graphics.setShader()
  end
  

  love.graphics.draw(assets.T_AbilitySlotShadow, self.x, self.y)
  if self.pressed then
    love.graphics.draw(assets.T_AbilitySlotClick, self.x, self.y)
  end
  love.graphics.draw(assets.T_AbilitySlot, self.x, self.y)
end

function as:inside(x, y)
  local width, height = self.ability.icon:getDimensions()
  return (x >= self.x and x <= self.x + width) and (y >= self.y and y <= self.y + height)
end

function as:press()
  self.pressed = true
end

function as:release()
  self.pressed = false
end

return AbilitySlot