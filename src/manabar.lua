local assets = require('assets')

local manabar = {}
manabar.__index = manabar
manabar.max = 20000.0
manabar.value = 0.0
manabar.fillTextureOffsets = {x=4, y=4}
Manabar = manabar

function manabar.new(initialValues)
  local mb = initialValues or {}
  setmetatable(mb, manabar)

  mb.shown = true

  return mb
end

function manabar.load()
  manabar.w = assets.T_BarBackground:getWidth()
  manabar.h = assets.T_BarBackground:getHeight()
  manabar.txtYOffset = assets.F_WashYourHands_72:getHeight() * 0.5
end

function manabar:calculateClipMax()
  local valueClamped = math.min(math.max(self.value, 0.0), self.max)
  local t = (valueClamped - 0.0) / (self.max - 0.0)
  -- The fill texture the has same dimensions as the background texture but the border is empty
  -- Therefore we need to use the `t` from we got from self.value find t in coordinate space defined by `fillTextureOffsets`
  local uvOffsets = {x=self.fillTextureOffsets.x / self.w, y=self.fillTextureOffsets.y / self.h}
  local fillT = uvOffsets.x + t * ((1.0 - uvOffsets.x) - (uvOffsets.x))
  return fillT
end

function manabar.draw(self)
  if self.shown then
    love.graphics.draw(assets.T_BarBackground, self.x - self.w * 0.5, self.y - self.h * 0.5)
    assets.S_ClipFade:send("clip_x", self:calculateClipMax())
    assets.S_ClipFade:send("uv_fade", 5.0/self.w)
    love.graphics.setShader(assets.S_ClipFade)
      love.graphics.draw(assets.T_ManabarFill, self.x - self.w * 0.5, self.y - self.h * 0.5)
    love.graphics.setShader()
    love.graphics.setFont(assets.F_WashYourHands_72)
    local txt = ""..self.value.." (".. math.ceil(self.value * 100.0 / manabar.max ) .."%)"
    local txtW = assets.F_WashYourHands_72:getWidth(txt)
    love.graphics.print(txt, math.floor(self.x - txtW*0.5), math.floor(self.y - self.txtYOffset))
    love.graphics.setNewFont(12)
  end
end

return Manabar