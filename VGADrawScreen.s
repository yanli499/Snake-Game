.equ VGA, 0x08000000

.global StartBMP
StartBMP:
	.incbin "title.bmp"


#Subroutine called at beginning and end of game
#r4 passed in to choose start or end screen
.global Draw_Screen
Draw_Screen:
	subi sp, sp, 20
    stw r13, 0(sp)
    stw r14, 4(sp)
    stw r15, 8(sp)
    stw r16, 12(sp)
    stw r17, 16(sp)
    
	movia r13, VGA #r8
	#Addr of BMP is passed in as argument r4
    
    #Skip header
    addi r4, r4, 68
    
	#Set temp var to 0
    movi r14, 0
    movi r15, 0

    br X_LOOP

X_LOOP:
    #Travel along X
    addi r14, r14, 1
    movi r16, 320 #Final column
    beq r14, r16, Y_LOOP

    #Load color bit to VGA
    ldh r16, 0(r4)
    sthio r16, 0(r13)

    #Increment BMP + VGA X Offset
    addi r4, r4, 2
    addi r13, r13, 2
    br X_LOOP

Y_LOOP:
    #Travel along Y
    addi r15, r15, 1
    movi r16, 240 #Final row
    beq r15, r16, Done_Draw

    #Increment VGA Y Addr
	subi r13, r13, 638
    addi r13, r13, 1024
	addi r4, r4, 2
	movi r14, 0
    br X_LOOP

Done_Draw:
    ldw r13, 0(sp)
    ldw r14, 4(sp)
    ldw r15, 8(sp)
    ldw r16, 12(sp)
    ldw r17, 16(sp)
    addi sp, sp, 20
	ret
