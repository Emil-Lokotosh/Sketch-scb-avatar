local isFlying=false
function pings.setFlying(flying)
  isFlying=flying
end
if host:isHost() then
  function events.tick()
    local _flying = host:isFlying()
    if isFlying~=_flying then
      pings.setFlying(_flying)
    end
  end
end
function events.tick()
    if player:getPose()=="FALL_FLYING" then
        animations.new_succubits.elytra_flying:play()
        
    end 
    if isFlying then
        animations.new_succubits.elytra_flying:play()
        animations.new_succubits.creative_flight:play()
        animations.new_succubits.no_creative_flight:stop()
        models.new_succubits.root.Body.wingsleft.bone6.invis2:setVisible(false)
        models.new_succubits.root.Body.wingsright.bone.invis1:setVisible(false)
        models.new_succubits.root.Body.wingsright.bone.bone2.invis3:setVisible(false)
        models.new_succubits.root.Body.wingsleft.bone6.bone7.invis4:setVisible(false)
    else
        animations.new_succubits.creative_flight:stop()
        animations.new_succubits.no_creative_flight:play()
        models.new_succubits.root.Body.wingsleft.bone6.invis2:setVisible(true)
        models.new_succubits.root.Body.wingsright.bone.invis1:setVisible(true)
        models.new_succubits.root.Body.wingsright.bone.bone2.invis3:setVisible(true)
        models.new_succubits.root.Body.wingsleft.bone6.bone7.invis4:setVisible(true)
    end 
    
end