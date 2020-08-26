PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

MARIO_WIDTH = 38
MARIO_HEIGHT = 24

function PlayState:init()
    self.mario = Mario()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('p') then
        if not isPaused then
            isPaused = true
            love.audio.pause(sounds['music'])
        else
            isPaused = false
            love.audio.resume(sounds['music'])
        end
    end
    if isPaused == false then
    -- update timer for pipe spawning
        self.timer = self.timer + dt

        local randTime = math.random(2, 50)
        -- spawn a new pipe pair every second and a half
        if self.timer > randTime then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y

            -- add a new pipe pair at the end of the screen at our new Y
            table.insert(self.pipePairs, PipePair(y))

            -- reset timer
            self.timer = 0
        end

        for k, pair in pairs(self.pipePairs) do
            -- score a point if the pipe has gone past mario to the left all the way
            -- ignore it if it's already been scored
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.mario.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            -- update position of pair
            pair:update(dt)
        end

        -- a second for loop is needed as if we remove the pipe pair in the previous loop,
        -- the next pipe in-line will be skipped because it's index will be shifted down to the removed pipes place
        -- and it will never be iterated on(this is how removal in lua is) 
        -- if a second loop is not used, the pipe spawning will be very choppy and buggy
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        -- collision between mario and all pipes in pairs
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.mario:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end



    -- update mario based on gravity and input
        self.mario:update(dt)

        -- reset if we get to the ground
        if self.mario.y > VIRTUAL_HEIGHT - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    if not isPaused then
        self.mario:render()
    else 
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Game Paused', 0, 80, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('||', 0, 120, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    
end