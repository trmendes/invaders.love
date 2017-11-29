love.graphics.setDefaultFilter('nearest', 'nearest')

enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')

function love.load()

    config = {}
    config.player = {}
    config.bullet = {}
    config.enemy = {}
    config.info = {}

    config.info.x_size = 800
    config.info.y_size = 20
    config.info.x_start_at = 0
    config.info.y_start_at = 580

    config.player.x_size = 80
    config.player.y_size = 20
    config.player.speed = 10
    config.player.x_start_at = 0
    config.player.y_start_at = 560
    config.player.fire_cooldown = 20
    config.player.speed = 10

    player = {}
    player.x = config.player.x_start_at
    player.y = config.player.y_start_at
    player.fire_cooldown = config.player.fire_cooldown
    player.bullets = {}

    player.fire = function()
        if (player.fire_cooldown <= 0) then
            player.fire_cooldown = config.player.fire_cooldown
            bullet = {}
            bullet.x = player.x + 35 -- middle
            bullet.y = player.y
            table.insert(player.bullets, bullet)
        end
    end

    config.bullet.x_size = 10
    config.bullet.y_size = 10
    config.bullet.speed = 10

    config.enemy.x_size = 80
    config.enemy.y_size = 20
    config.enemy.speed = 20
    config.enemy.fire_cooldown = 20

   enemies_controller:spawnEnemy(0, 0)
   enemies_controller:spawnEnemy(config.enemy.x_size + 20, 0)


end

function love.update(dt)

    player.fire_cooldown = player.fire_cooldown - 1

    -- keyboard
    if love.keyboard.isDown("right") then
        player.x = player.x + config.player.speed
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - config.player.speed
    end

    if love.keyboard.isDown("space") then
        player.fire()
    end

    -- player bullets
    for idx,bullet in pairs(player.bullets) do
        if idx < -100 then
            table.remove(player.bullets, idx)
        end
        bullet.y = bullet.y - config.bullet.speed
    end

    -- enemy move
    for _, e in pairs(enemies_controller.enemies) do
        e.y = e.y + 1
    end
end

function love.draw()

    -- ground bar
    love.graphics.setColor(0, 255, 200)
    love.graphics.rectangle("fill", config.info.x_start_at, config.info.y_start_at, config.info.x_size, config.info.y_size)

    -- info text
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("Reloading: ", 0, 10)

    -- player
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("fill", player.x, player.y, config.player.x_size, config.player.y_size)

    -- bullets
    love.graphics.setColor(255, 255, 255)
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, config.bullet.x_size, config.bullet.y_size)
    end

    -- enemies
    for _e, enemy in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, enemy.x, enemy.y)
    end
end

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.bullets = {}
    enemy.fire_cooldown = config.enemy.fire_cooldown
    table.insert(self.enemies, enemy)
end

function enemy:fire()
    if (self.fire_cooldown <= 0) then
        self.fire_cooldown = config.enemy.fire_cooldown
        bullet = {}
        bullet.x = self.x + 35 -- middle
        bullet.y = self.y
        table.insert(self.bullets, bullet)
    end
end


