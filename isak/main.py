import pygame
from player import Player
from animation import Animation
from rooms import Room

pygame.init()
screen = pygame.display.set_mode((936,624))
clock = pygame.time.Clock()

framerate = 60

running = True
dt = 0
time_passed = 0


player = Player(
    player_pos=pygame.Vector2(screen.get_width()/2, screen.get_height()/2),
    screen=screen

)

start_room = Room(
    screen=screen,
    room_sheet= pygame.image.load("./assets/floor_sheet.png")
)





while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    start_room.draw()
    
    
    player.update(dt, framerate)

    keys = pygame.key.get_pressed()
    player.listen_for_key_press(keys)
    player.draw()

    pygame.display.flip()
    dt = clock.tick(framerate)/1000

    screen.fill("black")


pygame.quit()