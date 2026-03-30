local STI = require("libs.sti")
local camera = require("libs.camera")
local bump = require("libs.bump")
cam = camera()
require("src.Player.player")
local enemy = require("src.Enemy.enemy")
flux = require("libs.flux")

--ball = { x = love.graphics.getWidth() / 2 , y = love.graphics.getHeight() / 2 , radius = 0 }
ball = { x = love.graphics.getWidth() / 2 , y = love.graphics.getHeight() / 2 , radius = love.graphics.getWidth() }

function love.load()
    player:load()
    enemy:load()
    gameMap = STI("maps/1.lua")
    collisionbump()
    flux.to(ball, 2, { radius = 0 }):ease("expoinout")
    flux.to(ball, 2, { radius = love.graphics.getWidth() }):ease("expoinout")
    sounds()
end

function love.update(dt)
    player:update(dt)
    flux.update(dt)
    enemy:update(dt)
    cam:lookAt(player.x + player.width / 2, player.y + player.height / 2)
    cameraborder()
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        enemy:draw()
        player:draw()
        gameMap:drawLayer(gameMap.layers["Trees"])
    cam:detach()

    love.graphics.setColor(1,1,1)
    love.graphics.print("Health: " .. player.health, 10, 10)

    local y = 10
    for i, e in ipairs(enemy.list) do
        local text = "Enemy " .. i .. ": " .. e.hp
        local w = love.graphics.getFont():getWidth(text)
        love.graphics.print(text, love.graphics.getWidth() - w - 10, y)
        y = y + 20
        end
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end

function cameraborder()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w / 2 then
        cam.x = w / 2
    end

    if cam.y < h / 2 then
        cam.y = h / 2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w / 2) then
        cam.x = (mapW - w / 2)
    end

    if cam.y > (mapH - h / 2) then
        cam.y = (mapH - h / 2)
    end
end

function collisionbump()
    -- Initialize bump world
    world = bump.newWorld(32)
    player.world = world

    -- Add solid objects to the bump world
    if gameMap.layers["solid"] then 
        for _, object in pairs(gameMap.layers["solid"].objects) do
            world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    if gameMap.layers["pathend"] then 
        for _, object in pairs(gameMap.layers["pathend"].objects) do
            world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    -- Add player to the world
    world:add(player, player.x, player.y, player.width, player.height)
end

function sounds()
    sounds = {}
    sounds.music = love.audio.newSource("sounds/8CHRW33-chill-beat.mp3", "stream")
    sounds.music:setVolume(0.1) -- 0.1 to 1.0
    sounds.music:setLooping(true) -- Loop the music
    sounds.music:play()
end