.equ PS2, 0xFF200100
.equ LED, 0xFF200000

.global KEY_SETUP

KEY_SETUP:


	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)

	movia r17, PS2
    
    #Enable PS2 read interrupts
    movi r16, 1
    stwio r16, 4(r17)
    
    #Enable external interrupts (PS2 IRQ 7)
    movi r16, 0x0080
	wrctl ctl3, r16
	
	movi r16, 1
	wrctl ctl0, r16
	
	ldw r16,0(sp)
	ldw r17, 4(sp)
	addi sp,sp,8
	
ret

    
LOOP:
	#Make sure PS2 read interrupts are enabled
	#movi r9, 1
    #stwio r9, 4(r7)
	br LOOP
    
.section .exceptions, "ax"
.global ISR

ISR:
	#Store et, ea, ctl1, r9-r15 (r8 is addr of PS2)
	subi sp, sp, 48
    stw et, 0(sp)
    #rdctl et, ctl1 IGNORE FOR NOW
    #stw et, 4(sp)
    stw ea, 8(sp)
    stw r9, 12(sp)
    stw r10, 16(sp)
    stw r11, 20(sp)
    stw r12, 24(sp)
    stw r13, 28(sp)
    stw r14, 32(sp) 
    stw r15, 36(sp)
	stw r16, 40(sp)
	stw r17, 44(sp)

	movia r16, PS2
    
    #Check IRQ 7
    rdctl et, ctl4
    andi et, et, 0x0080
    bne et, r0, IRQ7
    
    br END

IRQ7:
	#Disable read interrupt
    ldwio r9, 4(r16)
    andi r9, r9, 0x1E11
    stwio r9, 4(r16)
    
	#Check if error (1 if Error?)
    ldwio r9, 4(r16)
    andi r9, r9, 0x0400
    bne r9, r0, ErrIRQ7
    
    #If IRQ 7 != 0, check read interrupt is pending
    ldwio et, 4(r16)
	andi et, et, 0x0100
	beq et, r0, END
    
    #Reset data pending
    mov r9, r0
    stwio r9, 4(r16)
    
    #ONLY LOAD FROM 0(r17) once, because each load = FIFO-1
    
    #If IRQ7 read is pending, check data valid
    ldwio et, 0(r16)
	movia r9, 0x8000
	and r10, et, r9
	beq r10, r0, END
    
    #If IRQ7 data valid, get data
	andi et, et, 0x00FF
    br PS2Process

PS2Process:
	#Do something with data from PS2 Keyboard
	#Keys: ASDW, r10 contains data
    movi r11, 0x1C #A (Make Code)
    movi r12, 0x1B #S
    movi r13, 0x23 #D
    movi r14, 0x1D #W
    movi r9, 0xF0 #Break code
    
    #TEMP: ADDED FOR LEDs
    movia r15, LED
    
    beq et, r11, LED_A
    beq et, r12, LED_S
    beq et, r13, LED_D
    beq et, r14, LED_W
    
    movi r14, 0x5A #Enter
    beq et, r14, LED_Enter
    beq et, r9, LED_Break
	br END

#ADDED LED INDICATOR
LED_A:
	#A=001

	movia r14, 0x0FFFFFFF

	and r8, r8, r14

	movia r14, 0x30000000

	or r8, r8, r14

    movi r9, 0x01
    stwio r9, 0(r15)
    #Call drawing function here?
	br END
LED_S:
	#S=010

	movia r14, 0x0FFFFFFF

	and r8, r8, r14

	movia r14, 0x10000000

	or r8, r8, r14

    movi r9, 0x02
    stwio r9, 0(r15)
    br END
LED_D:
	#D=011

	movia r14, 0x0FFFFFFF

	and r8, r8, r14

	movia r14, 0x20000000

	or r8, r8, r14

    movi r9, 0x03
    stwio r9, 0(r15)
    br END
LED_W:
	#W=100

	movia r14, 0x0FFFFFFF

	and r8, r8, r14



    movi r9, 0x04
    stwio r9, 0(r15)
    br END
LED_Enter:
	#Set as 111
    movi r9, 0x07
    stwio r9, 0(r15)
    movi r3, 1
    br END
LED_Break:
	#Set as 101
    movi r9, 0x05
    stwio r9, 0(r15)
    br END

    
ErrIRQ7:
	#Reset read pending + error detected, (re)enable read interrupt
    movi r9, 0x0001    
    stwio r9, 4(r16)
    br END 

END:
	
	movi r9, 1
	stwio r9, 4(r16)

	#wrctl ctl0, 0 #Disable interrupts when restoring

	ldw r17, 44(sp)
	ldw r16, 40(sp)
    ldw r15, 36(sp)
    ldw r14, 32(sp)
    ldw r13, 28(sp)
    ldw r12, 24(sp)
    ldw r11, 20(sp)
    ldw r10, 16(sp)
    ldw r9, 12(sp)
    #ldw et, 8(sp) Don't need this for now
    #wrctl ctl1, et
    ldw ea, 8(sp)
    ldw et, 0(sp)
    
    subi ea, ea, 4
    addi sp, sp, 48
    eret

    
