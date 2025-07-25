
--███████╗ ██████╗ ██╗   ██╗██╗███████╗██╗  ██╗██╗   ██╗███████╗     █████╗ ██████╗ ██╗
--██╔════╝██╔═══██╗██║   ██║██║██╔════╝██║  ██║╚██╗ ██╔╝██╔════╝    ██╔══██╗██╔══██╗██║
--███████╗██║   ██║██║   ██║██║███████╗███████║ ╚████╔╝ ███████╗    ███████║██████╔╝██║
--╚════██║██║▄▄ ██║██║   ██║██║╚════██║██╔══██║  ╚██╔╝  ╚════██║    ██╔══██║██╔═══╝ ██║
--███████║╚██████╔╝╚██████╔╝██║███████║██║  ██║   ██║   ███████║    ██║  ██║██║     ██║
--╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝
----------------------------------------------------------------------------------------

-- Author: Squishy
-- Discord tag: mrsirsquishy

-- Version: 0.195
-- Legal: Do not Redistribute without explicit permission.

-- Don't be afraid to ask me for help, be afraid of not giving me enough info to help

local squapi = {}



-- Control Variables
-- these variables can be changed within your script to control certain features of squapi
-- to do so, call squapi.[variable name] = [what you want]
-- within your script(do not modify these within squapi itself)

--set to false to disable blinking, set to true to enable blinking
squapi.doBlink = true

--controls the scale of each eye. good for emotes.
squapi.eyeScale = 1

--how much the tails wag. increase this value to make the tails waggier. good for emotes.
squapi.wagStrength = 1

--CROUCH ANIMATION
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- crouch:		the animation to play when you crouch. Make sure this animation is on "hold on last frame" and override. 
-- *uncrouch:	the animation to play when you uncrouch. make sure to set to "play once" and set to override. If it's just a pose with no actual animation, than you should leave this blank.

function squapi.crouch(crouch, uncrouch) 
	local oldstate = "STANDING"
	function events.render()
		local pose = player:getPose()
		if pose == "CROUCHING" then
			if uncrouch ~= nil then
				uncrouch:stop()
			end
			crouch:play()
		elseif oldstate == "CROUCHING" then
			crouch:stop()
			if uncrouch ~= nil then
				uncrouch:play()
			end
		end
		
		oldstate = pose
	end
end

-- SMOOTH HEAD
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 			the head element that you wish to effect
-- *keeporiginalheadpos: when true(automatically true) the heads position will change like normally, set to false to disable.
-- IMPORTANT: for this to work you need to remove the "Head" element, as if it is there it will continue to use the minecraft head rotation. renaming it to "head" will work fine.
function squapi.smoothHead(element, keeporiginalheadpos)
	if keeporiginalheadpos == nil then keeporiginalheadpos = true end
	local mainheadrot = vec(0, 0, 0)
	function events.render(delta, context)
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		mainheadrot[1] = mainheadrot[1] + (headrot[1] - mainheadrot[1])/12
		mainheadrot[2] = mainheadrot[2] + (headrot[2] - mainheadrot[2])/12
		mainheadrot[3] = mainheadrot[2]/5
		element:setOffsetRot(mainheadrot)
		if keeporiginalheadpos then 
			element:setPos(-vanilla_model.HEAD:getOriginPos()) 
		end
	end
end

-- SMOOTH HEAD WITH NECK
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element:	 			the head element
-- element2: 			the neck element
-- *keeporiginalheadpos: when true(automatically true) the heads position will change like normally, set to false to disable.
function squapi.smoothHeadNeck(element, element2, keeporiginalheadpos)
	if keeporiginalheadpos == nil then keeporiginalheadpos = true end
	local mainheadrot = vec(0, 0, 0)
	function events.render(delta, context)
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		mainheadrot[1] = mainheadrot[1] + (headrot[1] - mainheadrot[1])/12
		mainheadrot[2] = mainheadrot[2] + (headrot[2] - mainheadrot[2])/12
		mainheadrot[3] = mainheadrot[2]/5

		element:setOffsetRot(mainheadrot[1]*0.6,mainheadrot[2]*0.7,mainheadrot[3])
    	element2:setOffsetRot(mainheadrot[1]*0.4,mainheadrot[2]*0.2,0)
		if keeporiginalheadpos then 
			element2:setPos(-vanilla_model.HEAD:getOriginPos()) 
		end
	end
