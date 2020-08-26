ScoreState = Class{__includes = PlayState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Lmao rip you lost', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score >= 0 and self.score < 2 then
        love.graphics.draw(bronze, VIRTUAL_WIDTH/2-bronze:getWidth()/2, 140)
    elseif self.score >=2 and self.score < 3 then
        love.graphics.draw(silver, VIRTUAL_WIDTH/2-silver:getWidth()/2, 140)
    else 
        love.graphics.draw(gold, VIRTUAL_WIDTH/2-gold:getWidth()/2, 140)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')
end