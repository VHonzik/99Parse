local assets = require('assets')

local castbar = {}
castbar.__index = castbar
castbar.x = 0
castbar.y = 0
castbar.min = 0.0
castbar.max = 1.0
castbar.value = 0.0
castbar.fillTextureOffsets = {x=4, y=4}

Castbar = castbar

function castbar.load()
  castbar.w = assets.T_BarBackground:getWidth()
  castbar.h = assets.T_BarBackground:getHeight()
  castbar.hlW = assets.T_CastbarHighlight:getWidth()
  castbar.txtYOffset = assets.F_WashYourHands_72:getHeight() * 0.5
end

function castbar.new(initialValues)
  local cb = initialValues or {}
  setmetatable(cb, castbar)

  cb.done = true
  cb.shown = false
  cb.text = ""
  return cb
end

function castbar:calculateClipMax()
  local valueClamped = math.min(math.max(self.value, 0.0), self.max)
  local t = (valueClamped - 0.0) / (self.max - 0.0)
  -- The fill texture the has same dimensions as the background texture but the border is empty
  -- Therefore we need to use the `t` from we got from self.value find t in coordinate space defined by `fillTextureOffsets`
  local uvOffsets = {x=self.fillTextureOffsets.x / self.w, y=self.fillTextureOffsets.y / self.h}
  local fillT = uvOffsets.x + t * ((1.0 - uvOffsets.x) - (uvOffsets.x))
  return fillT
end


function castbar.draw(self)
  if self.shown then
    love.graphics.draw(assets.T_BarBackground, self.x - self.w * 0.5, self.y - self.h * 0.5)

    local t = self:calculateClipMax()
    assets.S_ClipFade:send("clip_x", t)
    assets.S_ClipFade:send("uv_fade", 5.0/self.w)

    love.graphics.setShader(assets.S_ClipFade)
      love.graphics.draw(assets.T_CastbarFill, self.x - self.w * 0.5, self.y - self.h * 0.5)
    love.graphics.setShader()

    love.graphics.draw(assets.T_CastbarHighlight, self.x - self.hlW * 0.5 + self.w * (-0.5 + t), self.y - self.h * 0.5)

    love.graphics.setFont(assets.F_WashYourHands_72)
    local txtW = assets.F_WashYourHands_72:getWidth(self.text)
    love.graphics.print(self.text, math.floor(self.x - txtW*0.5), math.floor(self.y - self.txtYOffset))
    love.graphics.setNewFont(12)
  end
end

function castbar.update(self, dt)
  if not self.done then
    self.value = self.value + dt
    if self.value > self.max then
      self.value = self.max
      self.done = true
    end
  end
end

function castbar.startCasting(self, duration, text)
  self.max = duration
  self.min = 0.0
  self.value = self.min
  self.done = false
  self.shown = true
  self.text = text
end

function castbar.castingEnded(self)
  self.shown = false
end

function castbar.remainingTime(self)
  return (self.max - self.value)
end

return Castbar