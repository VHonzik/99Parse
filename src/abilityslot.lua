local assets = require('assets')

local as = {}
as.x = 0
as.y = 0
as.icon = nil
as.pressed = false

-- Package name
AbilitySlot = as

function as:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function as:draw()
  love.graphics.draw(self.icon, self.x, self.y)
  love.graphics.draw(assets.T_AbilitySlotShadow, self.x, self.y)
  if self.pressed then
    love.graphics.draw(assets.T_AbilitySlotClick, self.x, self.y)
  end
  love.graphics.draw(assets.T_AbilitySlot, self.x, self.y)
end

function as:inside(x, y)
  local width, height = self.icon:getDimensions()
  return (x >= self.x and x <= self.x + width) and (y >= self.y and y <= self.y + height)
end

function as:press()
  self.pressed = true
end

function as:release()
  self.pressed = false
end

return AbilitySlot