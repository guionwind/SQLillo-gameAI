local target = nil
local cooldowns = {0, 0, 0}

function bot_init(me)
end

function bot_main(me)
    local me_pos = me:pos()

    for i = 1, 3 do
        if cooldowns[i] > 0 then
            cooldowns[i] = cooldowns[i] - 1
        end
    end

    local closest_enemy = nil
    local min_distance = math.huge
    for _, player in ipairs(me:visible()) do
        local dist = vec.distance(me_pos, player:pos())
        if player:type() == "player" and dist < min_distance then
            min_distance = dist
            closest_enemy = player
        end
    end

    local target = closest_enemy
    if target then
        local direction = target:pos():sub(me_pos)
        if min_distance <= 2 and me:cooldown(2) == 0 then
            me:cast(2, direction)
        elseif me:cooldown(0) == 0 then
            me:cast(0, direction)
        end

        local x = 1;
        local y = 1;
        local dirTemp = nil;
        print(me_pos:x(), me_pos:y())
        print(me_pos:x() < 10)
        if (me_pos:x() <= 10) then
            x = 1
            y = -1
        elseif (me_pos:x() >= 490) then
            x = -1
            y = 1
        elseif (me_pos:y() < 10) then
            x = 1
            y = 1
        elseif (me_pos:y() > 490) then
            x = -1
            y = -1
        end

        dirTemp = vec.new(x, y)

        local center = vec.new(me:cod():x(), me:cod():y())

        if center:x() ~= -1 and not is_inside_circle(me, center) then
            local direction_xd = center:sub(me_pos)
            if (vec.distance(me:pos(), me:cod():radius()) < 3) then
                me:cast(1, direction_xd)
            end

            me:move(direction_xd)
        else
            if (me_pos:x() <= 10) then
                me:move(dirTemp)
            elseif (me_pos:y() < 10) then
                me:move(dirTemp)
            elseif (me_pos:x() >= 490) then
                me:move(dirTemp)
            elseif (me_pos:y() > 490) then
                me:move(dirTemp)
            else
                print("escapa")
                me:move(direction:neg())
            end
        end
    end
end

function is_inside_circle(me, center)
    return vec.distance(me:pos(), center) <= me:cod():radius()-5
end