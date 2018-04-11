.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ DARK_RED, 0x0000D000
.equ MID_RED, 0x0000F800
.equ LIGHT_RED, 0x0000FBEF
.equ MID_GREEN, 0x00005BE0
.equ DARK_GREEN, 0x00004300
.equ AUDIO_IN, 0xFF203040
.equ X_SEPERATE, 0x0FF00000
.equ Y_SEPERATE, 0x000FF000
.equ COORD_SEPERATE, 0x0FFFF000
.equ LENGTH_SEPERATE, 0x00000FFF


.section .data
.global SNAKE_TRAIL
SNAKE_TRAIL:
    .skip 4800 #4 bytes per snake location -> 1200 words

.global SNAKE_LAST
SNAKE_LAST:
    .skip 4


.section .text
.global DRAW_SNAKE_PART
DRAW_SNAKE_PART: #Get snake body data
    addi sp, sp, -4
    stw ra, 0(sp)

	#Load coordinates and color
    mov r5, r4
    movia r11, X_SEPERATE
    and r4, r4, r11
    srli r4, r4, 20 

    movia r11, Y_SEPERATE
    and r5, r5, r11
    srli r5, r5, 12 

    movia r6, MID_GREEN

    call DRAW_TILE

    ldw ra, 0(sp)
    addi sp, sp, 4
    ret

.global DRAW_SNAKE
DRAW_SNAKE: #Draw entire snake
    addi sp, sp, -20
    stw ra, 0(sp)
    stw r16, 4(sp)
    stw r17, 8(sp)
    stw r18, 12(sp)
    stw r19, 16(sp)

    mov r16, r8
    movia r17, 0x00000FFF
    and r16, r16, r17
    #r16 holds length of the snake

    mov r4, r8

    call DRAW_SNAKE_PART

    movi r19, -1

DRAW_TRAIL:
    subi r16, r16, 1
    beq r16, r19, DRAW_SNAKE_END #draw tail from back to front

    movia r17, SNAKE_TRAIL #r17 holds current memory address of drawn tail

    add r17, r16, r17
    add r17, r16, r17
    add r17, r16, r17
    add r17, r16, r17

    ldw r18, 0(r17) #load in XY pos for given tail part

    slli r4, r18, 12 #shift to make 0x0XXYY000 instead of 0x0000XXYY

    call DRAW_SNAKE_PART

    br DRAW_TRAIL

DRAW_SNAKE_END:
    ldw ra, 0(sp)
    ldw r16, 4(sp)
    ldw r17, 8(sp)
    ldw r18, 12(sp)
    ldw r19, 16(sp)
    addi sp, sp, 20

    ret

.global SET_TAIL
SET_TAIL: #Called before movement
    addi sp, sp, -16
    stw r16, 0(sp)
    stw r17, 4(sp)
    stw r18, 8(sp)
    stw r19, 12(sp)

    mov r16, r8
    movia r17, 0x00000FFF
    and r16, r16, r17 #r16 holds only the length of the snake

    #beq r0, r16, SET_TAIL_END

    addi r16, r16, 1

STORE_WORD:
    subi r16, r16, 1
    ble r16, r0, SET_LAST_TAIL

    movia r19, SNAKE_TRAIL

    add r19, r19, r16
    add r19, r19, r16
    add r19, r19, r16
    add r19, r19, r16 #holds current tail part selection

    ldw  r17, -4(r19) #load the next tail block coords
    stw r17, 0(r19) #store into current 

    br STORE_WORD

SET_LAST_TAIL:
    #store final from r8
    movia r19, SNAKE_LAST
    ldw r17, 0(r19)

    movia r19, COORD_SEPERATE
    and r17, r17, r19
    srli r17, r17, 12

    movia r19, SNAKE_TRAIL
    stw r17, 0(r19)

SET_TAIL_END:
    ldw r19, 12(sp)
    ldw r18, 8(sp)
    ldw r17, 4(sp)
    ldw r16, 0(sp)
    addi sp, sp, 16
    ret


.global CHECK_COLLISION
CHECK_COLLISION:
    #called AFTER X Y move, BEFORE the draw
    addi sp, sp, -24
    stw r16, 0(sp)
    stw r17, 4(sp)
    stw r18, 8(sp)
    stw r19, 12(sp)
    stw r20, 16(sp)
    stw ra, 20(sp)

    movia r16, COORD_SEPERATE
    and r16, r8, r16
    srli r16, r16, 12

CHECK_APPLE:
    bne r16, r10, CHECK_SNAKE
    addi r8, r8, 1 #add 1 to length

    #reset apple position
    #add to score
    addi r9, r9, 1

    call HEXScore #Update score and activate beeping sound

    call SoundEffect

RESET_APPLE:
    movia r18, 0x00000FFF
    and r17, r8, r18
    movi r18, -1
    movia r4, AUDIO_IN
    ldw r4, 8(r4)

    call rng #C code, random value generator

RESET_APPLE_LOOP:
    subi r17, r17, 1
    beq r17, r18, RESET_APPLE_END #check tail from back to front

    movia r19, SNAKE_TRAIL #r17 holds current memory address of drawn tail

    add r19, r17, r19
    add r19, r17, r19
    add r19, r17, r19
    add r19, r17, r19

    ldw r20, 0(r19) #load in XY pos for given tail part

    beq r20, r2, RESET_APPLE

RESET_APPLE_END:
    beq r10, r2, RESET_APPLE
    mov r10, r2

CHECK_SNAKE:
    movia r18, 0x00000FFF
    and r17, r8, r18
    movi r18, -1

CHECK_SNAKE_LOOP:
    subi r17, r17, 1
    beq r17, r18, CHECK_COLLISION_END #check tail from back to front
    movia r19, SNAKE_TRAIL #r17 holds current memory address of drawn tail

    add r19, r17, r19
    add r19, r17, r19
    add r19, r17, r19
    add r19, r17, r19

    ldw r20, 0(r19) #load in XY pos for given tail part

    beq r20, r16, GAME_OVER_COL

    br CHECK_SNAKE_LOOP

GAME_OVER_COL:
    movi r3, 0
    call GameOverSoundEffect
    br CHECK_SNAKE_LOOP

CHECK_COLLISION_END:
    ldw r16, 0(sp)
    ldw r17, 4(sp)
    ldw r18, 8(sp)
    ldw r19, 12(sp)
    ldw r20, 16(sp)
    ldw ra, 20(sp)
    addi sp, sp, 24
    ret
