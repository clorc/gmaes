import pygame
from animation import MovingEntity, Animation

class Player(MovingEntity):
    def __init__(
            self, 
            player_pos: pygame.Vector2,
            screen: pygame.Surface,
            speed: int = 300,
            projectile_frequency: int = 2,
            projectile_speed: int = 500,
            projectile_damage: int = 300,
        ):
        super().__init__(screen)

        # player movement
        self.player_pos = player_pos
        self.player_velocity = pygame.Vector2(0,0)
        self.size = 2
        self.player_radius = self.size*9
        self.movement_state = 0
        self.attack_state = 0

        # projectile info
        self.projectiles_in_action = []
        self.is_cooldown = False
        self.cooldown = 0

        # player stats
        self.speed = speed
        self.projectile_frequency = projectile_frequency
        self.projectile_speed = projectile_speed
        self.projectile_damage = projectile_damage

        # keys
        self.movement_keys = [pygame.K_w, pygame.K_s, pygame.K_a, pygame.K_d]
        self.attack_keys = [pygame.K_UP, pygame.K_DOWN, pygame.K_LEFT, pygame.K_RIGHT]

        # player animations
        self.char_sheet = pygame.image.load("./assets/char_sheet.png"). convert_alpha()
        self.attack_animation = Animation(
            screen=screen,
            sprite_sheet=self.char_sheet,
            size=self.size,
            start_x=11,
            start_y=25,
            spacing=12,
            frame_axis=0,
            framerate=2*self.projectile_frequency,
            frames=2,
            width=28,
            height=26,
            state_init=0,
            state_spacing_x= 28*2 + 12*2,
            state_num=4,
            reverse=True
        )

        self.walking_animation = Animation(
            screen=screen,
            sprite_sheet=self.char_sheet,
            size=self.size,
            start_x=15,
            start_y=80,
            spacing=14,
            frame_axis=0,
            framerate=5,
            frames=10,
            width=18,
            height=15,
            state_init=0,
            state_spacing_y= 43,
            state_num=2,
            abrupt=True
        )

    def assert_bounds_increment(self, x_inc, y_inc):
        x_new_inc = x_inc
        y_new_inc = y_inc

        player_pos_x = self.player_pos.x
        player_pos_y = self.player_pos.y

        if (player_pos_x - self.player_radius) + x_inc < self.width_margin:
            x_new_inc -= (player_pos_x - self.player_radius) + x_inc - self.width_margin

        elif (player_pos_x + self.player_radius) + x_inc > self.screen_width-self.width_margin:
            x_new_inc = self.screen_width-self.width_margin - (player_pos_x + self.player_radius)

        if (player_pos_y - self.player_radius) + y_inc < self.height_margin:
            y_new_inc -= (player_pos_y - self.player_radius) + y_inc - self.height_margin

        elif (player_pos_y + self.player_radius) + y_inc > self.screen_height-self.height_margin:
            y_new_inc = self.screen_height-self.height_margin - (player_pos_y + self.player_radius)

        return (x_new_inc, y_new_inc)

    def assert_bounds(self, x, y) -> tuple:
        x_new = 0
        y_new = 0

        if x < 0:
            x_new = self.player_radius
        elif x > self.screen_width:
            x_new = self.screen_width - self.player_radius

        if y < 0:
            y_new = self.player_radius
        elif y > self.screen_height:
            y_new = self.screen_height - self.player_radius

        return (x_new, y_new)

    def listen_for_key_press(self, keys:pygame.key.ScancodeWrapper):
        if keys[pygame.K_w] or keys[pygame.K_s] or keys[pygame.K_a] or keys[pygame.K_d]:
            self.move_action(keys)
        else:
            self.player_velocity = pygame.Vector2(0,0)
            self.walking_animation.is_animated = False
            self.walking_animation.flip_x = False
            self.walking_animation.state = 0

        if keys[pygame.K_UP] or keys[pygame.K_DOWN] or keys[pygame.K_LEFT] or keys[pygame.K_RIGHT]:
            self.attack_action(keys)
        else:
            self.attack_animation.state = 0
            self.attack_animation.is_animated = False

    def move_action(self, keys:pygame.key.ScancodeWrapper):
        y_inc = 0
        x_inc = 0

        if keys[pygame.K_w]:
            y_inc = -self.speed
            self.walking_animation.state = 0
            if not self.attack_animation.is_animated:
                self.attack_animation.state = 2

        if keys[pygame.K_s]:
            y_inc =  self.speed
            self.walking_animation.state = 0
            if not self.attack_animation.is_animated:
                self.attack_animation.state = 0
                
        if keys[pygame.K_a]:
            x_inc = -self.speed
            self.walking_animation.state = 1
            self.walking_animation.flip_x = True
            if not self.attack_animation.is_animated:
                self.attack_animation.state = 3

        if keys[pygame.K_d]:
            x_inc =  self.speed
            self.walking_animation.state = 1
            if not self.attack_animation.is_animated:
                self.attack_animation.state = 1


        self.walking_animation.is_animated = True
        self.attack_animation.is_animated = True
        self.player_velocity = pygame.Vector2(x_inc, y_inc)
        self.increment_position(x_inc*self.dt, y_inc*self.dt)
    
    def attack_action(self, keys:pygame.key.ScancodeWrapper):
        if not self.is_cooldown:
            direction = pygame.Vector2(0, 0)

            if keys[pygame.K_UP]:
                direction.y = -1
                self.attack_animation.state = 2
                
            elif keys[pygame.K_DOWN]:
                direction.y =  1
                self.attack_animation.state = 0
                
            elif keys[pygame.K_RIGHT]:
                direction.x =  1
                self.attack_animation.state = 1
                
            elif keys[pygame.K_LEFT]:
                direction.x = -1
                self.attack_animation.state = 3

            new_projectile = Projectile(
                projectile_pos=self.player_pos.copy(),
                projectile_direction=direction,
                player_velocity=self.player_velocity.copy(),
                screen=self.screen,
                projectile_speed=self.projectile_speed,
                projectile_damage=self.projectile_damage
            )

            self.attack_animation.is_animated = True
            self.projectiles_in_action.append(new_projectile)
            self.is_cooldown = True

    def update_cooldown(self, dt:float, framerate:int):
        if self.is_cooldown:
            self.cooldown += self.dt*self.projectile_frequency

        if self.cooldown >= 1.0:
            self.cooldown = 0
            self.is_cooldown = False

    def update_position(self, x:float, y:float):
        self.player_pos.x = x
        self.player_pos.y = y

    def update_projectiles(self, dt:float, framerate:int):
        for projectile in self.projectiles_in_action:
            if projectile.update(dt, framerate):
                self.projectiles_in_action.remove(projectile)
                del projectile

    def increment_position(self, x_inc:float = 0, y_inc:float = 0):
        (x_inc, y_inc) = self.assert_bounds_increment(x_inc, y_inc)

        self.player_pos.x += x_inc
        self.player_pos.y += y_inc

    def update(self, dt, framerate):
        self.update_dt(dt)
        self.update_cooldown(dt, framerate)
        self.update_projectiles(dt, framerate)
        self.attack_animation.update(dt)
        self.walking_animation.update(dt)

    def draw(self):
        self.walking_animation.draw(self.player_pos.x, self.player_pos.y + 0.5*self.player_radius)
        self.attack_animation.draw(self.player_pos.x, self.player_pos.y - self.player_radius)

