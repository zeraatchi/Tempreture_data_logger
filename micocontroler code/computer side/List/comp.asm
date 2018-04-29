
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 14.745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Command_Reg=R5
	.DEF _Status_Reg=R4
	.DEF _State=R7
	.DEF _Opr_Mode=R6
	.DEF _rx_wr_index=R9
	.DEF _rx_rd_index=R8
	.DEF _rx_counter=R11
	.DEF _j=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Base_Addrs:
	.DB  0x0,0x1,0x3,0x7,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x0,0x1,0x3,0x7
_0x66:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  _Temp_Addrs
	.DW  _0x3*2

	.DW  0x04
	.DW  0x04
	.DW  _0x66*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <nRF24L01+.h>

	.DSEG

	.CSEG
_Set_Reg:
	ST   -Y,R17
	ST   -Y,R16
;	ins -> Y+2
;	i -> R16,R17
	CBI  0x18,4
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _spi
	MOV  R4,R30
	LDD  R30,Y+2
	LDI  R31,0
	ANDI R30,LOW(0xE0)
	ANDI R31,HIGH(0xE0)
	SBIW R30,0
	BRNE _0x9
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0xA)
	BREQ _0xB
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0xB)
	BREQ _0xB
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x10)
	BRNE _0xA
_0xB:
	__GETWRN 16,17,4
_0xE:
	TST  R17
	BRMI _0xF
	MOVW R30,R16
	SUBI R30,LOW(-_Temp_Addrs)
	SBCI R31,HIGH(-_Temp_Addrs)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x0
	POP  R26
	POP  R27
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0xE
_0xF:
	RJMP _0x10
_0xA:
	CALL SUBOPT_0x0
	MOV  R5,R30
_0x10:
	RJMP _0x8
_0x9:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x11
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0xA)
	BREQ _0x13
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0xB)
	BREQ _0x13
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x10)
	BRNE _0x12
_0x13:
	__GETWRN 16,17,4
_0x16:
	TST  R17
	BRMI _0x17
	MOVW R30,R16
	SUBI R30,LOW(-_Base_Addrs*2)
	SBCI R31,HIGH(-_Base_Addrs*2)
	LPM  R30,Z
	ST   -Y,R30
	CALL _spi
	__SUBWRN 16,17,1
	RJMP _0x16
_0x17:
	RJMP _0x18
_0x12:
	ST   -Y,R5
	CALL _spi
_0x18:
	RJMP _0x8
_0x11:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x19
	LDD  R30,Y+2
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x1A
	LDS  R16,_payload
	CLR  R17
_0x1B:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x1D
	MOVW R30,R16
	SUBI R30,LOW(-_payload)
	SBCI R31,HIGH(-_payload)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x0
	POP  R26
	POP  R27
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0x1B
_0x1D:
	RJMP _0x1E
_0x1A:
	CALL SUBOPT_0x0
	MOV  R5,R30
_0x1E:
	RJMP _0x8
_0x19:
	CPI  R30,LOW(0xA0)
	LDI  R26,HIGH(0xA0)
	CPC  R31,R26
	BRNE _0x8
	LDS  R16,_payload
	CLR  R17
_0x20:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x22
	LDI  R26,LOW(_payload)
	LDI  R27,HIGH(_payload)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	CALL _spi
	__SUBWRN 16,17,1
	RJMP _0x20
_0x22:
_0x8:
	SBI  0x18,4
	__DELAY_USB 49
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2080002
_ext_int2_isr:
	CALL SUBOPT_0x1
	SBI  0x17,0
	SBIS 0x18,0
	RJMP _0x27
	CBI  0x18,0
	RJMP _0x28
_0x27:
	SBI  0x18,0
_0x28:
	TST  R6
	BRNE _0x29
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _Set_Reg
	SBRS R4,5
	RJMP _0x2A
	LDI  R30,LOW(2)
	MOV  R7,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	RCALL _Set_Reg
	SBRC R5,0
	RJMP _0x2B
	CALL SUBOPT_0x2
	BRLO _0x2C
	CALL SUBOPT_0x3
	LDI  R30,LOW(3)
	MOV  R7,R30
	RJMP _0x2D
_0x2C:
	LDI  R30,LOW(226)
	ST   -Y,R30
	RCALL _Set_Reg
_0x2D:
_0x2B:
	RJMP _0x2E
_0x2A:
	LDI  R30,LOW(4)
	MOV  R7,R30
