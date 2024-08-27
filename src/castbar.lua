local assets = require('assets')

local castbar = {}
castbar.__index = castbar
castbar.x = 0
castbar.y = 0

Castbar = castbar

function castbar.load()
  castbar.w = assets.T_CastbarBorder:getWidth()
  castbar.h = assets.T_CastbarBorder:getHeight()
end

function castbar.createMesh(self)
  local vertices = {
		{
			-- top-left corner
			0, 0, -- position of the vertex
			0, 0, -- texture coordinate at the vertex position
		},
		{
			-- top-right corner
			self.w, 0,
			1, 0, -- texture coordinates are in the range of [0, 1]
			1, 1, 1
		},
		{
			-- bottom-right corner
			self.w, self.h,
			1, 1,
		},
		{
			-- bottom-left corner
			0, self.h,
			0, 1
		},
	}

  return love.graphics.newMesh(vertices, "fan")
end

function castbar.new(initialValues)
  local castbarInstance = initialValues or {}
  setmetatable(castbarInstance, castbar)

  castbarInstance.drawMesh = castbarInstance:createMesh()
  return castbarInstance
end

function castbar.draw(self)
  love.graphics.setShader(assets.S_NinePatchRect)
    assets.S_NinePatchRect:send("texture_size", {castbar.w, castbar.h})
    assets.S_NinePatchRect:send("render_size", {self.w, self.h})
    local position = {x=self.x-self.w*0.5, y=self.y-self.h*0.5}

    self.drawMesh:setTexture(assets.T_CastbarBackground)
      love.graphics.draw(self.drawMesh, position.x, position.y)
    love.graphics.setColor(1, 0, 0)
      self.drawMesh:setTexture(assets.T_CastbarFill)
        love.graphics.draw(self.drawMesh, position.x, position.y)
    love.graphics.setColor(1, 1, 1)
    self.drawMesh:setTexture(assets.T_CastbarBorder)
      love.graphics.draw(self.drawMesh, position.x, position.y)
  love.graphics.setShader()
end

return Castbar