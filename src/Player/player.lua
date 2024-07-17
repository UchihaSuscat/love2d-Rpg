local anim8 = require("libs/anim8")
local bump = require("libs/bump")
love.graphics.setDefaultFilter("nearest", "nearest")

player = {}

function player:load()
    -- PLAYER DIMENSIONS
    self.x = 153.5292
    self.y = 36.304868
    self.width = 12
    self.height = 18
    self.speed = 1000
    self:anim()
end

function player:update(dt)
    -- ALL THE FUNCTIONS BEING CALLED HERE
    local prevX, prevY = self.x, self.y
    self:move(dt)
    self.anim:update(dt)
    self:checkBoundary()
    self:checkCollision(dt)
end

function player:draw()
    -- DRAWING THE ANIMATED SPRITE
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 4, nil, 6, 9)
end

-- PLAYER FUNCTIONS

function player:move(dt)
    -- CHECKING IF THE PLAYER IS MOVING (USED FOR ANIMATIONS)
    local isMoving = false

    -- THE MOVEMENT SCRIPT + THE ANIMATIONS

    if love.keyboard.isDown("d", "right") then
        self.x = self.x + self.speed * dt
        self.anim = self.animations.right
        isMoving = true
    elseif love.keyboard.isDown("a", "left") then
        self.x = self.x - self.speed * dt
        self.anim = self.animations.left
        isMoving = true
    elseif love.keyboard.isDown("w", "up") then
        self.y = self.y - self.speed * dt
        self.anim = self.animations.up
        isMoving = true
    elseif love.keyboard.isDown("s", "down") then
        self.y = self.y + self.speed * dt
        self.anim = self.animations.down
        isMoving = true
    end

    -- MAKING THE ANIMATION GOT TO THE IDLE POSITION OF THE PLAYER IS NOT MOVING
    if not isMoving then
        self.anim:gotoFrame(2)
    end
end

function player:anim()
    -- IMPORTING THE SPRITE SHEET AND ADDING A NEW GRID TO IT
    self.spriteSheet = love.graphics.newImage("assets/Player/player-sheet.png")
    self.grid = anim8.newGrid(12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    -- MAKING THE ANIMATIONS USING THE GRID BASED SYSTEM
    self.animations = {}
    self.animations.down = anim8.newAnimation(self.grid("1-4", 1), 0.2) 
    self.animations.left = anim8.newAnimation(self.grid("1-4", 2), 0.2)
    self.animations.right = anim8.newAnimation(self.grid("1-4", 3), 0.2)
    self.animations.up = anim8.newAnimation(self.grid("1-4", 4), 0.2)
    self.anim = self.animations.down
end

function player:checkBoundary()

    -- PLAYER NOT GOING ABOVE THE MAP AND BELOW THE MAP
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > gameMap.height * gameMap.tileheight then
        self.y = gameMap.height * gameMap.tileheight - self.height
    end

    -- PLAYER NOT GOING LEFT TO THE MAP AND RIGHT TO THE MAP
    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > gameMap.width * gameMap.tilewidth then
        self.x = gameMap.width * gameMap.tilewidth - self.width
    end
end

function player:checkCollision(dt)
    local actualX, actualY, cols, len = player.world:move(self, self.x, self.y, function(item, other)
        return 'slide'
    end)

    self.x, self.y = actualX, actualY
end