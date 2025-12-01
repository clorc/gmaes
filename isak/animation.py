import pygame
import math

class MovingEntity():
    def __init__(
            self, 
            screen: pygame.Surface
        ):
        self.screen = screen
        self.screen_width = self.screen.get_width()
        self.screen_height = self.screen.get_height()

        self.width_margin = self.screen_width/9.0
        self.height_margin = self.screen_height/6.0

        self.dt = 0
    
    def update_dt(self, dt):
        self.dt = dt

class Animation(MovingEntity):
    def __init__(
            self, 
            screen: pygame.Surface,
            sprite_sheet: pygame.Surface,
            size: int,
            start_x: int, 
            start_y: int, 
            spacing: int,
            frame_axis: int,
            framerate: int,
            frames: int, 
            width: int,
            height: int,
            state_init: int = 0,
            state_spacing_x: int = 0,
            state_spacing_y: int = 0,
            state_num: int = 1,
            abrupt: bool = False,
            reverse: bool = False,
            n_repeats: int = 1,
        ):
        super().__init__(screen)
        self.sprite_sheet = sprite_sheet
        self.size = size

        self.start_x = start_x
        self.start_y = start_y
        self.framerate = framerate
        self.frames = frames
        self.width = width
        self.height = height
        self.spacing = spacing
        self.frame_axis = frame_axis

        self.state = state_init
        self.state_spacing_x = state_spacing_x
        self.state_spacing_y = state_spacing_y
        self.state_num = state_num

        self.flip_x = False

        self.is_animated = False
        self.abrupt = abrupt
        self.reverse = reverse
        self.n_repeats = n_repeats
        self.curr_repeat = 0

        self.curr_sprite = pygame.Rect(self.start_x,self.start_y,self.width, self.height)
        self.time = 0
        self.current_frame = 0

    def set_state(self, state):
        self.state = state % self.state_num
        self.curr_sprite = pygame.Rect(
                self.start_x + self.state_spacing_x * self.state,
                self.start_y + self.state_spacing_y * self.state,
                self.width,
                self.height
            )

    def update(self, dt):
        if (self.is_animated or (self.time*(1-int(self.abrupt))) >= 5e-3) and (self.curr_repeat <= self.n_repeats):
            self.update_dt(dt)

            self.time = (self.time + dt) % 1
            self.current_frame = math.floor(self.time * self.framerate)

            if self.current_frame == self.frames:
                self.curr_repeat += 1
                self.current_frame = 0
                self.update(dt)
                return

            if self.reverse:
                self.curr_sprite = pygame.Rect(
                    self.start_x + (self.width + self.spacing)*(self.frames - self.current_frame - 1)*(1-self.frame_axis) + self.state_spacing_x * self.state,
                    self.start_y + (self.height + self.spacing)*(self.frames - self.current_frame - 1)*self.frame_axis + self.state_spacing_y * self.state,
                    self.width,
                    self.height
                )

            else:
                self.curr_sprite = pygame.Rect(
                    self.start_x + (self.width + self.spacing)*self.current_frame*(1-self.frame_axis) + self.state_spacing_x * self.state,
                    self.start_y + (self.height + self.spacing)*self.current_frame*self.frame_axis + self.state_spacing_y * self.state,
                    self.width,
                    self.height
                )

        else:
            self.time = 0
            self.current_frame = 0
            self.curr_repeat = 0

            self.curr_sprite = pygame.Rect(
                    self.start_x + self.state_spacing_x * self.state,
                    self.start_y + self.state_spacing_y * self.state,
                    self.width,
                    self.height
                )


    def draw(self, x, y):
        transformed = pygame.transform.scale_by(self.sprite_sheet.subsurface(self.curr_sprite),factor=self.size)
        transformed = pygame.transform.flip(transformed, flip_x=self.flip_x, flip_y=False)

        self.screen.blit(
            transformed,
            (x-(self.width*self.size)/2, y-(self.height*self.size)/2)
        )