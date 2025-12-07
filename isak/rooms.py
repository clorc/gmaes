import pygame

class Floor():
    def __init__(self):
        pass

class Room():
    def __init__(
            self,
            screen: pygame.Surface,
            room_sheet: pygame.Surface,
        ):
        self.width = screen.get_width()
        self.height = screen.get_height()
        self.screen = screen

        self.room_sheet = room_sheet
        self.room_sprite = pygame.Rect(0, 0, 234, 156)
        self.scaled_sprite = pygame.transform.scale(self.room_sheet.subsurface(self.room_sprite),size=(self.width/2, self.height/2))

    def draw(self):
        R_11 = pygame.transform.flip(self.scaled_sprite, flip_x=False, flip_y=False)
        self.screen.blit(R_11, (0,0))

        R_12 = pygame.transform.flip(self.scaled_sprite, flip_x=True , flip_y=False)
        self.screen.blit(R_12, (self.width/2,0))
        
        R_21 = pygame.transform.flip(self.scaled_sprite, flip_x=False, flip_y=True )
        self.screen.blit(R_21, (0,self.height/2))
        
        R_22 = pygame.transform.flip(self.scaled_sprite, flip_x=True , flip_y=True )
        self.screen.blit(R_22, (self.width/2,self.height/2))


class TreasureRoom(Room):
    def __init__(self):
        super().__init__()
        pass

class SecretRoom(Room):
    def __init__(self):
        super().__init__()
        pass

class BossRoom(Room):
    def __init__(self):
        super().__init__()
        pass

class Shop(Room):
    def __init__(self):
        super().__init__()
        pass