_0x2E:
	RJMP _0x2F
_0x29:
	CALL SUBOPT_0x2
	BRSH _0x30
	LDI  R30,LOW(226)
	ST   -Y,R30
	RCALL _Set_Reg
	RJMP _0x31
_0x30:
	CALL SUBOPT_0x3
	LDI  R30,LOW(1)
	MOV  R7,R30
_0x31:
_0x2F:
	LDI  R30,LOW(126)
	MOV  R5,R30
	LDI  R30,LOW(39)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(225)
	ST   -Y,R30
	RCALL _Set_Reg
	RJMP _0x65
_Send_Data:
	ST   -Y,R17
	ST   -Y,R16
;	num -> Y+4
;	*data -> Y+2
;	counter -> R16,R17
	__GETWRN 16,17,0
	LDD  R30,Y+4
	STS  _payload,R30
	__GETWRN 16,17,0
_0x33:
	LDD  R30,Y+4
	CALL SUBOPT_0x4
	BRGE _0x34
	MOVW R30,R16
	__ADDW1MN _payload,1
	MOVW R0,R30
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x33
_0x34:
	SBRS R2,0
	RJMP _0x35
	CLT
	BLD  R2,0
	__GETB2MN _Temp_Addrs,4
	__POINTW1FN _Base_Addrs,4
	LPM  R30,Z
	CP   R30,R26
	BRNE _0x37
	__GETB2MN _Temp_Addrs,3
	__POINTW1FN _Base_Addrs,3
	LPM  R30,Z
	CP   R30,R26
	BRNE _0x37
	__GETB2MN _Temp_Addrs,2
	__POINTW1FN _Base_Addrs,2
	LPM  R30,Z
	CP   R30,R26
	BRNE _0x37
	__GETB2MN _Temp_Addrs,1
	__POINTW1FN _Base_Addrs,1
	LPM  R30,Z
	CP   R30,R26
	BRNE _0x37
	LDI  R30,LOW(_Base_Addrs*2)
	LDI  R31,HIGH(_Base_Addrs*2)
	LPM  R30,Z
	LDS  R26,_Temp_Addrs
	CP   R30,R26
	BREQ _0x38
_0x37:
	RJMP _0x36
_0x38:
	LDI  R30,LOW(225)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(160)
	ST   -Y,R30
	RCALL _Set_Reg
	CALL SUBOPT_0x5
	SBI  0x18,3
	__DELAY_USB 98
	CBI  0x18,3
	CALL SUBOPT_0x5
	RJMP _0x3D
_0x36:
	LDI  R30,LOW(5)
	MOV  R7,R30
_0x3D:
_0x35:
	TST  R7
	BREQ _0x3E
	SET
	BLD  R2,0
	CLR  R7
_0x3E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
_nRF_Config:
;	mode -> Y+0
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(176)
	OUT  0x17,R30
	SBI  0x18,4
	CBI  0x18,3
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
	LDI  R30,LOW(0)
	OUT  0x35,R30
	OUT  0x34,R30
	LDI  R30,LOW(32)
	OUT  0x3A,R30
	LDI  R30,LOW(80)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
	sei
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x6
	LDD  R6,Y+0
	LDI  R30,LOW(1)
	MOV  R5,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0x7
	LDI  R30,LOW(34)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(3)
	MOV  R5,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(47)
	MOV  R5,R30
	LDI  R30,LOW(36)
	CALL SUBOPT_0x7
	LDI  R30,LOW(37)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(6)
	MOV  R5,R30
	LDI  R30,LOW(38)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(48)
	CALL SUBOPT_0x7
	LDI  R30,LOW(60)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(7)
	MOV  R5,R30
	LDI  R30,LOW(61)
	ST   -Y,R30
	RCALL _Set_Reg
	LD   R30,Y
	CPI  R30,0
	BRNE _0x43
	LDI  R30,LOW(78)
	MOV  R5,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x6
	SET
	BLD  R2,0
	RJMP _0x44
_0x43:
	LDI  R30,LOW(63)
	MOV  R5,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _Set_Reg
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x6
	SBI  0x18,3
_0x44:
	JMP  _0x2080001
