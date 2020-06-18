
local composer = require( "composer" )

local scene = composer.newScene()
local musicTrack
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local explosionSound = audio.loadSound( "laser.mp3" )
local explosionSound2 = audio.loadSound( "boom.mp3" )
local explosionSound3 = audio.loadSound( "boom2.mp3" )
local lives = 3
local score = 0
local died = false
 
local asteroidsTable = {}
 
local ship
local gameLoopTimer
local livesText
local scoreText

------------------------------------------------------
local backGroup
local mainGroup
local uiGroup
------------------------------------------------------

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

----------------------------------------------------------------------------------------------------------------
local function createAsteroid()
 
    local newAsteroid = display.newImageRect( mainGroup, "Астероид.png", 102, 85 )
	table.insert( asteroidsTable, newAsteroid )
	physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
	newAsteroid.myName = "asteroid"
	local whereFrom = math.random( 3 )
	    if ( whereFrom == 1 ) then
        -- From the left
        newAsteroid.x = -60
        newAsteroid.y = math.random( 500 )
	newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	elseif ( whereFrom == 2 ) then
        -- From the top
        newAsteroid.x = math.random( display.contentWidth )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end
	newAsteroid:applyTorque( math.random( -6,6 ) )
end	
-----------------------------------------------------------------------------------------------------------------
local function fireLaser()
 audio.play( explosionSound )
    local newLaser = display.newImageRect( mainGroup, "laser.png", 50, 112 )
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "laser"
	newLaser.x = ship.x
    newLaser.y = ship.y
	newLaser:toBack()
	transition.to( newLaser, { y=-40, time=1000,    onComplete = function() display.remove( newLaser )end} )
end
-----------------------------------------------------------------------------------------------------------------
local function dragShip( event )
 
    local ship = event.target
    local phase = event.phase
	    if ( "began" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( ship )
        -- Store initial offset position
        ship.touchOffsetX = event.x - ship.x
		elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX
		elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
		end
		return true 
end
-----------------------------------------------------------------------------------------------------------------
local function gameLoop()
 
    -- Create new asteroid
    createAsteroid()
	
	for i = #asteroidsTable, 1, -1 do
 local thisAsteroid = asteroidsTable[i]
 
        if ( thisAsteroid.x < -100 or
             thisAsteroid.x > display.contentWidth + 100 or
             thisAsteroid.y < -100 or
             thisAsteroid.y > display.contentHeight + 100 )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
    
    end
end
----------------------------------------------------------------------------------------------------------------
local function restoreShip()
 
    ship.isBodyActive = false
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100
 
    -- Fade in the ship
    transition.to( ship, { alpha=1, time=4000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end
    } )
end
----------------------------------------------------------------------------------------------------------------
local function endGame()
   -- composer.gotoScene( "menu", { time=800, effect="crossFade" } )
   
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end
----------------------------------------------------------------------------------------------------------------

local function listener( event )
    print( "listener called" )
	
	physics.addBody( newBonus, "dynamic", { isSensor=true } )
end
----------------------------------------------------------------------------------------------------------------
local function bonus(x,y)
 audio.play( explosionSound )
    newBonus = display.newImageRect( mainGroup, "Астероид.png", 50, 112 )
	newBonus:addEventListener("collision",newBonus)
    timer.performWithDelay( 50, listener, 1 )
    newBonus.isBullet = true
    newBonus.myName = "bonus"
	newBonus.x = x
    newBonus.y = y
	newBonus:toBack()
	physics.addBody( newBonus, "dynamic", { isSensor=true } )
	transition.to( newBonus, { y=1068, time=2500,    onComplete = function() display.remove( newBonus )end} )
	
	end
----------------------------------------------------------------------------------------------------------------
local function onCollision2( event )
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
if ( ( obj1.myName == "ship" and obj2.myName == "bonus" ) or
                 ( obj1.myName == "bonus" and obj2.myName == "ship" ) )
				 then
				  score = score + 1256
            scoreText.text = "Score: " .. score
			display.remove( obj1 )
				end 
				end
				end
----------------------------------------------------------------------------------------------------------------				
local function onCollision( event )
  local chance = 30
 local randItem = 0
 local x
  local y
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
		if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
        then
		x=obj1.x
y=obj1.y
		audio.play( explosionSound2 )
  display.remove( obj1 )
            display.remove( obj2 )
			for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
                    table.remove( asteroidsTable, i )
                    break
                end
            end
			            score = score + 100
            scoreText.text = "Score: " .. score
			randItem = math.random(100)
		if randItem<chance then
		 
		bonus(x,y)
		
		end
			elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
                 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) )
        then
		
            if ( died == false ) then
                died = true
				   lives = lives - 1
                livesText.text = "Lives: " .. lives
            
			 if ( lives == 0 ) then
                    display.remove( ship )
					timer.performWithDelay( 2000, endGame )
                else
                    ship.alpha = 0
                    timer.performWithDelay( 1000, restoreShip )
                end
				audio.play( explosionSound3 )
				end
        end
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    physics.pause()
	
	-- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	local background = display.newImageRect( backGroup, "Даптер.jpg", 2000,1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY
----------------------------------------------------------------------------------------------------------------
ship = display.newImageRect( mainGroup, "Корабль.png", 200, 120 )
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true } )
ship.myName = "ship"
----------------------------------------------------------------------------------------------------------------
livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )
livesText:setFillColor( 0, 0, 1 )
scoreText:setFillColor( 0, 0, 1 )
----------------------------------------------------------------------------------------------------------------
ship:addEventListener( "tap", fireLaser )
ship:addEventListener( "touch", dragShip )
musicTrack = audio.loadStream( "level2.mp3")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( musicTrack, { channel=1, loops=-1 } )
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		Runtime:addEventListener( "collision", onCollision2 )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )
		
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
		audio.stop( 1 )
   asteroidsTable=nil

		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