end



-- MOVING EYES
--guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element:	 		the eye element that is going to be moved, each eye is seperate.
-- *leftdistance: 	the distance from the eye to it's leftmost posistion
-- *rightdistance: 	the distance from the eye to it's rightmost posistion
-- *updistance: 	the distance from the eye to it's upmost posistion
-- *downdistance: 	the distance from the eye to it's downmost posistion

function squapi.eye(element, leftdistance, rightdistance, updistance, downdistance, switchvalues)
	local switchvalues = switchvalues or false
	local left = leftdistance or .25
	local right = rightdistance or 1.25
	local up = updistance or 0.5
	local down = downdistance or 0.5
	
	function events.render(delta, context)
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		if headrot[2] > 50 then headrot[2] = 50 end
		if headrot[2] < -50 then headrot[2] = -50 end
		local x = -squapi.parabolagraph(-50, -left, 0,0, 50, right, headrot[2])
		local y = squapi.parabolagraph(-90, -down, 0,0, 90, up, headrot[1])
		
		--prevents any eye shenanigans
		if x > left then x = left end
		if x < -right then x = -right end
		if y > up then y = up end
		if y < -down then y = down end

		if switchvalues then
			element:setPos(0,y,-x)
		else
			element:setPos(x,y,0)
		end
		element:setOffsetScale(squapi.eyeScale,squapi.eyeScale,squapi.eyeScale)
	end
end	

--BLINK
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- animation: 			the blink animation to play
-- *chancemultipler:	higher values make blinks less likely to happen, lower values make them more common.
function squapi.blink(animation, chancemultipler)
	local blinkchancemultipler = chancemultipler or 1
	function events.render(delta, context)
		if math.random(0, 200 * blinkchancemultipler) == 1 and animation:isStopped() and squapi.doBlink then
			animation:play()
		end
	end	
end


--TAIL PHYSICS!!
--guide:(note if it has a * that means you can leave it blank to use reccomended settings)
--tailsegs:				this is an ARRAY of each element/segment in your tail. for example: local array = {element, element2, etc.}
--*intensity:			how intensly the tail moves when you rotate/move. Reccomend 2
--*tailintesnityY:		how much the tail moves up and down
--*tailintensityX:		how much the tail moves side to side
--*tailYSpeed:			how fast the tail moves up and down
--*tailXSpeed:			how fast the tail moves side to side
--*tailVelBend:			how much the tail bends when you move forward/back. positive values bend up, negative values bend down.
--*initialTailOffset:	how much to offset the tails animation initially. If you have multiple tails I reccomend using this to slightly offset each. so tail 1 offset by 0, tail 2 offset by 0.5, etc. set 0 to ignore
--*segOffsetMultipler:	how much each segment is offset from the last. 1 is reccomended.
--*tailStiff:			how stiff the tails are
--*tailBounce:			how bouncy the tails are
--*tailFlyOffset		what rotation the tail should have when flying(elytra or riptide) normally 0. Example would be if your tail sticks out when flying, set to 75 to rotate the tail 75 deg down.
--*downLimit:			the max distance the tail will bend down
--*upLimit:				the max distance the tail will bend up

