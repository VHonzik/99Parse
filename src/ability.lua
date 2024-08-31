local a = {}
a.__index = a
a.castTime = 2.0
a.baseCooldown = 1.0 + math.random() * 10.0

Ability = a

function a:new(initialValues)
  local object = initialValues or {}
  setmetatable(object, self)
  object.onCooldown = false
  object.cooldownTimer = 0.0
  object.baseCooldown = a.baseCooldown
  object.cooldownDuration = 0.0
  return object
end

function a:update(dt)
  if self.onCooldown then
    self.cooldownTimer = self.cooldownTimer + dt
    if self.cooldownTimer >= self.cooldownDuration then
      self.onCooldown = false
    end
  end
end

function a:canBeCast()
  return not self.onCooldown
end

function a:_triggerCooldown(duration)
  if self.onCooldown then
    if duration >= (self.cooldownDuration - self.cooldownTimer) then
      self.cooldownDuration = duration
      self.cooldownTimer = 0.0
    end
  else
    self.onCooldown = true
    self.cooldownDuration = duration
    self.cooldownTimer = 0.0
  end
end

function a:triggerCooldown()
  self:_triggerCooldown(self.baseCooldown)
end

function a:triggerGlobalCooldown(duration)
  self:_triggerCooldown(duration)
end

function a:getCooldownT()
  return 1.0 - (self.cooldownTimer / self.cooldownDuration)
end

function a:casted(game)
  game.createCombatText(""..self.index)
end

return Ability