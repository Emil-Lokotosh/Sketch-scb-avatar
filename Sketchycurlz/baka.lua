models.player.Head:setPrimaryTexture("SKIN")
models.player.Body:setPrimaryTexture("SKIN")
models.player.RightArm:setPrimaryTexture("SKIN")
models.player.LeftArm:setPrimaryTexture("SKIN")
models.player.LeftArm:setPrimaryTexture("SKIN")
models.player.RightLeg:setPrimaryTexture("SKIN")
models.player.LeftLeg:setPrimaryTexture("SKIN")
models.player:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

function pings.hideWings(bool)
  vanilla_model.ELYTRA:setVisible(bool)
end
function pings.hideHeadphones(bool)
  models.new_succubits.Headphones:setVisible(not bool)
 end
 function pings.hideBands(bool)
  models.new_succubits.root.RightArm.cube:setVisible(not bool)
  models.new_succubits.root.LeftArm.cube:setVisible(not bool)
 end
  function pings.hideArmor(bool)
    vanilla_model.ARMOR:setVisible(bool)
  end
  function pings.hideModel(bool)
    vanilla_model.PLAYER:setVisible(not bool)
    models.player:setVisible(bool)
  end
  local mainPage=action_wheel:newPage()
  mainPage:newAction():title("Show Elytra"):toggleTitle("Hide Elytra"):item("minecraft:elytra"):onToggle(pings.hideWings)
  mainPage:newAction():title("Show Armor"):toggleTitle("Hide Armor"):item("minecraft:iron_chestplate"):onToggle(pings.hideArmor)
  mainPage:newAction():title("Override Model"):toggleTitle("Default Model"):item("minecraft:player_head"):onToggle(pings.hideModel)
  mainPage:newAction():title("Hide Headphones"):toggleTitle("Show Headphones"):item("minecraft:jukebox"):onToggle(pings.hideHeadphones)
  mainPage:newAction():title("Hide Bands"):toggleTitle("Show Bands"):item("minecraft:pink_banner"):onToggle(pings.hideBands)
  
  
  action_wheel:setPage(mainPage)