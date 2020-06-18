require "init"
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
local bonusSound = audio.loadSound( "NFF-jump.wav" )
local hp1
local lives = 3
local score = 0
local died = false
 
local asteroidsTable = {}
local hpTable = {"hp1.png", "hp2.png", "hp3.png", "hp4.png", "hp5.png", "hp6.png", "hp7.png"}
 
local ship
local gameLoopTimer
local livesText
local scoreText
local waveText
local win = false
local waveCount=1
local gameLoopTimer2
local gameLoopTimer3

local bossHP = 1
local newHP

local shipDamage = 1
local threeLasers = false

------------------------------------------------------
local backGroup
local mainGroup
local uiGroup
------------------------------------------------------



local objectSheet = graphics.newImageSheet( "eships1.png", enemyOptions )
local hpSheet = graphics.newImageSheet( "Huds.png", hpOptions )
-------------------------------------------------------
local function waveTextClear()
waveText.text=""
end
------------------------------------------------------
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
	print("This will get called 5seconds after block[old] transition...")
end
local function setWaveText()
waveText.text = "Wave " .. waveCount
end
local function endGame()
   -- composer.gotoScene( "menu", { time=800, effect="crossFade" } )


    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
	
end
----------------------------------------------------------------------------------------------------------------
--класс
Asteroid= {}
--тело класса
function Asteroid:new(name)
 -- свойства
    local private = {}
        --приватное свойство
        private.hp = 4
		private.img = ""
		private.asteroidsTable = {}

		
   
    local public= {}
	--публичное свойство
        public.name = name or "Ship"
        

	--публичные методы
		function public:create()
		local newAsteroid = display.newSprite( mainGroup, objectSheet,sequenceData, 85, 112 )
		physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.3 } )		
		newAsteroid.yScale=(112/555) * -1
		newAsteroid.xScale=85/419	
		newAsteroid:setSequence("normal")
		newAsteroid:play()
		newAsteroid.x = math.random( 500 )
        newAsteroid.y = math.random( 500 )
		newAsteroid.myName = "asteroid"
		end
		
		
    function public:getName()
        return self.name 
    end
	
	function public:setHP()
	private.hp = private.hp - 1
	end
	
	function public:getHP()
	return private.hp
	end

	
	

    --чистая магия!
    setmetatable(public, self)
    self.__index = self; return public
end

--создаем экземпляр класса

----------------------------------------------------------------------------------------------------------------
local function createAsteroid(x)  --Создание врага
 if ( x~= 1 ) then
    vasya = Asteroid:new("asteroid")

--обращаемся к свойству
print(vasya.name)    --> результат: Вася

--обращаемся к методу
print(vasya:getName())  --> результат: Вася
vasya:create()
	table.insert( asteroidsTable, vasya )
	

	
	--newAsteroid.myName = "asteroid"
	--newAsteroid.enemyHP = 4
	    
        -- From the left

	--newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	
    
	    elseif ( x==1 ) then
        -- From the right
	    local newAsteroid = display.newImageRect( mainGroup, "Ship1.png", 255, 336 )
	table.insert( asteroidsTable, newAsteroid )
	physics.addBody( newAsteroid, "dynamic", { radius=112, bounce=0.3 } )
	newAsteroid.myName = "boss"
	
        newAsteroid.x = math.random( 500 )
        newAsteroid.y =  250 
	newAsteroid.yScale = -1
	waveText:toBack()	
        --newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end
	
	--newAsteroid:applyTorque( math.random( -6,6 ) )
end	
-----------------------------------------------------------------------------------------------------------------
local function pLaser(dir, angle)
audio.play( explosionSound )
    local newLaser = display.newImageRect( mainGroup, "core.png", 50, 112 )
	newLaser:rotate(angle)
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "laser"
	newLaser.x = ship.x
    newLaser.y = ship.y
	newLaser:toBack()
	transition.to( newLaser, { y=-40, x=dir,time=1000,    onComplete = function() display.remove( newLaser )end} )
end

local function fireLaser(dir) -- Выстрел игрока
if threeLasers==false then
 pLaser(ship.x,0)
 else
 
 pLaser(ship.x*0.45,-15)
 pLaser(ship.x/0.65,15)
 pLaser(ship.x,0)
 end
