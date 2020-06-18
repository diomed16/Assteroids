
local composer = require( "composer" )

local scene = composer.newScene()
local musicTrack


local json = require( "json" ) 
local pointTable = {} 
local points =3
local filePath = system.pathForFile( "points.json", system.DocumentsDirectory )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoLevel1()
	--composer.gotoScene( "game" )
	composer.gotoScene( "level1", { time=800, effect="crossFade" } )
end


local function savePoints()
 
    for i = #pointTable, 11, -1 do
        table.remove( pointTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( pointTable ) )
        io.close( file )
    end
end


local function gotoLevel2()
	--composer.gotoScene( "game" )
	if points == 0 then
	
	savePoints()
	if level1==true then
	pointTable[4]=1
	savePoints()
	composer.gotoScene( "level1", { time=800, effect="crossFade" } )
	elseif level2==true then
	pointTable[4]=1
	savePoints()
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
	end
	end
end

local function gotoHighScores()
	--composer.gotoScene( "highscores" )
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
local function loadPoints()
 
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        pointTable = json.decode( contents )
    end
 
    if ( pointTable == nil or #pointTable == 0 ) then
        pointTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end






local function addLives()
if points>0 then
pointTable[1]=pointTable[1]+1
livesText.text = "Lives: "..pointTable[1]
points=points-1
text1.text = "Распределите: "..points
end
end

local function addDamage()
if points>0 then
pointTable[2]=pointTable[2]+1
damageText.text = "Damage: "..pointTable[2]
points=points-1
text1.text = "Распределите: "..points
end
end

local function addRate()
if points>0 then
pointTable[3]=pointTable[3]+1
rateText.text = "Firing rate: "..pointTable[3]
points=points-1
text1.text = "Распределите: "..points
end
end

local function delLives()
if points<3 and points>-1 and pointTable[1]>0 then
pointTable[1]=pointTable[1]-1
livesText.text = "Lives: "..pointTable[1]
points=points+1
text1.text = "Распределите: "..points
end
end

local function delDamage()
if points<3 and points>-1 and pointTable[2]>0 then
pointTable[2]=pointTable[2]-1
damageText.text = "Damage: "..pointTable[2]
points=points+1
text1.text = "Распределите: "..points
end
end

local function delRate()
if points<3 and points>-1 and pointTable[3]>0 then
pointTable[3]=pointTable[3]-1
rateText.text = "Firing rate: "..pointTable[3]
points=points+1
text1.text = "Распределите: "..points
end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()

function scene:create( event )

	local sceneGroup = self.view
	

	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "Даптер.jpg", 2000,1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--local title = display.newImageRect( sceneGroup, "title.png", 500, 80 )
	--title.x = display.contentCenterX
	--title.y = 200
	scoreText = display.newText( sceneGroup, "ASSteroids! v0.3", display.contentCenterX, 200, native.systemFont, 72 )
	scoreText:setFillColor( 0, 0, 1 )
	
	scoreText = display.newText( sceneGroup, "Burunday Soft, 2018 ", display.contentCenterX+150, 20, native.systemFont, 24 )
	scoreText:setFillColor( 1, 0, 0 )
	loadPoints()
	if pointTable[4]==1 then
	points =0
	end
	
	 text1 =      display.newText( sceneGroup, "Распределите: "..points, display.contentCenterX-35, 350, native.systemFont, 32 )
	 livesText =  display.newText( sceneGroup, "Lives: "       ..pointTable[1], display.contentCenterX-35, 450, native.systemFont, 32 )
	 damageText = display.newText( sceneGroup, "Damage: "      ..pointTable[2], display.contentCenterX-12, 500, native.systemFont, 32 )
	 rateText =   display.newText( sceneGroup, "Firing rate: " ..pointTable[3], display.contentCenterX, 550, native.systemFont, 32 )
	 playButton = display.newText( sceneGroup, "Go", display.contentCenterX, 700, native.systemFont, 64 )
	livesText:setFillColor( 0, 0, 1 )	
	rateText:setFillColor( 0, 0, 1 )
	damageText:setFillColor( 0, 0, 1 )	
	text1:setFillColor( 0, 0, 1 )
	playButton:setFillColor( 0, 0, 1 )
	
	local plusLives = display.newImageRect( sceneGroup, "plus.png", 30, 30 )
	plusLives.x = display.contentCenterX+125
	plusLives.y = 450
	plusLives:addEventListener( "tap", addLives )
	local plusDamage = display.newImageRect( sceneGroup, "plus.png", 30, 30 )
	plusDamage.x = display.contentCenterX+125
	plusDamage.y = 500
	plusDamage:addEventListener( "tap", addDamage )
	local plusRate = display.newImageRect( sceneGroup, "plus.png", 30, 30 )
	plusRate.x = display.contentCenterX+125
	plusRate.y = 550
	plusRate:addEventListener( "tap", addRate )
	local	minusLives = display.newImageRect( sceneGroup, "minus.png", 30, 30 )
	minusLives.x = display.contentCenterX-140
	minusLives.y = 450
	minusLives:addEventListener( "tap", delLives )
	local minusDamage = display.newImageRect( sceneGroup, "minus.png", 30, 30 )
	minusDamage.x = display.contentCenterX-140
	minusDamage.y = 500
	minusDamage:addEventListener( "tap", delDamage )
	local minusRate = display.newImageRect( sceneGroup, "minus.png", 30, 30 )
	minusRate.x = display.contentCenterX-140
	minusRate.y = 550
	minusRate:addEventListener( "tap", delRate )
	playButton:addEventListener( "tap", gotoLevel2 )
	
	

	
	
	musicTrack = audio.loadStream( "main.mp3")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
audio.stop( 1 )
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
