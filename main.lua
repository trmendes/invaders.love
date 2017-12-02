love.graphics.setDefaultFilter('nearest', 'nearest')

enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}

love.graphics.setDefaultFilter("nearest" ,"nearest" ,1)

function love.load()
    background_img = love.graphics.newImage('assets/images/background.jpg')

    -- game flags
    game_over = false
    we_have_a_winner = false
    game_row_counter = 3

    -- status bar
    info = {}
    info.x_size = love.graphics.getWidth()
    info.y_size = 20
    info.x_start_at = 0
    info.y_start_at = love.graphics.getHeight() - info.y_size

    -- player
    player = {}
    player.x = 0
    player.y = love.graphics.getHeight() - 150
    player.speed = 500
    player.fire_cooldown_reset_value = 20
    player.fire_cooldown = player.fire_cooldown_reset_value
    player.bullet_speed = 700
    player.bullets = {}

    -- images
    images = {}
    images.enemy = love.graphics.newImage('assets/images/rocket.png')
    images.enemy_w, images.enemy_h = images.enemy:getDimensions()
    images.player = love.graphics.newImage('assets/images/rocket.png')
    images.player_w, images.player_h = images.player:getDimensions()

    -- sounds
    sounds = {}
    sounds.fire = love.audio.newSource("assets/sounds/laser_shoot.wav", "static")
    sounds.fire:setVolume(0.2)
    sounds.explosion = love.audio.newSource("assets/sounds/explosion.wav", "static")
    sounds.explosion:setVolume(0.2)

    player.fire = function()
        if (player.fire_cooldown <= 0) then
            love.audio.play(sounds.fire)
            player.fire_cooldown = player.fire_cooldown_reset_value
            bullet = {}
            bullet.x = player.x + images.player_w/2 -- middle
            bullet.y = player.y
            table.insert(player.bullets, bullet)
        end
    end

    -- enemies
    for j = 1, game_row_counter do
        for i = 0,7 do
            enemies_controller:spawnEnemy(i * images.enemy_w, -j * images.enemy_h + 20)
        end
    end
end

function love.update(dt)

    if game_over then
        return
    end

    if #enemies_controller.enemies == 0 then
        we_have_a_winner = true
    end

    player.fire_cooldown = player.fire_cooldown - 1

    -- keyboard
    if love.keyboard.isDown("right") then
        if player.x < love.graphics.getWidth() - images.player_w then
            player.x = player.x + ( player.speed * dt )
        end
    end

    if love.keyboard.isDown("left") then
        if player.x > 0 then
            player.x = player.x - ( player.speed * dt )
        end
    end

    if love.keyboard.isDown("space") then
        player.fire()
    end

    checkCollisions(enemies_controller.enemies, player.bullets)

    -- player bullets
    for idx,bullet in pairs(player.bullets) do
        if idx < -100 then
            table.remove(player.bullets, idx)
        end
        bullet.y = bullet.y - ( player.bullet_speed * dt )
    end

    -- enemy move
    for _, e in pairs(enemies_controller.enemies) do
        e.y = e.y + ( 100 * dt )
        if e.y >= love.graphics.getHeight() then
            game_over = true
        end
    end
end

function love.draw()

    love.graphics.draw(background_img)

    if game_over then
        love.graphics.print("Game Over!")
        return
    elseif we_have_a_winner then
        love.graphics.print("You won!")
    end

    -- ground bar
    love.graphics.setColor(0, 255, 200)
    love.graphics.rectangle("fill", info.x_start_at, info.y_start_at, info.x_size, info.y_size)

    -- info text
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("Reloading: ", 0, 10)

    -- player
    love.graphics.draw(images.player, player.x, player.y)

    -- bullets
    love.graphics.setColor(255, 255, 255)
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, 10, 10)
    end

    -- enemies
    for _,enemy in pairs(enemies_controller.enemies) do
        love.graphics.draw(images.enemy, enemy.x, enemy.y)
    end
end

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.bullets = {}
    enemy.fire_cooldown = enemy.fire_cooldown
    table.insert(self.enemies, enemy)
end

function checkCollisions(enemies, bullets)
    for eidx,e in pairs(enemies) do
        for bidx,b in pairs(bullets) do
            if b.y <= e.y + images.enemy_h and b.x > e.x and b.x < e.x + images.enemy_w then
                love.audio.play(sounds.explosion)
                table.remove(enemies, eidx)
                table.remove(bullets, bidx)
            end
        end
    end
end

function enemy:fire()
    if (self.fire_cooldown <= 0) then
        self.fire_cooldown = enemy.fire_cooldown
        bullet = {}
        bullet.x = self.x + 35 -- middle
        bullet.y = self.y
        table.insert(self.bullets, bullet)
    end
end


