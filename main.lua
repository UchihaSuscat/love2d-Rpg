local STI = require("libs/sti")
local camera = require("libs/camera")
local bump = require("libs/bump")
cam = camera()
require("src/Player/player")

function love.load()
    player:load()
    gameMap = STI("maps/1.lua")
    collisionbump()
    
end

function love.update(dt)
    player:update(dt)
    cam:lookAt(player.x + player.width / 2, player.y + player.height / 2)
    cameraborder()
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        player:draw()
        gameMap:drawLayer(gameMap.layers["Trees"])
    cam:detach()
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

    -- Add player to the world
    world:add(player, player.x, player.y, player.width, player.height)
end