require("ability.ability")
local assets = require("assets")

ArcaneBlast = Ability:new()
ArcaneBlast.__index = ArcaneBlast
ArcaneBlast.displayName = "Arcane Blast"

-- Mana: 22143
-- Base mana: 3268
-- 1st cast: 228
-- 2nd cast: 476/692
ArcaneBlast.manaCost = 230

function ArcaneBlast.load()
  ArcaneBlast.icon = assets.T_ArcaneBlast
end

return ArcaneBlast