--reccomended function:
--squapi.tails(tailsegs, 2, 15, 5, 2, 1.2, 0, 0, 1, .0005, .06, 0, nil, nil)
function squapi.tails(tailsegs, intensity, tailintensityY, tailintensityX, tailYSpeed, tailXSpeed, tailVelBend, initialTailOffset, segOffsetMultipler, tailStiff, tailBounce, tailFlyOffset, downLimit, upLimit)
	local intensity = intensity or 1
	local tailintensity = tailintensityY or 0
	local tailintensityx = tailintensityX or 12
	local tailyspeed = tailYSpeed or 2
	local tailxspeed = tailXSpeed or 1.2
	local tailvelbend = tailVelBend or 0
	local initialTailOffset = initialTailOffset or 0
	local tailstiff = tailStiff or .005
	local tailbounce = tailBounce or .05
	local tailflyoffset = tailFlyOffset or 0
	local tailrot, tailvel, tailrotx, tailvelx = {}, {}, {}, {}
	local segoffsetmultipler = segOffsetMultipler or 1
	local downLimit = downLimit or 10
	local upLimit = upLimit or 15
    
	for i = 1, #tailsegs do
        tailrot[i], tailvel[i], tailrotx[i], tailvelx[i] = 0, 0, 0, 0
    end
	
	local currentbodyrot = 0
	local oldbodyrot = 0
	local bodyrotspeed = 0
	function events.tick()
		oldbodyrot = currentbodyrot
		currentbodyrot = player:getBodyYaw()
		bodyrotspeed = currentbodyrot-oldbodyrot
		if bodyrotspeed > 20 then bodyrotspeed = 20
		elseif	bodyrotspeed < -20 then bodyrotspeed = -20 end
	end
	
	function events.render(delta, context)
		local time = world.getTime() + delta
		local vel = squapi.getForwardVel()
		local yvel = squapi.yvel()
		--local svel = squapi.getSideVelocity()
		local tailintensity = tailintensity-math.abs((yvel*60))-vel*60
		local pose = player:getPose()
		for i, tail in ipairs(tailsegs) do
			local tailtargety = math.sin((time * tailxspeed)/10 - (i * segoffsetmultipler) + initialTailOffset) * tailintensity
			local tailtargetx = math.sin((time * tailyspeed * (squapi.wagStrength))/10 - (i)) * tailintensityx * squapi.wagStrength

			tailtargetx = tailtargetx + bodyrotspeed*intensity*0.5-- + svel*intensity*40
			tailtargety = tailtargety + yvel * 20 * intensity - vel*intensity*50*tailvelbend
			
			
			

			if downLimit ~= nil then
				if tailtargety > downLimit then tailtargety = downLimit end
			end
			if upLimit ~= nil then
				if tailtargety < -upLimit then tailtargety = -upLimit end
			end

			if i == 1 then
				if pose == "FALL_FLYING" or pose == "SWIMMING" or player:riptideSpinning() then
					tailtargety = tailflyoffset
				end	
			end

			tailrot[i], tailvel[i] = squapi.bouncetowards(tailrot[i], tailtargety, tailstiff, tailbounce, tailvel[i])
			tailrotx[i], tailvelx[i] = squapi.bouncetowards(tailrotx[i], tailtargetx, tailstiff, tailbounce, tailvelx[i])
			
			if pose ~= "SLEEPING" then 
				tail:setOffsetRot(tailrot[i], tailrotx[i], 0)
			end
		end
	end
	
end



--BOUNCY EARS
--guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 		the ear element that you want to affect(models.[modelname].path)
-- *element2: 		the second element you'd like to use(second ear), set to nil or leave empty to ignore
-- *doearflick:		reccomended true. This adds the random chance for the ears to do a "flick" animation, set to false to disable.
-- *earflickchance:	how rare a flick should be. high values mean less liklihood, low values mean high liklihood.(200 reccomended)
-- *rangemultiplier at normal state of 1 the ears rotate from -90 to 90, this range will be multiplied by this, so a value of 0.5 would half the range
-- *earoffset:		how the ears are normally offset. set to 0 for them to normally point up, or set to 45 to have the ears be angled by 45 normally.
-- *bendstrength: 	how strong the ears bend when you move(jump, fall, run, etc.)
-- *earstiffness: 	how stiff the ears movement is(0-1)
-- *earbounce: 		how bouncy the ears are(0-1)

