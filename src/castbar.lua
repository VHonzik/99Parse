local assets = require('assets')

local castbar = {}
castbar.__index = castbar
castbar.x = 0
castbar.y = 0
castbar.min = 0.0
castbar.max = 1.0
castbar.value = 0.0
castbar.speed = (castbar.max - castbar.min) / 2.0

Castbar = castbar

function castbar.load()
  castbar.w = assets.T_CastbarBorder:getWidth()
  castbar.h = assets.T_CastbarBorder:getHeight()
end

function castbar.createMesh(self, width, height)
  local vertices = {
		{
			-- top-left corner
			0, 0, -- position of the vertex
			0, 0, -- texture coordinate at the vertex position
		},
		{
			-- top-right corner
			width, 0,
			1, 0, -- texture coordinates are in the range of [0, 1]
			1, 1, 1
		},
		{
			-- bottom-right corner
			width, height,
			1, 1,
		},
		{
			-- bottom-left corner
			0, height,
			0, 1
		},
	}

  return love.graphics.newMesh(vertices, "fan")
end

function castbar.new(initialValues)
  local cb = initialValues or {}
  setmetatable(cb, castbar)

  local extendedSize = {w=cb.w + 10.0, h=cb.h + 10.0}

  -- Create 9-Patch tables for rendering Castbar textures
  -- Semi-transparent dark background
  cb.bgNinePatch = {w=extendedSize.w,
    h=extendedSize.h,
    borders={10.0, 10.0},
    color=nil,
  }
  cb.bgNinePatch.x = cb.x-cb.bgNinePatch.w*0.5
  cb.bgNinePatch.y = cb.y-cb.bgNinePatch.h*0.5
  cb.bgNinePatch.mesh = cb:createMesh(cb.bgNinePatch.w, cb.bgNinePatch.h)
  cb.bgNinePatch.mesh:setTexture(assets.T_CastbarBackground)

  -- Colored fill
  cb.fillNinePatch = {w=cb.w,
    h=cb.h,
    borders={10.0, 10.0},
    color={1.0, 0.0, 0.0},
  }
  cb.fillNinePatch.x = cb.x-cb.fillNinePatch.w*0.5
  cb.fillNinePatch.y = cb.y-cb.fillNinePatch.h*0.5
  cb.fillNinePatch.mesh = cb:createMesh(cb.fillNinePatch.w, cb.fillNinePatch.h)
  cb.fillNinePatch.mesh:setTexture(assets.T_CastbarFill)

  -- Solid border
  cb.borderNinePatch = {w=extendedSize.w,
    h=extendedSize.h,
    borders={10.0, 10.0},
    color=nil,
  }
  cb.borderNinePatch.x = cb.x-cb.borderNinePatch.w*0.5
  cb.borderNinePatch.y = cb.y-cb.borderNinePatch.h*0.5
  cb.borderNinePatch.mesh = cb:createMesh(cb.borderNinePatch.w, cb.borderNinePatch.h)
  cb.borderNinePatch.mesh:setTexture(assets.T_CastbarBorder)

  -- Highlight
  cb.hlNinePatch = {w=castbar.w,
    h=extendedSize.h,
    borders={0.0, 20.0},
    color=nil,
  }
  cb.hlNinePatch.y = cb.y-cb.hlNinePatch.h*0.5
  cb.hlNinePatch.mesh = cb:createMesh(cb.hlNinePatch.w, cb.hlNinePatch.h)
  cb.hlNinePatch.mesh:setTexture(assets.T_CastbarHighlight)

  cb.speed = castbar.speed
  return cb
end

function castbar.drawNinePatch(_, ninePatch, clip)
  clip = clip or 1.0
  love.graphics.setShader(assets.S_NinePatchRect)
  assets.S_NinePatchRect:send("render_size", {ninePatch.w, ninePatch.h})
  assets.S_NinePatchRect:send("border_pixels", {ninePatch.borders[1], ninePatch.borders[2]})
  assets.S_NinePatchRect:send("clip_x", clip)
  if ninePatch.color then
    love.graphics.setColor(ninePatch.color)
  end
  love.graphics.draw(ninePatch.mesh, ninePatch.x, ninePatch.y)
  love.graphics.setShader()
  if ninePatch.color then
    love.graphics.setColor(1, 1, 1)
  end
end

function castbar.draw(self)
  -- Uniform for all Castbar textures
  assets.S_NinePatchRect:send("texture_size", {castbar.w, castbar.h})

  -- Map the self.value to 0-1 range
  local valueClamped = math.min(math.max(self.value, self.min), self.max)
  local t = (valueClamped - self.min) / (self.max - self.min)

  -- Highlight moves with t
  self.hlNinePatch.x = self.x - self.w * 0.5 + t * self.w - castbar.w * 0.5

  -- Draw Castbar nine-patch textures
  self:drawNinePatch(self.bgNinePatch)
  self:drawNinePatch(self.fillNinePatch, t)
  self:drawNinePatch(self.borderNinePatch)
  self:drawNinePatch(self.hlNinePatch)
end

function castbar.update(self, dt)
  self.value = self.value + self.speed * dt
  if (self.value >= self.max) then
    self.value = self.max - (self.value - self.max)
    self.speed = -self.speed
  elseif (self.value <= self.min) then
    self.value = self.min + (self.min - self.value)
    self.speed = -self.speed
  end
end

return Castbar