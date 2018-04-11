.equ HEX0_3, 0xFF200020
#Bit 6-0: HEX0
#Bit 14-8: HEX1
#1 ON, 0 OFF

#Subroutine, called in Snake.s whenever the score variable is updated
.global HEXScore
HEXScore:
	#Assume take in r9 containing current score (Hex)
	subi sp, sp, 20
    stw r16, 0(sp)
    stw r17, 4(sp)
    stw r18, 8(sp)
    stw r19, 12(sp)
    stw r20, 16(sp)
    
    #TEMP: Set r4 to test

Hex2Dec:
	movia r16, HEX0_3
    mov r17, r9 #Use r17 for calc (Will hold Ones digit)
    mov r19, r0 #Set r19 as 0 to start
CalcDigits:
    #Convert Hex to Dec
    #Separate score into diff displays (2 digits)
    
    /* Pseudo
    int tens = 0 (r19)
    while score > 10 {
    	score = score - 10
        tens ++
    }
    if else for Ones place (score aft while loop)
    if else for Tens place (tens)
    */
    
    #If score less than 10
    movi r20, 10
    blt r17, r20, ProcessOnes
    
    #Score = greater than 10
    subi r17, r17, 10
    addi r19, r19, 1
    br CalcDigits
    
ProcessOnes:
    movi r18, 0
    beq r17, r18, Display_0_Ones
    movi r18, 1
    beq r17, r18, Display_1_Ones
    movi r18, 2
    beq r17, r18, Display_2_Ones
    movi r18, 3
    beq r17, r18, Display_3_Ones
    movi r18, 4
    beq r17, r18, Display_4_Ones
    movi r18, 5
    beq r17, r18, Display_5_Ones
    movi r18, 6
    beq r17, r18, Display_6_Ones
    movi r18, 7
    beq r17, r18, Display_7_Ones
    movi r18, 8
    beq r17, r18, Display_8_Ones
    movi r18, 9
    beq r17, r18, Display_9_Ones
ProcessTens:
	movi r18, 0
    beq r19, r18, Display_0_Tens
    movi r18, 1
    beq r19, r18, Display_1_Tens
    movi r18, 2
    beq r19, r18, Display_2_Tens
    movi r18, 3
    beq r19, r18, Display_3_Tens
    movi r18, 4
    beq r19, r18, Display_4_Tens
    movi r18, 5
    beq r19, r18, Display_5_Tens
    movi r18, 6
    beq r19, r18, Display_6_Tens
    movi r18, 7
    beq r19, r18, Display_7_Tens
    movi r18, 8
    beq r19, r18, Display_8_Tens
	movi r18, 9
    beq r19, r18, Display_9_Tens
    
Display_0_Ones: #HEX0
	#Make sure not to overwrite other digits, reset before re-writing
    ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00 #Keep Tens digit, reset Ones digit
	movia r17, 0x0000003F #Activate seg 0-5
    or r17, r17, r18 #Turn on both HEX
    stwio r17, 0(r16) #Write to 7-seg
    br ProcessTens 
Display_1_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x00000006 #Seg 1-2
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_2_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x0000005B #Seg 0,1,3,4,6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_3_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x0000004F #Seg 0-3,6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_4_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x00000066 #Seg 1,2,5,6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_5_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x0000006D #Seg 0,2,3,5,6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_6_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x0000007D #Seg 0,2,3,4,5,6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_7_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x00000007 #Seg 0,1,2
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_8_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x0000007F #Seg 0-6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
Display_9_Ones:
	ldwio r18, 0(r16)
    andi r18, r18, 0x00007F00
    movia r17, 0x0000006F #Seg 0,1,2,3,5,6
    or r17, r17, r18
    stwio r17, 0(r16)
    br ProcessTens
    
Display_0_Tens: #HEX1
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F #Keep Ones digit, reset Tens
    movia r17, 0x00003F00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_1_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00000600
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_2_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00005B00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_3_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00004F00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_4_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00006600
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_5_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00006D00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_6_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00007D00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_7_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00000700
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_8_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00007F00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
Display_9_Tens:
	ldwio r18, 0(r16)
    andi r18, r18, 0x0000007F
    movia r17, 0x00006F00
    or r17, r17, r18
    stwio r17, 0(r16)
    br Score_Exit
    
Score_Exit:
	ldw r16, 0(sp)
    ldw r17, 4(sp)
    ldw r18, 8(sp)
    ldw r19, 12(sp)
    ldw r20, 16(sp)
    addi sp, sp, 20
    
    ret

	