function squapi.ear(element, element2, doearflick, earflickchance, rangemultiplier, earoffset, bendstrength, earstiffness, earbounce)
	if doearflick == nil then doearflick = true end
	local earflickchance = earflickchance or 200
	local element2 = element2 or nil
	local bendstrength = bendstrength or 0.7
	local earstiffness = earstiffness or 0.025
	local earbounce = earbounce or 0.1
	local earoffset = earoffset or 0
	local rangemultiplier = rangemultiplier or 0.5
	
	local eary = squapi.bounceObject:new()
	local earx = squapi.bounceObject:new()
	local earx2 = squapi.bounceObject:new()
	
	local oldpose = "STANDING"
	function events.render(delta, context)
		local vel = squapi.getForwardVel()
		local yvel = squapi.yvel()
		local svel = squapi.getSideVelocity()
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		
		local bend = bendstrength
		if headrot[1] < -22.5 then bend = -bend end
		
		--moves when player crouches
		local pose = player:getPose()
		if pose == "CROUCHING" and oldpose == "STANDING" then
			eary.vel = eary.vel + 3 * bendstrength
		elseif pose == "STANDING" and oldpose == "CROUCHING" then
			eary.vel = eary.vel - 3 * bendstrength
		end
		oldpose = pose

		--y vel change
		eary.vel = eary.vel + yvel * bend
		--x vel change
		eary.vel = eary.vel + vel * bend * 1.5

		if doearflick then
			if math.random(0, earflickchance) == 1 then
				if math.random(0, 1) == 1 then
					earx.vel = earx.vel + 50
				else
					vel = earx2.vel - 50
				end
			end
		end


		local rot1 = eary:doBounce(headrot[1] * rangemultiplier, earstiffness, earbounce)
		local rot2 = earx:doBounce(headrot[2] * rangemultiplier - svel*150*bendstrength, earstiffness, earbounce)
		local rot2b = earx2:doBounce(headrot[2] * rangemultiplier - svel*150*bendstrength, earstiffness, earbounce)
		local rot3 = rot2/4
		local rot3b = rot2b/4

		element:setOffsetRot(rot1 + earoffset, rot2/4, rot3)
		if element2 ~= nil then 
			element2:setOffsetRot(rot1 + earoffset, rot2b/4, rot3b) 
		end
	end
end

--BOUNCY BEWB PHYSICS
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 	 the bewb element that you want to affect(models.[modelname].path)
-- *doidle: 	 the bewb will slowly move idly in a sort of breathing animation, normally true, set this to false to disable that.
-- *bendability: how much it should bend when you move. reccomended 2, if you're bored set to 10
-- *stiff: 		 how stiff they are(0-1)
-- *bounce: 	 how bouncy they are(0-1)
function squapi.bewb(element, doidle, bendability, stiff, bounce)
	local doidle = doidle or true
	local stiff = stiff or 0.025
	local bounce = bounce or 0.06
	local bendability = bendability or 2
	local bewby = squapi.bounceObject:new()
	local target = 0

	local oldpose = "STANDING"
	function events.Render(delta, context)
		local vel = squapi.getForwardVel()
		local yvel = squapi.yvel()
		local worldtime = world.getTime() + delta

		if doidle then target = math.sin(worldtime/8)*2*bendability end

		--physics when crouching/uncrouching
		local pose = player:getPose()
		if pose == "CROUCHING" and oldpose == "STANDING" then
			bewby.vel = bewby.vel + bendability
		elseif pose == "STANDING" and oldpose == "CROUCHING" then
			bewby.vel = bewby.vel - bendability
		end
		oldpose = pose

		--physics when moving
		bewby.vel = bewby.vel - yvel/2 * bendability
		bewby.vel = bewby.vel - vel/3 * bendability

		element:setOffsetRot(bewby:doBounce(target, stiff, bounce),0,0)
	end