end



-----------------------------------------------------------------------------------------------------------------
 local function dragShip( event )  -- Перемещение игрока

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
local size
local function createLoop(times,size) 
local myClosure = function() return createAsteroid(size) end
	 timer.performWithDelay( 250, myClosure, times )
	 
	waveCount=waveCount+1	
end
-----------------------------------------------------------------------------------------------------------------
local function gameLoop()  -- Создание волны врагов


	if waveCount==1 and #asteroidsTable==0
	then     
createLoop(5,0)
	
	elseif waveCount==2 and #asteroidsTable==0
		then  
setWaveText()		
	timer.performWithDelay( 3000, waveTextClear, 1 )		
	createLoop(10,0)

		elseif waveCount==3 and #asteroidsTable==0
		then  
		setWaveText()	
	timer.performWithDelay( 3000, waveTextClear, 1 )		
	createLoop(15,0)
	
		elseif waveCount==4 and #asteroidsTable==0
		then 
		waveText.text="BOSS"	
			
newHP = display.newImageRect( mainGroup, hpTable[1], 200, 20 )	
	newHP.x=display.contentCenterX
	newHP.y=130
	newHP:toBack()
		createLoop(1,1)
	timer.performWithDelay( 800, waveTextClear, 1 )
	
elseif #asteroidsTable==0 and waveCount>4 then

display.remove( ship )
 endGame()
end	
	