;
;void send_temp_comand(void);
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0038 {
_usart_rx_isr:
	CALL SUBOPT_0x1
; 0000 0039 char status,data;
; 0000 003A status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 003B data=UDR;
	IN   R16,12
; 0000 003C if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x47
; 0000 003D    {
; 0000 003E    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 003F    //putchar(data);
; 0000 0040    if (data=='*') rx_wr_index=0;
	CPI  R16,42
	BRNE _0x48
	CLR  R9
; 0000 0041    if (data=='/'){
_0x48:
	CPI  R16,47
	BRNE _0x49
; 0000 0042      if ((rx_buffer[0]=='r') & (rx_buffer[1]=='t') & (rx_buffer[2]=='a')) {
	LDS  R26,_rx_buffer
	LDI  R30,LOW(114)
	CALL __EQB12
	MOV  R0,R30
	__GETB2MN _rx_buffer,1
	LDI  R30,LOW(116)
	CALL __EQB12
	AND  R0,R30
	__GETB2MN _rx_buffer,2
	LDI  R30,LOW(97)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x4A
; 0000 0043      puts(rx_buffer);
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 0044      PORTA.0=~PORTA.0;
	SBIS 0x1B,0
	RJMP _0x4B
	CBI  0x1B,0
	RJMP _0x4C
_0x4B:
	SBI  0x1B,0
_0x4C:
; 0000 0045      send_temp_comand();
	RCALL _send_temp_comand
; 0000 0046 
; 0000 0047 
; 0000 0048 
; 0000 0049 
; 0000 004A        }
; 0000 004B        }
_0x4A:
; 0000 004C #if RX_BUFFER_SIZE == 256
; 0000 004D    // special case for receiver buffer size=256
; 0000 004E    if (++rx_counter == 0)
; 0000 004F       {
; 0000 0050 #else
; 0000 0051    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
_0x49:
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x4D
	CLR  R9
; 0000 0052    if (++rx_counter == RX_BUFFER_SIZE)
_0x4D:
	INC  R11
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x4E
; 0000 0053       {
; 0000 0054       rx_counter=0;
	CLR  R11
; 0000 0055 #endif
; 0000 0056       rx_buffer_overflow=1;
	SET
	BLD  R2,1
; 0000 0057       }
; 0000 0058    }
_0x4E:
; 0000 0059 }
_0x47:
	LD   R16,Y+
	LD   R17,Y+
_0x65:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0060 {
; 0000 0061 char data;
; 0000 0062 while (rx_counter==0);
;	data -> R17
; 0000 0063 data=rx_buffer[rx_rd_index++];
; 0000 0064 #if RX_BUFFER_SIZE != 256
; 0000 0065 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0066 #endif
; 0000 0067 #asm("cli")
; 0000 0068 --rx_counter;
; 0000 0069 #asm("sei")
; 0000 006A return data;
; 0000 006B }
;#pragma used-
;#endif
;
;#include <stdio.h>
;
;unsigned int j;
;void sd(void);
;
;void main(void)
; 0000 0075 {
_main:
; 0000 0076 
; 0000 0077 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0078 DDRA=0x07;
	LDI  R30,LOW(7)
	OUT  0x1A,R30
; 0000 0079 
; 0000 007A 
; 0000 007B PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 007C DDRB=0x00;
	OUT  0x17,R30
; 0000 007D 
; 0000 007E PORTC=0x00;
	OUT  0x15,R30
; 0000 007F DDRC=0x00;
	OUT  0x14,R30
; 0000 0080 
; 0000 0081 
; 0000 0082 PORTD=0x00;
	OUT  0x12,R30
; 0000 0083 DDRD=0x00;
	OUT  0x11,R30
; 0000 0084 
; 0000 0085 
; 0000 0086 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0087 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0088 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0089 
; 0000 008A 
; 0000 008B TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 008C TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 008D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 008E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0090 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0091 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0092 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0093 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0094 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0095 
; 0000 0096 
; 0000 0097 ASSR=0x00;
	OUT  0x22,R30
; 0000 0098 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0099 TCNT2=0x00;
	OUT  0x24,R30
; 0000 009A OCR2=0x00;
	OUT  0x23,R30
; 0000 009B 
; 0000 009C 
; 0000 009D MCUCR=0x00;
	OUT  0x35,R30
; 0000 009E MCUCSR=0x00;
	OUT  0x34,R30
; 0000 009F 
; 0000 00A0 
; 0000 00A1 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00A2 
; 0000 00A3 // USART initialization
; 0000 00A4 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00A5 // USART Receiver: On
; 0000 00A6 // USART Transmitter: On
; 0000 00A7 // USART Mode: Asynchronous
; 0000 00A8 // USART Baud Rate: 19200
; 0000 00A9 UCSRA=0x00;
	OUT  0xB,R30
; 0000 00AA UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00AB UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 00AC UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00AD UBRRL=0x2F;
	LDI  R30,LOW(47)
	OUT  0x9,R30
; 0000 00AE 
; 0000 00AF 
; 0000 00B0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B2 
; 0000 00B3 
; 0000 00B4 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00B5 
; 0000 00B6 
; 0000 00B7 SPCR=0x00;
	OUT  0xD,R30
; 0000 00B8 
; 0000 00B9 
; 0000 00BA TWCR=0x00;
	OUT  0x36,R30
; 0000 00BB 
; 0000 00BC 
; 0000 00BD #asm("sei")
	sei
; 0000 00BE 
; 0000 00BF //nRF_Config(1);
; 0000 00C0 
; 0000 00C1 j=0;
	CLR  R12
	CLR  R13
; 0000 00C2  nRF_Config(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _nRF_Config
; 0000 00C3  DDRA.0=1;
	SBI  0x1A,0
; 0000 00C4  DDRA.2=1;
	SBI  0x1A,2
; 0000 00C5  PORTA.0=1;
	SBI  0x1B,0
; 0000 00C6 while (1)
_0x59:
; 0000 00C7       {
; 0000 00C8 
; 0000 00C9       if(State == 1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x5C
; 0000 00CA         {
; 0000 00CB        // for (j=0;j<payload[0];j++)
; 0000 00CC         //data1[j]=payload[j+1];
; 0000 00CD        // putchar(payload[1]);
; 0000 00CE          State = 0;
	CLR  R7
; 0000 00CF           sd();
	RCALL _sd
; 0000 00D0 
; 0000 00D1 
; 0000 00D2 
; 0000 00D3      // puts(data1);
; 0000 00D4      // PORTA.0=~PORTA.0;
; 0000 00D5       PORTA.1=~PORTA.1;
	SBIS 0x1B,1
	RJMP _0x5D
	CBI  0x1B,1
	RJMP _0x5E
_0x5D:
	SBI  0x1B,1
_0x5E:
; 0000 00D6      // PORTA.2=~PORTA.2;
; 0000 00D7       //delay_ms(1000);
; 0000 00D8 
; 0000 00D9 
; 0000 00DA 
; 0000 00DB         }
; 0000 00DC         }
_0x5C:
	RJMP _0x59
; 0000 00DD 
; 0000 00DE }
_0x5F:
	RJMP _0x5F
;
;void sd(void){
; 0000 00E0 void sd(void){
_sd:
; 0000 00E1 unsigned int i;
; 0000 00E2 for(i=0;i<payload[0];i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x61:
	LDS  R30,_payload
	CALL SUBOPT_0x4
	BRSH _0x62
; 0000 00E3   putchar(payload[i+1]);
	MOVW R30,R16
	__ADDW1MN _payload,1
	LD   R30,Z
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x61
_0x62:
; 0000 00E4 PORTA.2=~PORTA.2;
	SBIS 0x1B,2
	RJMP _0x63
	CBI  0x1B,2
	RJMP _0x64
_0x63:
	SBI  0x1B,2
_0x64:
; 0000 00E5   j=0;
	CLR  R12
	CLR  R13
; 0000 00E6   }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void send_temp_comand(void){
; 0000 00E8 void send_temp_comand(void){
_send_temp_comand:
; 0000 00E9  nRF_Config(0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 00EA  delay_ms(1000);
; 0000 00EB Send_Data(3,&rx_buffer[0]);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Send_Data
; 0000 00EC delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x6
; 0000 00ED nRF_Config(1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x8
; 0000 00EE delay_ms(1000);
; 0000 00EF }
	RET
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	RJMP _0x2080001
_puts:
	ST   -Y,R17
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
_0x2080002:
	ADIW R28,3
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_Temp_Addrs:
	.BYTE 0x5
_payload:
	.BYTE 0x21
_rx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(255)
	ST   -Y,R30
	JMP  _spi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(96)
	ST   -Y,R30
	CALL _Set_Reg
	LDI  R30,LOW(32)
	CP   R30,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	STS  _payload,R5
	LDI  R30,LOW(97)
	ST   -Y,R30
	JMP  _Set_Reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	CALL _Set_Reg
	LDI  R30,LOW(1)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	CALL _nRF_Config
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x6


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
