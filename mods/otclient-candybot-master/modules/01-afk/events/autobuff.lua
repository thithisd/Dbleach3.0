--[[
  @Authors: Ben Dol (BeniS)
  @Details: Magic train event logic
]]

AfkModule.AutoBuff = {}
AutoBuff = AfkModule.AutoBuff

function AutoBuff.Event(event)
  if g_game.isOnline() then
    local player = g_game.getLocalPlayer()
    local words = SupportModule.getPanel():getChildById('AutoBuffText'):getText()
    Helper.castSpell(player, words)
  end

  return Helper.safeDelay(60000, 61000)
end