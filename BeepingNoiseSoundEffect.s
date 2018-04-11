
.equ AUCore, 0xFF203040

.global SoundEffect

SoundEffect:
	subi sp, sp, 28
    stw r5, 20(sp)
    stw r19, 24(sp)
    stw r14, 0(sp)
    stw r15, 4(sp)
    stw r16, 8(sp)
    stw r17, 12(sp)
    stw r18, 16(sp)


	movia r14, AUCore
    #movia r15, Noise
    movi r18, 250
    
    movi r19, 24				# Half period = 48 samples
    movia r15, 0x60000000	# Audio sample value
    mov r5, r19

WaitForWriteSpace:
    ldwio r16, 4(r14)
    andhi r17, r16, 0xFF00
    beq r17, r0, WaitForWriteSpace
    andhi r17, r16, 0xFF
    beq r17, r0, WaitForWriteSpace
    
WriteTwoSamples:
	#ldw r17, 0(r15)
    stwio r15, 8(r14)
    stwio r15, 12(r14)
    
    #Increment Noise addr and check if end reached
    #Crunch = 61764 words
    #addi r15, r15, 4
    #movia r18, 0x0F144
    #beq r15, r18, End_Sound
    #br WaitForWriteSpace
    
    subi r5, r5, 1
    bne r5, r0, WaitForWriteSpace
    
HalfPeriodInvertWaveform:
    mov r5, r19
    sub r15, r0, r15				# 32-bit signed samples: Negate.
    subi r18, r18, 1
    beq r18, r0, End_Sound
    br WaitForWriteSpace
    
End_Sound:
    ldw r14, 0(sp)
    ldw r15, 4(sp)
    ldw r16, 8(sp)
    ldw r17, 12(sp)
    ldw r18, 16(sp)
    ldw r5, 20(sp)
    ldw r19, 24(sp)
	addi sp, sp, 28
    ret

.global GameOverSoundEffect

GameOverSoundEffect:
	subi sp, sp, 28
    stw r5, 20(sp)
    stw r19, 24(sp)
    stw r14, 0(sp)
    stw r15, 4(sp)
    stw r16, 8(sp)
    stw r17, 12(sp)
    stw r18, 16(sp)


	movia r14, AUCore
    #movia r15, Noise
    movi r18, 250
    
    movi r19, 192				# Half period = 48 samples
    movia r15, 0x60000000	# Audio sample value
    mov r5, r19

WaitForWriteSpaceGO:
    ldwio r16, 4(r14)
    andhi r17, r16, 0xFF00
    beq r17, r0, WaitForWriteSpaceGO
    andhi r17, r16, 0xFF
    beq r17, r0, WaitForWriteSpaceGO
    
WriteTwoSamplesGO:
	#ldw r17, 0(r15)
    stwio r15, 8(r14)
    stwio r15, 12(r14)
    
    #Increment Noise addr and check if end reached
    #Crunch = 61764 words
    #addi r15, r15, 4
    #movia r18, 0x0F144
    #beq r15, r18, End_Sound
    #br WaitForWriteSpace
    
    subi r5, r5, 1
    bne r5, r0, WaitForWriteSpaceGO
    
HalfPeriodInvertWaveformGO:
    mov r5, r19
    sub r15, r0, r15				# 32-bit signed samples: Negate.
    subi r18, r18, 1
    beq r18, r0, End_SoundGO
    br WaitForWriteSpaceGO
    
End_SoundGO:
    ldw r14, 0(sp)
    ldw r15, 4(sp)
    ldw r16, 8(sp)
    ldw r17, 12(sp)
    ldw r18, 16(sp)
    ldw r5, 20(sp)
    ldw r19, 24(sp)
	addi sp, sp, 28
    ret

