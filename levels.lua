
local composer = require( "composer" )

local scene = composer.newScene()
local musicTrack
level1 =false

level2 =false
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoLevel1()
	--composer.gotoScene( "game" )
	level1 =true
	composer.gotoScene( "points", { time=800, effect="crossFade" } )
end
local function gotoLevel2()
	--composer.gotoScene( "game" )
	level2 =true
	composer.gotoScene( "points", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
	--composer.gotoScene( "highscores" )
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
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
	scoreText = display.newText( sceneGroup, "ASSteroids! v0.4", display.contentCenterX, 200, native.systemFont, 72 )
	scoreText:setFillColor( 0, 0, 1 )
	
	scoreText = display.newText( sceneGroup, "Burunday Soft, 2018 ", display.contentCenterX+150, 20, native.systemFont, 24 )
	scoreText:setFillColor( 1, 0, 0 )
	
	local playButton1 = display.newText( sceneGroup, "level1", display.contentCenterX, 600, native.systemFont, 44 )
	playButton1:setFillColor( 0, 0, 1 )
	local playButton2 = display.newText( sceneGroup, "level2", display.contentCenterX, 710, native.systemFont, 44 )
	playButton2:setFillColor( 0, 0, 1 )	

	playButton1:addEventListener( "tap", gotoLevel1 )
	playButton2:addEventListener( "tap", gotoLevel2 )
	
	
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
