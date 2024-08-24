local assets = {}

function assets.load()
  assets.T_Background = love.graphics.newImage("textures/Background1920.jpg")
  assets.T_ArcaneBlast = love.graphics.newImage("textures/ArcaneBlast.png")
  assets.T_AbilitySlot = love.graphics.newImage("textures/AbilitySlot.png")
  assets.T_AbilitySlotShadow = love.graphics.newImage("textures/AbilitySlotShadow.png")
  assets.T_AbilitySlotClick = love.graphics.newImage("textures/AbilitySlotClick.png")

  assets.F_WashYourHands_72 = love.graphics.newFont("fonts/WashYourHand.ttf", 72)
end

return assets