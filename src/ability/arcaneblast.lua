require("ability.ability")
local assets = require("assets")

ArcaneBlast = Ability:new()
ArcaneBlast.__index = ArcaneBlast

function ArcaneBlast.load()
  ArcaneBlast.icon = assets.T_ArcaneBlast
end

return ArcaneBlast