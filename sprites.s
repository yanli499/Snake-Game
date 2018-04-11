.equ ADDR_VGA, 0x08000000

.equ ADDR_CHAR, 0x09000000

.equ DARK_RED, 0x0000D000

.equ MID_RED, 0x0000F800

.equ LIGHT_RED, 0x0000FBEF

.equ MID_GREEN, 0x00005BE0

.equ DARK_GREEN, 0x00004300





.equ X_SEPERATE, 0x0FF00000

.equ Y_SEPERATE, 0x000FF000

.equ COORD_SEPERATE, 0x0FFFF000

.equ LENGTH_SEPERATE, 0x00000FFF

.global SET_SCREEN

SET_SCREEN: #r6 input


addi sp, sp, -12


stw r16, 0(sp)

stw r17, 4(sp)

stw ra, 8(sp)


movi r16, 40

movi r17, 30

movi r4, -1 #Xpos

movi r5, -1 #Ypos


Y_LOOP_CLEAR:

addi r5, r5, 1

beq r5, r17, END_DRAW_CLEAR


movi r4, -1


X_LOOP_CLEAR:

addi r4, r4, 1

beq r4, r16, Y_LOOP_CLEAR


call DRAW_TILE


br X_LOOP_CLEAR


END_DRAW_CLEAR:


ldw r16, 0(sp)

ldw r17, 4(sp)

ldw ra, 8(sp)


addi sp, sp, 12


ret


SET_SCREEN_BMP: #r6 input, #r7 address input


addi sp, sp, -12


stw r16, 0(sp)

stw r17, 4(sp)

stw ra, 8(sp)


movi r16, 40

movi r17, 30

movi r4, -1 #Xpos

movi r5, -1 #Ypos


Y_LOOP_CLEAR_BMP:

addi r5, r5, 1

beq r5, r17, END_DRAW_CLEAR_BMP


movi r4, -1


X_LOOP_CLEAR_BMP:

addi r4, r4, 1

beq r4, r16, Y_LOOP_CLEAR_BMP

ldw r6, 0(r7)

call DRAW_TILE

addi r7, r7, 2


br X_LOOP_CLEAR_BMP


END_DRAW_CLEAR_BMP:


ldw r16, 0(sp)

ldw r17, 4(sp)

ldw ra, 8(sp)


addi sp, sp, 12


ret



.global DRAW_TILE


DRAW_TILE: #r4 is x, r5 is y, r6 is colour


addi sp, sp, -20

stw r16, 0(sp)

stw r17, 4(sp)

stw r18, 8(sp)

stw r19, 12(sp)

stw r20, 16(sp)


movia r16, ADDR_VGA #load in base

#find first address


movi r17, 8

mul r18, r17, r4 #multiply x grid pos by 8 to get x coord

mul r19, r17, r5 #multiply y grid pos by 8 to get y coord


movi r17, 2

mul r20, r17, r18 #multiply x coord by 2 to get x offset

add r16, r20, r16 #add x offset to address


movi r17, 1024

mul r20, r17, r19 #multiply y coord by 1024 to get y offset

add r16, r20, r16 #add y offset to address


movi r18, 8

movi r19, -1

movi r20, -1


Y_LOOP:

addi r20, r20, 1

beq r20, r18, END_DRAW


movi r19, -1


X_LOOP:

addi r19, r19, 1

beq r19, r18, RESET_OFFSET


sthio r6,0(r16)


movi r17, 2

add r16, r17, r16 #add x offset to address


br X_LOOP


RESET_OFFSET:


movi r17, -16

add r16, r17, r16 #add offset to address

movi r17, 1024

add r16, r17, r16 #add offset to address

br Y_LOOP


END_DRAW:


ldw r16, 0(sp)

ldw r17, 4(sp)

ldw r18, 8(sp)

ldw r19, 12(sp)

ldw r20, 16(sp)


addi sp, sp, 20


ret



.global DRAW_APPLE


DRAW_APPLE:


addi sp, sp, -20

stw r16, 0(sp)

stw r17, 4(sp)

stw r18, 8(sp)

stw r19, 12(sp)

stw r20, 16(sp)


movia r16, ADDR_VGA #load in base

#find first address


movi r17, 8

mul r18, r17, r4 #multiply x grid pos by 8 to get x coord

mul r19, r17, r5 #multiply y grid pos by 8 to get y coord


movi r17, 2

mul r20, r17, r18 #multiply x coord by 2 to get x offset

add r16, r20, r16 #add x offset to address


movi r17, 1024

mul r20, r17, r19 #multiply y coord by 1024 to get y offset

add r16, r20, r16 #add y offset to address


addi r16, r16, 8 #first row

movia r17, MID_GREEN

sthio r17,0(r16)


addi r16, r16, -8 #second row

addi r16, r16, 1024


addi r16, r16, 2

movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, MID_GREEN

sthio r17,0(r16)


addi r16, r16, 2

movia r17, DARK_GREEN

sthio r17,0(r16)


addi r16, r16, 2

movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, -12 #third row

addi r16, r16, 1024


sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, -14 #fourth row

addi r16, r16, 1024


sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, LIGHT_RED

sthio r17,0(r16)


addi r16, r16, 2

movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, DARK_RED

sthio r17,0(r16)


addi r16, r16, -14 #fifth row

addi r16, r16, 1024


movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, LIGHT_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, DARK_RED

sthio r17,0(r16)


addi r16, r16, -14 #sixth row

addi r16, r16, 1024


movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2


movia r17, DARK_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, -14 #seventh row

addi r16, r16, 1024


addi r16, r16, 2

movia r17, DARK_RED

sthio r17,0(r16)


addi r16, r16, 2

movia r17, MID_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

movia r17, DARK_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, -12 #eighth row

addi r16, r16, 1024


addi r16, r16, 4

movia r17, DARK_RED

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


addi r16, r16, 2

sthio r17,0(r16)


ldw r16, 0(sp)

ldw r17, 4(sp)

ldw r18, 8(sp)

ldw r19, 12(sp)

ldw r20, 16(sp)


addi sp, sp, 20


ret