class Projectile(MovingEntity):
    def __init__(
            self, 
            projectile_pos: pygame.Vector2,
            projectile_direction: pygame.Vector2,
            player_velocity: pygame.Vector2,
            screen: pygame.Surface,
            projectile_radius: int = 10,
            projectile_speed: int = 300,
            projectile_damage: int = 300,
            projectile_lifetime: int = 1,
        ):
        super().__init__(screen=screen)
        self.player_velocity = player_velocity
        self.projectile_pos = projectile_pos
        self.projectile_direction = projectile_direction
        self.projectile_radius = projectile_radius

        self.projectile_speed = projectile_speed
        self.projectile_damage = projectile_damage
        self.projectile_lifetime = projectile_lifetime 

    def update_position(self) -> bool:
        is_illegal = False

        if self.assert_bounds():
            self.projectile_pos += (self.projectile_direction*self.projectile_speed + self.player_velocity)*self.dt
            is_illegal = False
        else:
            is_illegal = True

        return is_illegal

    def update_remaining_lifetime(self, framerate) -> bool:
        self.projectile_lifetime -= self.dt

        return self.projectile_lifetime < 0

    def assert_bounds(self) -> bool:
        increment = (self.projectile_direction*self.projectile_speed + self.player_velocity)*self.dt

        projectile_pos_x = self.projectile_pos.x
        projectile_pos_y = self.projectile_pos.y

        if (projectile_pos_x - self.projectile_radius) + increment.x < 0:
            return False

        if (projectile_pos_x + self.projectile_radius) + increment.x > self.screen_width:
            return False

        if (projectile_pos_y - self.projectile_radius) + increment.y < 0:
            return False

        if (projectile_pos_y + self.projectile_radius) + increment.y > self.screen_height:
            return False

        return True

    def update(self, dt, framerate) -> bool:
        destroy_tear = False

        self.update_dt(dt)
        destroy_tear = destroy_tear or self.update_position()
        destroy_tear = destroy_tear or self.update_remaining_lifetime(framerate)

        self.draw()


        return destroy_tear

    def draw(self):
        pygame.draw.circle(self.screen, "blue", self.projectile_pos, self.projectile_radius)