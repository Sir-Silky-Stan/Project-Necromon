local game = {}
game.state = {}
game.state.menu = true
game.state.running = false
game.state.paused = true
game.state.exit = false

local menu = {}
menu.select = 1 
menu.new_game = "Start New Game"
menu.exit_game = "Exit Game"

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setNewFont(12)

    sti = require 'libraries/sti'
    anim8 = require 'libraries/anim8'
    camera = require 'libraries/camera'

    cam = camera()

    gamemap = sti('maps/testmap.lua')

    player = {}
    player.x = 64
    player.y = 64
    player.speed = 5
    player.sprite = love.graphics.newImage('sprites/test-guy.png')
    player.grid = anim8.newGrid( 12, 18, player.sprite:getWidth(), player.sprite:getHeight() )

    player.frames = {}
    player.frames.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.frames.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.frames.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.frames.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )
    
    player.current = player.frames.left

end

function love.update(dt)

    local ismoving = false

    if game.state['running'] then
        if love.keyboard.isDown('d') then
            player.x = player.x + player.speed
            player.current = player.frames.right
            ismoving = true
        end

        if love.keyboard.isDown('a') then
            player.x = player.x - player.speed
            player.current = player.frames.left
            ismoving = true
        end

        if love.keyboard.isDown('s') then
            player.y = player.y + player.speed
            player.current = player.frames.down
            ismoving = true
        end

        if love.keyboard.isDown('w') then
            player.y = player.y - player.speed
            player.current = player.frames.up
            ismoving = true
        end

        if ismoving == false then
            player.current:gotoFrame(2)
        end

        player.current:update(dt)

        cam:lookAt(player.x, player.y)

        local gamew = love.graphics.getWidth()
        local gameh = love.graphics.getHeight()

        if cam.x < gamew/2 then
            cam.x = gamew/2
        end

        if cam.y < gameh/2 then
            cam.y = gameh/2
        end

        local mapw = gamemap.width * gamemap.tilewidth
        local maph = gamemap.height * gamemap.tileheight

        if cam.x > (mapw - gamew/2) then
            cam.x = (mapw - gamew/2)
        end

        if cam.y > (maph - gameh/2) then
            cam.y = (maph - gameh/2)
        end
    end
end

function love.draw()
    if not game.state['running'] then
        if game.state['menu'] then
            love.graphics.print(menu.new_game, 148, 110, 0, 2)    
            love.graphics.print(menu.exit_game, 148, 140, 0, 2)        
            if menu.select == 1 then
                love.graphics.rectangle('line', 148, 112, 200, 25)
            
            elseif menu.select == 2 then
                love.graphics.rectangle('line', 148, 142, 131, 25)
                
            end
        end
    elseif game.state['running'] then
        cam:attach()
            love.graphics.print("starting game", 64, 64)
            gamemap:drawLayer(gamemap.layers['ground'])
            gamemap:drawLayer(gamemap.layers['Tile Layer 2'])
            player.current:draw(player.sprite, player.x, player.y, nil, 5, nil, 6, 9)
        cam:detach()
    end
end    
    
function love.keypressed(key)
    if not game.state['running'] then
        if game.state['menu'] then
            if key == 'up' then
                menu.select = menu.select +1
                if menu.select >= 3 then
                    menu.select = 1 
                end
            elseif key == 'down' then
                menu.select = menu.select -1
                if menu.select <= 0 then
                    menu.select = 2 
                end 
            end
            if menu.select == 1 then
                if key == 'space' then
                    game.state.running = true
                end
            elseif menu.select == 2 then
                if key == 'space' then
                    love.event.quit()
                end
            end
        end
    end
    if key == 'escape' then
        game.state.running = false
        game.state.menu = true
    end
end