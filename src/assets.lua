local assets = {}

function assets.load()
  assets.T_Background = love.graphics.newImage("textures/Background1920.jpg")
  assets.T_ArcaneBlast = love.graphics.newImage("textures/ArcaneBlast.png")
  assets.T_ArcaneMissiles = love.graphics.newImage("textures/ArcaneMissiles.png")
  assets.T_AbilitySlot = love.graphics.newImage("textures/AbilitySlot.png")
  assets.T_AbilitySlotShadow = love.graphics.newImage("textures/AbilitySlotShadow.png")
  assets.T_AbilitySlotClick = love.graphics.newImage("textures/AbilitySlotClick.png")
  assets.T_AbilitySlotCooldown = love.graphics.newImage("textures/AbilitySlotCooldown.png")
  assets.T_CastbarBorder = love.graphics.newImage("textures/CastbarBorder.png")
  assets.T_CastbarBackground = love.graphics.newImage("textures/CastbarBackground.png")
  assets.T_CastbarFill = love.graphics.newImage("textures/CastbarFill.png")
  assets.T_CastbarHighlight = love.graphics.newImage("textures/CastbarHighlight.png")

  assets.F_WashYourHands_72 = love.graphics.newFont("fonts/WashYourHand.ttf", 72)

  local shaderCode = love.filesystem.read("shaders/NinePatchRect.glsl")
  assets.S_NinePatchRect = love.graphics.newShader(shaderCode)
  assets.S_NinePatchRect:send("clip_x", 1.0)
  shaderCode = love.filesystem.read("shaders/RadialFade.glsl")
  assets.S_RadialFade = love.graphics.newShader(shaderCode)
end

return assets