end



-- Easy-use Animated Texture.
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 		the part of your model who's texture will be aniamted
-- numberofframes: 	the number of frames
-- framepercent:	what percent width/height the uv takes up of the whole texture. for example: if there is a 100x100 texture, and the uv is 20x20, this will be .20
-- *slowfactor: 	increase this to slow down the animation. 
-- *vertical:		set to true if you'd like the animation frames to go down instead of right.
function squapi.animateTexture(element, numberofframes, framepercent, slowfactor, vertical)
	vertical = vertical or false
	frameslowfactor = slowfactor or 1
	function events.tick()
		local time = world.getTime()
		local frameshift = math.floor(time/frameslowfactor)%numberofframes*framepercent
		if vertical then element:setUV(0, frameshift) else element:setUV(frameshift, 0) end
	end
end

-- Change position of first person hand
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element:	the actual hand element to change
-- *x: 		the x change
-- *y: 		the y change
-- *z: 		the z change
function squapi.setFirstPersonHandPos(element, x, y, z)
	x = x or 0
	y = y or 0
	z = z or 0
	function events.Render(delta, context)
		if context == "FIRST_PERSON" then 
			element:setPos(x, y, z)
		else 
			element:setPos(0, 0, 0) end
	end
end

--CENTAUR PHYSICS
-- guide:
-- centaurbody: the group of the body that contains all parts of the actual centaur part of the body, pivot should be placed near the connection between body and centaur body
-- frontlegs: 	the group that contains both front legs
-- backlegs: 	the group that contains both back legs
function squapi.centuarPhysics(centaurbody, frontlegs, backlegs)
	squapi.cent = squapi.bounceObject:new()
	
	function events.render(delta, context)
		local yvel = squapi.yvel()
		local pose = player:getPose()
		
		if pose == "FALL_FLYING" or pose == "SWIMMING" or (player:isClimbing() and not player:isOnGround()) or player:riptideSpinning() then
			
			centaurbody:setRot(80, 0, 0)
			backlegs:setRot(-50, 0, 0)
			frontlegs:setRot(-50, 0, 0)
		else	
			centaurbody:setRot(squapi.cent.pos, 0, 0)
			backlegs:setRot(squapi.cent.pos*1.5, 0, 0)
			frontlegs:setRot(-squapi.cent.pos*3.5, 0, 0)
		end
		local target = yvel * 40
		if target < -30 then target = -30 end
		squapi.cent:doBounce(target, 0.01, .2)
	end
end

-- USEFUL CALLS ------------------------------------------------------------------------------------------

-- returns how fast the player moves forward, negative means backward
function squapi.getForwardVel()
	return player:getVelocity():dot((player:getLookDir().x_z):normalize())
end

-- returns y velocity
function squapi.yvel()
	return player:getVelocity()[2]
end

-- returns how fast player moves sideways, negative means left
function squapi.getSideVelocity()
	return player:getVelocity():dot((player:getLookDir().z_x):normalize())
end


--functions that are made for use through this code, or personal use. Not meant to be used outside but if you know what you're doing go ahead. 
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-- Linear graph stuff
function squapi.lineargraph(x1, y1, x2, y2, t)
	local slope = (y2-y1)/(x2-x1)
	local inter = y2 - slope*x2
	return slope*t + inter
end

--Parabolic graph stuff
function squapi.parabolagraph(x1, y1, x2, y2, x3, y3, t)
    local denom = (x1 - x2) * (x1 - x3) * (x2 - x3)
    
	local a = (x3 * (y2 - y1) + x2 * (y1 - y3) + x1 * (y3 - y2)) / denom
    local b = (x3^2 * (y1 - y2) + x2^2 * (y3 - y1) + x1^2 * (y2 - y3)) / denom
    local c = (x2 * x3 * (x2 - x3) * y1 + x3 * x1 * (x3 - x1) * y2 + x1 * x2 * (x1 - x2) * y3) / denom

    -- returns y based on t
    return a * t^2 + b * t + c
