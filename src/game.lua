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

local game = {}

game.abilitySlots = {}
game.combatTexts = {}

function game.load()
  assets.load()
  diagnostics.load()
  rendering.load()
  Castbar.load()

  -- Create ability slots and register them to render
  for i = 0, 4 do
    local y = 40 + (assets.T_ArcaneBlast:getHeight() + 35) * i
    local abilitySlot = AbilitySlot:new{icon=assets.T_ArcaneBlast, x=50, y=y}
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

  -- Ability slots update
  for _, abilitySlot in ipairs(game.abilitySlots) do
    abilitySlot:update(dt)
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
  diagnostics.touchpressed(x, y)

  local renderX, renderY = rendering.screenToRender(x,y)
  for _, abilitySlot in ipairs(game.abilitySlots) do
    if (abilitySlot:inside(renderX, renderY)) then
      abilitySlot:press()
    end
  end
end

function game.release(x,y)
  diagnostics.touchreleased(x, y)

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
    diagnostics.spellrelease(abilitySlotIndex)
    game.createCombatText(""..abilitySlotIndex)
  end

  -- Trigger cooldowns
  if abilitySlotReleased ~= nil then
    for _, abilitySlot in ipairs(game.abilitySlots) do
      if abilitySlot == abilitySlotReleased then
        abilitySlotReleased:triggerCooldown(0.5 + math.random() * 10.0)
      else
        abilitySlot:triggerCooldown(1.0)
      end
    end
  end
  
  -- Mark and pressed ability slots as released now
  for _, abilitySlot in ipairs(game.abilitySlots) do
    abilitySlot:release()
  end
end



return game