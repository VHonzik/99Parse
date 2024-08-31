-- Include debugger if env variable DEBUG_99PARSE is set to 1
-- ./run.sh script sets it automatically
-- Breakpoints are added by calling the object: `dgb()`
local debug = os.getenv("DEBUG_99PARSE") == "1"
if debug then
  dbg = require 'debugger'
end

local assets = require('assets')
local diagnostics = require('diagnostics')
local rendering = require('rendering')
require("abilityslot")
require("combattext")
require("castbar")
require("ability")

local game = {}

game.abilitySlots = {}
game.combatTexts = {}
game.abilities = {}
game.castingAbility = nil
game.castingAbilitySlot = nil
game.queuedAbility = nil
game.queuedAbilitySlot = nil
game.queueWindow = 400.0 / 1000.0

function game.load()
  assets.load()
  diagnostics.load()
  rendering.load()
  Castbar.load()

  -- Create ability slots and abilities
  for i = 0, 4 do
    local y = 40 + (assets.T_ArcaneBlast:getHeight() + 35) * i
    local ability = Ability:new{icon=assets.T_ArcaneBlast, index=i}
    local abilitySlot = AbilitySlot:new{x=50, y=y, ability=ability}
    table.insert(game.abilities, ability)
    table.insert(game.abilitySlots, abilitySlot)
  end

  -- Create cast bar
  game.castBar = Castbar.new{x=rendering.renderresolution.w*0.5, y=rendering.renderresolution.h*0.5, w=800, h=100} 
end

function game.update(dt)
  rendering.update()
  diagnostics.update(dt)

  -- Combat texts update
  for _, combatText in ipairs(game.combatTexts) do
    combatText:update(dt)
  end

  -- Abilities update
  for _, ability in ipairs(game.abilities) do
    ability:update(dt)
  end

  -- Castbar update
  game.castBar:update(dt)

  -- Check if we are done casting
  if game.castingAbility ~= nil and game.castBar.done then
    game.finishedCasting()
  end

  -- Destroy combat texts outside of the screen
  for i = #game.combatTexts, 1, -1 do
    if game.combatTexts[i].markedForDestruction then
      table.remove(game.combatTexts, i)
    end
  end
end

function game.startFrame()
  rendering.startFrame()
end

function game.endFrame()
  rendering.endFrame()
end

function game.draw()
  rendering.pre()
    love.graphics.draw(assets.T_Background, 0, 0)
    for _, abilitySlot in ipairs(game.abilitySlots) do
      abilitySlot:draw()
    end
    game.castBar:draw()
    for _, combatText in ipairs(game.combatTexts) do
      combatText:draw()
    end
    diagnostics.draw()
  rendering.post()
end

function game.createCombatText(text)
  local ct = CombatText.new{text=text}
  table.insert(game.combatTexts, ct)
end

function game.press(x,y)
  diagnostics.touchPressed(x, y)

  local renderX, renderY = rendering.screenToRender(x,y)
  for _, abilitySlot in ipairs(game.abilitySlots) do
    if (abilitySlot:inside(renderX, renderY)) then
      abilitySlot:press()
    end
  end
end

function game.release(x,y)
  diagnostics.touchReleased(x, y)

  local renderX, renderY = rendering.screenToRender(x,y)

  -- Find an ability slot that the touch was released on if any
  local abilitySlotReleased = nil
  local abilitySlotIndex = -1
  for i, abilitySlot in ipairs(game.abilitySlots) do
    if (abilitySlot:inside(renderX, renderY)) then
      abilitySlotReleased = abilitySlot
      abilitySlotIndex = i
      break
    end
  end

  if abilitySlotReleased == nil then
    diagnostics.releaseEmptySpace()
  else
    local ability = abilitySlotReleased.ability
    diagnostics.absilitySlotRelease(abilitySlotIndex)
    -- Already casting?
    if (game.castingAbility ~= nil) then
      -- There is pre-set window to queue next ability to cast before casting the current one is finished
      if (game.queuedAbility == nil and ability:canBeCast() and game.castBar:remainingTime() <= game.queueWindow) then
        game.queuedAbility = ability
        game.queuedAbilitySlot = abilitySlotReleased
      else
        abilitySlotReleased:release()
      end
    -- Can be cast?
    elseif (ability:canBeCast()) then
      game.cast(ability, abilitySlotReleased)
    else
      abilitySlotReleased:release()
    end
  end
end

function game.cast(ability, abilitySlot)
  game.castingAbilitySlot = abilitySlot
  game.castingAbility = ability

 -- Check cast time
  if game.castingAbility.castTime > 0.0 then
    game.castBar:startCasting(game.castingAbility.castTime)
  else
    -- Instant cast so we can trigger cooldown immediately and release
    game.castingAbility:casted(game)
    game.castingAbility:triggerCooldown()
    game.castingAbilitySlot:release()
  end

  -- Trigger global cooldown
  for _, ability in ipairs(game.abilities) do
    ability:triggerGlobalCooldown(1.0)
  end
end

function game.finishedCasting()
  game.castingAbility:triggerCooldown()
  game.castingAbilitySlot:release()
  game.castingAbility:casted(game)
  game.castingAbility = nil
  game.castingAbilitySlot = nil
  game.castBar:castingEnded()
  -- Ability queued?
  if (game.queuedAbility ~= nil) then
    -- Can it be cast at the moment?
    if game.queuedAbility:canBeCast() then
      game.cast(game.queuedAbility, game.queuedAbilitySlot)
    -- Cannot be cast so just release the slot
    else
      game.queuedAbilitySlot:release()
    end

    game.queuedAbility = nil
    game.queuedAbilitySlot = nil
  end
end



return game