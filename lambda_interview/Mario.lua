Mario = Class{}

local GRAVITY = 20

function Mario:init()
    self.image = love.graphics.newImage('sprites/tanukimario.png')
    self.x = VIRTUAL_WIDTH / 2 - self.image:getWidth()/2
    self.y = VIRTUAL_HEIGHT / 2 - self.image:getWidth()/2

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
end

function Mario:collides(pipe)
    -- 2s and 4s are small offsets to make the game more fair 
    -- gives leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Mario:update(dt)
    self.dy = self.dy + GRAVITY * dt

    -- anti-gravity baby
    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end
    self.y = self.y + self.dy
end

function Mario:render()
    love.graphics.draw(self.image, self.x, self.y)
end