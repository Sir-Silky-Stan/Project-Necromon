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

    local sti = require 'libraries/sti'
    local game_map = sti('maps/testingmap.lua')

end

function love.update(dt)
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
        love.graphics.print("starting game", 64, 64)
        game_map:draw()
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