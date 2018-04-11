.global ANIMATE_DELAY
ANIMATE_DELAY:
	
	addi sp,sp,-20
	stw r16, 0(sp)
	stw r17, 4(sp)
	stw r18, 8(sp)
	stw r19, 12(sp)
	stw r20, 16(sp)
	movia r16, 0xff202000

	sthio r0, 0(r16)

	movia r18, 4
	sthio r18, 4(r16) #stop the timer
	
	

	ldwio r18, 0(r16)
	andi r18, r18, 254
	stbio r18, 0(r16) #clear the timeout
	
	movia r17, 0x0000E100 #100 MHz period - lower half
	sthio r4, 8(r16) #Timer low

	movia r17, 0x000000A5 #100 MHz period - upper half
	sthio r17, 12(r16) #Timer high
	
	
	ldwio r18, 4(r16)
	ori r18, r18, 4
	sthio r18, 4(r16) #Start the timer


	
POLL:
	ldwio r17, 0(r16)
	andi r17, r17, 1
	beq r17, r0, POLL
	
	ldw r16, 0(sp)
	ldw r17, 4(sp)
	ldw r18, 8(sp)
	ldw r19, 12(sp)
	ldw r20, 16(sp)
	addi sp,sp,20
	ret

