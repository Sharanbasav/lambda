TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Mario Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end