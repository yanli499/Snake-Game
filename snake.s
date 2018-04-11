
.equ MID_GREEN, 0x00005BE0

.equ X_SEPERATE, 0x0FF00000

.equ Y_SEPERATE, 0x000FF000

.equ APPLE_Y_SEPERATE, 0x000000FF

.equ APPLE_X_SEPERATE, 0x0000FF00

.equ PS2, 0xFF200100

.equ LED, 0xFF200000


.equ AUDIO_IN, 0xFF203040


.section .text


.global main

main:


movia sp, 0x4000000

#load random num from audio in

movia r4, AUDIO_IN

ldw r4, 8(r4)

call rng

mov r10, r2

call KEY_SETUP #enable keyboard interrupts

movia r4, StartBMP

call Draw_Screen

GAME_START:


#movia r6, 0x00000000 #Black - clear screen on startup


#call SET_SCREEN


#r8 breakdown; All important snake head values are kept here

# r8 - 0xDXXYYLLL

# D - direction (0 is UP, 1 if DOWN, 2 if RIGHT, 3 if LEFT)

# XX - X position from 0 - 39 [0x0 - 0x27] of head

# YY - Y position from 0 - 29 [0x0 - 0x1D] of head

# LLL - length of the snake from 1 - 1200 [0x1 to 0x4B0]


#r9 holds score

#r10 holds apple XY 0x0000XXYY






movi r3, 0 #for title/game over

#movia r10, 0x00000812

TITLE_LOOP:

movi r16, 1

bne r3, r16, TITLE_LOOP

br GAME_INIT

GAME_OVER_LOOP:

movia r6, 0x0000F800

call SET_SCREEN


movi r16, 1

bne r3, r16, GAME_OVER_LOOP


GAME_INIT:

movia r8, 0x10808000 #ex, snake is moving up position (8,8) with a length of 2

movi r9, 0

call HEXScore

GAME:



movia r6, 0x00001007 #Purple - clear screen on startup


call SET_SCREEN


mov r4, r10

movia r11, APPLE_X_SEPERATE

and r4, r4, r11

srli r4, r4, 8 


mov r5, r10

movia r11, APPLE_Y_SEPERATE

and r5, r5, r11




call DRAW_APPLE


mov r4, r8

movia r11, X_SEPERATE

and r4, r4, r11

srli r4, r4, 20 


mov r5, r8

movia r11, Y_SEPERATE

and r5, r5, r11

srli r5, r5, 12 


movia r6, MID_GREEN

call MOVE_SNAKE

beq r3, r0, GAME_OVER_LOOP

call CHECK_COLLISION

beq r3, r0, GAME_OVER_LOOP

call DRAW_SNAKE


call ANIMATE_DELAY


br GAME



END:

br END



MOVE_SNAKE:


addi sp, sp, -20

stw r16, 0(sp)

stw r17, 4(sp)

stw r18, 8(sp)

stw ra, 12(sp)

stw r19, 16(sp)


SNAKE_LAST_SET_NO_TAIL:


movia r16, SNAKE_LAST

stw r8, 0(r16)



CHANGE_COORDS:


mov r16, r8

srli r16, r16, 28


call SET_TAIL


beq r16, r0, MOVE_UP


movi r17, 1

beq r16, r17, MOVE_DOWN


movi r17, 2

beq r16, r17, MOVE_RIGHT


movi r17, 3

beq r16, r17, MOVE_LEFT


br END_MOVE


MOVE_UP:



movia r18, 0x000FF000

and r18, r8, r18

ble r18, r0, GAME_OVER_MOV


movia r17, 0x00001000

sub r8, r8, r17


br END_MOVE


MOVE_DOWN:


movia r18, 0x000FF000

and r18, r8, r18

movia r19, 0x0001D000

bge r18, r19, GAME_OVER_MOV


movia r17, 0x00001000

add r8, r8, r17


br END_MOVE


MOVE_RIGHT:


movia r18, 0x0FF00000

and r18, r8, r18

movia r19, 0x02700000

bge r18, r19, GAME_OVER_MOV


movia r17, 0x00100000

add r8, r8, r17


br END_MOVE


MOVE_LEFT:


movia r18, 0x0FF00000

and r18, r8, r18

ble r18, r0, GAME_OVER_MOV


movia r17, 0x00100000

sub r8, r8, r17


br END_MOVE

GAME_OVER_MOV:

call GameOverSoundEffect

movi r3, 0



END_MOVE:


ldw r16, 0(sp)

ldw r17, 4(sp)

ldw r18, 8(sp)

ldw r19, 16(sp)

ldw ra, 12(sp)

addi sp, sp, 20


ret