end
-------------------------------------------------------------------------------------------------------------
local function gameLoop2() -- Таймер для рандомного перемещения врагов
if #asteroidsTable~=0 then
i=math.random(#asteroidsTable)
  transition.to( asteroidsTable[i], { x=math.random(768), time=1000})
i=math.random(#asteroidsTable)
  transition.to( asteroidsTable[i], { x=math.random(768), time=1000})
i=math.random(#asteroidsTable)
  transition.to( asteroidsTable[i], { x=math.random(768), time=1000})
i=math.random(#asteroidsTable)
  transition.to( asteroidsTable[i], { x=math.random(768), time=1000})
 elseif #asteroidsTable==0 then
 gameLoop()
 end
end

local function enemyLaser()   -- Выстрелы противников
if #asteroidsTable~=0 then
i=math.random(#asteroidsTable)


 audio.play( explosionSound )
    local newLaser = display.newImageRect( mainGroup, "core.png", 50, 112 )
	newLaser.yScale=-1
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "laser2"
	newLaser.x = asteroidsTable[i].x
    newLaser.y = asteroidsTable[i].y
	newLaser:toBack()
	transition.to( newLaser, { y=2048, time=2000,    onComplete = function() display.remove( newLaser )end} )
	end
	end
	
local function loopEnemyFire()


enemyLaser()

end
----------------------------------------------------------------------------------------------------------------
local function restoreShip()  -- Восстановление корабля после снятия одного HP
 
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

local function listener( event )
    print( "listener called" )
	
	physics.addBody( newBonus, "dynamic", { isSensor=true } )
end
----------------------------------------------------------------------------------------------------------------
local function bonus(x,y)   -- Функция выпадания бонусов
 local chance = 30
 local randItem = 0
 chance = math.random(100)
 if chance <10 then

    newBonus = display.newImageRect( mainGroup, "Shield.png", 50, 40 )
	newBonus:addEventListener("collision",newBonus)
    timer.performWithDelay( 20, listener, 1 )
    newBonus.isBullet = true
    newBonus.myName = "bonus"
	newBonus.x = x
    newBonus.y = y
	newBonus:toBack()
	transition.to( newBonus, { y=2048, time=4500,    onComplete = function() display.remove( newBonus )end} )
else if chance <20 and chance >10 then

    newBonus = display.newImageRect( mainGroup, "domino.png", 50, 40 )
	newBonus:addEventListener("collision",newBonus)
    timer.performWithDelay( 20, listener, 1 )
    newBonus.isBullet = true
    newBonus.myName = "bonus"
	newBonus.item = "laserBonus"
	newBonus.x = x
    newBonus.y = y
	newBonus:toBack()
	transition.to( newBonus, { y=2048, time=4500,    onComplete = function() display.remove( newBonus )end} )
	end
	end
	end
----------------------------------------------------------------------------------------------------------------
local function onCollision2( event )   -- Обработка столкновения с бонусом
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
if ( ( obj1.myName == "ship" and obj2.myName == "bonus" ) or
                 ( obj1.myName == "bonus" and obj2.myName == "ship" ) )
				 then
				 audio.play(bonusSound)
				 if obj1.item=="laserBonus" or obj2.item=="laserBonus"
				 then threeLasers=true
				 else
				  score = score + 1256
            scoreText.text = "Score: " .. score
			display.remove( obj1 )
				end 
				end
				end
				end
				
----------------------------------------------------------------------------------------------------------------
local function onCollisionBoss( event )  -- Обработка столкновения снаряда с боссом
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
if ( ( obj1.myName == "laser" and obj2.myName == "boss" ) or
                 ( obj1.myName == "boss" and obj2.myName == "laser" ) )
				 then
				  score = score +200
            scoreText.text = "Score: " .. score
			

		 
		bonus(obj1.x,obj1.y)
		
		
		bossHP = bossHP+1
		display.remove(newHP)
		newHP = display.newImageRect( mainGroup, hpTable[bossHP], 200, 20 )	
	newHP.x=display.contentCenterX
	newHP.y=130
	newHP:toBack()
	display.remove( obj1 )
		if bossHP>6 then
			display.remove( obj2 )
			waveText.text="You Win!!!"
			timer.performWithDelay(800,endGame,1)
			end
				end 
				end
				end				
----------------------------------------------------------------------------------------------------------------				
local function onCollision( event )  -- Обработка столкновения снарядов с врагами и игроком

 local x
  local y
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
		if ( ( obj1.myName == "laser" and obj2.name == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
        then
x=obj1.x
y=obj1.y

		audio.play( explosionSound2 )
		display.remove( obj1 )
		if obj2:getHP()==4 then
		obj2:setSequence("damage1")
		end
		if obj2:getHP()==3 then
		obj2:setSequence("damage2")
		end
		if obj2:getHP()==2 then
		obj2:setSequence("damage3")
		end
		
		--obj2:play()
		obj2:setHP()
		if obj2.enemyHP == 0 then
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
			

		
		 
		bonus(x,y)
		
		end
			elseif ( ( obj1.myName == "ship" and obj2.myName == "laser2" ) or
                 ( obj1.myName == "laser2" and obj2.myName == "ship" ) )
        then
		audio.play( explosionSound3 )
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
				end
        end
    end
	

		end



---------------------------------------------------------------------------------------		
		local function timersStart()
		gameLoopTimer2 = timer.performWithDelay( 500, gameLoop2, 0 )
		gameLoopTimer3 = timer.performWithDelay( 1700, loopEnemyFire, 0 )

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
livesText1 = display.newSprite( uiGroup, hpSheet,hpData )

livesText = display.newSprite( uiGroup, hpSheet,hpData )
livesText1.yScale=(304/2031) 
	livesText1.xScale=94/630
	livesText1.y=80
	livesText1.x=250
	
	
	livesText.yScale=(285/1902) 
	livesText.xScale=77/530
	livesText.y=77
	livesText.x=245
	
	livesText1:setSequence("damage0")
scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

----------------------------------------------------------------------------------------------------------------
ship:addEventListener( "tap", fireLaser )
ship:addEventListener( "touch", dragShip )
musicTrack = audio.loadStream( "level1.mp3")

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
		Runtime:addEventListener( "collision", onCollisionBoss )
					waveText = display.newText( mainGroup, "Wave" .. waveCount, display.contentCenterX, 200, native.systemFont, 72 )
	waveText:setFillColor( 0, 0, 1 )
waveText:toBack()	
 timer.performWithDelay( 2800, waveTextClear, 1 )
	 timer.performWithDelay( 3000, gameLoop, 1 )
	 timer.performWithDelay( 3000, timersStart, 1 )

		

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		
		timer.cancel( gameLoopTimer2 )
		timer.cancel( gameLoopTimer3 )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener( "collision", onCollision2 )
		Runtime:removeEventListener( "collision", onCollisionBoss )
        physics.pause()
audio.stop( 1 )
   

		composer.removeScene( "level1" )
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