end

--smooth bouncy stuff
squapi.bounceObject = {}
function squapi.bounceObject:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.vel = 0
	self.pos = 0
	return o
end	
function squapi.bounceObject:doBounce(target, stiff, bounce)
	local target = target or 2
	local dif = target - self.pos
	self.vel = self.vel + ((dif - self.vel * stiff) * stiff)
	self.pos = (self.pos + self.vel) + (dif * bounce)
	return self.pos
end

--1: dif is the distance between current and target
--2: lower vals of stiff mean that it is slower(lags behind more) 
--   This means slower acceleration. This acceleration is then added to vel.
--4: apply velocity to the current value, as well as adding bounce factor.
--5: returns the new value, as well as the velocity at that moment.

--Paramter details:
-- current: the current value(like position, rotation, etc.) of object that will be moved.
-- target: the target value - this is what it will bounce towards
-- stiff: how stiff it should be(between 0-1)
-- bounce: how bouncy it should be(between 0-1)
-- vel: the current velocity of the current value.

-- Returns the new position and new velocity.
function squapi.bouncetowards(current, target, stiff, bounce, vel)	
	local dif = target - current
	vel = vel + ((dif - vel * stiff) * stiff)
	current = (current + vel) + (dif * bounce)
	return current, vel
end

--THE JUNKYARD. Old, unfinished, or scrapped stuff. Don't use these, but you can climb around I guess
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


-- Repairs incorrect head rotations
function squapi.exorcise(headrot)
	-- prevents demonic possesion
	while(headrot[2] > 90)
	do
		headrot[2] = headrot[2] - 360
	end
	while(headrot[2] < -90)
	do
		headrot[2] = headrot[2] + 360
	end

	while(headrot[1] > 100)
	do
		headrot[1] = headrot[1] - 360
	end
	while(headrot[1] < -100)
	do
		headrot[1] = headrot[1] + 360
	end
	return headrot
end


-- How to use
-- inside of events.render(delta, context) is where this function goes(squapi.earhysics())
-- the input paramaters:
-- element: 				the model path of the ear
-- earvel1 and earvel2: 	the input velocity variables to store the ears velocity
-- add two variables to your script, perferable called earvel1 and earvel2(though you can name them whatever), and set them to 0
-- call the function as: earvel1, earvel2 = squapi.earphysics(paramter stuff) - or whatever earvel1 and earvel2 are called
-- bendstrength: 			how strong the ears bend when moving
-- earstiffness:			how stiff the ears are
-- earbounce: 				how bouncy the ears are

-- if you have more than one ear with the same setting, instead of givving each their own earvel variables, just call the function as normal without the earvel1, earvel2 = 
function squapi.earphysics(element, earvel1, earvel2, bendstrength, earstiffness, earbounce)
	local vel = player:getVelocity():dot((player:getLookDir().x_z):normalize())
	local yvel = player:getVelocity()[2]
	local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180

	earrot[1], earvel1 = squapi.bouncetowards(earrot[1], headrot[1], earstiffness, earbounce, earvel1)
	earrot[2], earvel2 = squapi.bouncetowards(earrot[2], headrot[2], earstiffness, earbounce, earvel2)
	earrot[3] = earrot[2]/3

	local bend = bendstrength
	if headrot[1] < -22.5 then bend = -bend end

	--y vel change
	earvel1 = earvel1 + yvel * bend
	--x vel change
	earvel1 = earvel1 + vel * bend * 1.5
	
	--applies rotations to ears
	element:setRot(earrot[1] + 45, earrot[2]/4, earrot[3])
	return earvel1, earvel2
end



return squapi