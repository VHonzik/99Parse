local assets = require('assets')

local as = {}
as.__index = as
as.x = 0
as.y = 0
as.icon = nil
as.pressed = false
as.cooldown = false
as.cooldownTimer = 0.0
as.cooldownDuration = 0.0

AbilitySlot = as

function as:new(object)
  object = object or {}
  setmetatable(object, self)
  return object
end

function as:draw()
  love.graphics.draw(self.icon, self.x, self.y)
  if self.cooldown then
    local angle = (1.0 - (self.cooldownTimer / self.cooldownDuration)) * math.pi * 2
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

function as:update(dt)
  if self.cooldown then
    self.cooldownTimer = self.cooldownTimer + dt
    if self.cooldownTimer >= self.cooldownDuration then
      self.cooldown = false
    end
  end
end

function as:inside(x, y)
  -- TODO do better
  if self.cooldown then
    return false
  end
  local width, height = self.icon:getDimensions()
  return (x >= self.x and x <= self.x + width) and (y >= self.y and y <= self.y + height)
end

function as:press()
  self.pressed = true
end

function as:release()
  self.pressed = false
end

function as:triggerCooldown(duration)
  -- TODO better way of handling large cooldown
  if not self.cooldown or self.cooldownDuration < duration then
    self.cooldown = true
    self.cooldownDuration = duration
    self.cooldownTimer = 0.0
  end
end

return AbilitySlot