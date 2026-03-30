local anim8 = require("libs/anim8")
local bump = require("libs/bump")
love.graphics.setDefaultFilter("nearest", "nearest")
isAttacking = false
enemy = {}

function enemy:load()
    self.list = {}
    table.insert(self.list, {x = 300, y = 300, w = 32, h = 32, hp = 3})
end

function enemy:update(dt)

end

function enemy:draw()
    for _, e in ipairs(self.list) do
        love.graphics.rectangle("fill", e.x, e.y, e.w, e.h)
    end
end

function enemy:damage(x, y, w, h)
    for i = #self.list, 1, -1 do
        local e = self.list[i]
        if x < e.x + e.w and x + w > e.x and y < e.y + e.h and y + h > e.y then
            e.hp = e.hp - 1
            if e.hp <= 0 then
                table.remove(self.list, i)
            end
        end
    end
end

return enemy