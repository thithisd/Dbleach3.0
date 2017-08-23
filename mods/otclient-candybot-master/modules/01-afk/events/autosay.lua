--[[
  @Authors: Ben Dol (BeniS)
  @Details: Magic train event logic
]]

AfkModule.AutoSay = {}
AutoSay = AfkModule.AutoSay

function AutoSay.Event(event)
  if g_game.isOnline() then
    local player = g_game.getLocalPlayer()
    local words = AfkModule.getPanel():getChildById('AutoSayText'):getText()
    Helper.castSpell(player, words)
  end

  return Helper.safeDelay(5000, 10000)
end