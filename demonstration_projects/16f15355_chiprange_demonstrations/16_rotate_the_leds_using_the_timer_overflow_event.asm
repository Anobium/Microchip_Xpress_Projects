;Program compiled by Great Cow BASIC (0.98.<<>> 2019-05-14 (Windows 32 bit))
;Need help? See the GCBASIC forums at http://sourceforge.net/projects/gcbasic/forums,
;check the documentation or email w_cholmondeley at users dot sourceforge dot net.

;********************************************************************************

;Set up the assembler options (Chip type, clock source, other bits and pieces)
 LIST p=16F15355, r=DEC
#include <P16F15355.inc>
 errorlevel -302
 __CONFIG _CONFIG1, _CLKOUTEN_OFF & _RSTOSC_HFINT32 & _FEXTOSC_OFF
 __CONFIG _CONFIG2, _MCLRE_ON
 __CONFIG _CONFIG3, _WDTE_OFF
 __CONFIG _CONFIG4, _LVP_OFF
 __CONFIG _CONFIG5, _CP_OFF

;********************************************************************************

;Set aside memory locations for variables
CURRENTSTATE	EQU	32
DELAYTEMP	EQU	112
DELAYTEMP2	EQU	113
SAVEPCLATH	EQU	33
SYSBITVAR0	EQU	34
SYSBSR	EQU	35
SYSREPEATTEMP1	EQU	36
SYSSTATUS	EQU	127
SYSTEMP1	EQU	37
SYSW	EQU	126
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115
TIMEOUT	EQU	38
TMRNUMBER	EQU	39
TMRPOST	EQU	40
TMRPRES	EQU	41
TMRSOURCE	EQU	42
TMRVALUE	EQU	43
TMRVALUE_H	EQU	44

;********************************************************************************

;Vectors
	ORG	0
	pagesel	BASPROGRAMSTART
	goto	BASPROGRAMSTART
	ORG	4
Interrupt

;********************************************************************************

;Save Context
	movwf	SysW
	swapf	STATUS,W
	movwf	SysSTATUS
	movf	BSR,W
	banksel	STATUS
	movwf	SysBSR
;Store system variables
	movf	PCLATH,W
	movwf	SavePCLATH
	clrf	PCLATH
;On Interrupt handlers
	banksel	PIE0
	btfss	PIE0,TMR0IE
	goto	NotTMR0IF
	btfss	PIR0,TMR0IF
	goto	NotTMR0IF
	banksel	STATUS
	call	BLINK
	banksel	PIR0
	bcf	PIR0,TMR0IF
	goto	INTERRUPTDONE
NotTMR0IF
;User Interrupt routine
INTERRUPTDONE
;Restore Context
;Restore system variables
	banksel	SAVEPCLATH
	movf	SavePCLATH,W
	movwf	PCLATH
	movf	SysBSR,W
	movwf	BSR
	swapf	SysSTATUS,W
	movwf	STATUS
	swapf	SysW,F
	swapf	SysW,W
	retfie

;********************************************************************************

;Start of program memory page 0
	ORG	34
BASPROGRAMSTART
;Call initialisation routines
	call	INITSYS
	call	INITPPS
;Enable interrupts
	bsf	INTCON,GIE
	bsf	INTCON,PEIE

;Start of the main program
	bcf	TRISC,0
	bcf	TRISC,1
	bcf	TRISC,2
	bcf	TRISC,3
	movlw	10
	movwf	SysRepeatTemp1
SysRepeatLoop1
	comf	PORTC,F
	movlw	100
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	decfsz	SysRepeatTemp1,F
	goto	SysRepeatLoop1
SysRepeatLoopEnd1
	clrf	PORTC
	bsf	LATC,3
	movlw	1
	movwf	TMRSOURCE
	movlw	104
	movwf	TMRPRES
	movlw	1
	movwf	TMRPOST
	call	INITTIMER0154
	banksel	PIE0
	bsf	PIE0,TMR0IE
	banksel	TMRNUMBER
	clrf	TMRNUMBER
	movlw	220
	movwf	TMRVALUE
	movlw	11
	movwf	TMRVALUE_H
	call	SETTIMER
	clrf	TMRNUMBER
	call	STARTTIMER
SysDoLoop_S1
	decf	TIMEOUT,W
	btfss	STATUS, Z
	goto	ENDIF1
	movlw	15
	andwf	PORTC,W
	movwf	CURRENTSTATE
	bcf	STATUS,C
	rrf	CURRENTSTATE,F
	btfsc	STATUS,C
	bsf	CURRENTSTATE,3
	movlw	240
	andwf	PORTC,W
	movwf	SysTemp1
	iorwf	CURRENTSTATE,W
	movwf	PORTC
	clrf	TIMEOUT
	clrf	TMRNUMBER
	movlw	220
	movwf	TMRVALUE
	movlw	11
	movwf	TMRVALUE_H
	call	SETTIMER
ENDIF1
	goto	SysDoLoop_S1
SysDoLoop_E1
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

;********************************************************************************

BLINK
	movlw	1
	movwf	TIMEOUT
	banksel	PIR0
	bcf	PIR0,TMR0IF
	banksel	STATUS
	return

;********************************************************************************

Delay_MS
	incf	SysWaitTempMS_H, F
DMS_START
	movlw	14
	movwf	DELAYTEMP2
DMS_OUTER
	movlw	189
	movwf	DELAYTEMP
DMS_INNER
	decfsz	DELAYTEMP, F
	goto	DMS_INNER
	decfsz	DELAYTEMP2, F
	goto	DMS_OUTER
	decfsz	SysWaitTempMS, F
	goto	DMS_START
	decfsz	SysWaitTempMS_H, F
	goto	DMS_START
	return

;********************************************************************************

INITPPS
	bcf	SYSBITVAR0,1
	btfsc	INTCON,GIE
	bsf	SYSBITVAR0,1
	bcf	INTCON,GIE
	movlw	85
	banksel	PPSLOCK
	movwf	PPSLOCK
	movlw	170
	movwf	PPSLOCK
	bcf	PPSLOCK,PPSLOCKED
	movlw	21
	movwf	RX1DTPPS
	movlw	15
	banksel	RC4PPS
	movwf	RC4PPS
	movlw	85
	banksel	PPSLOCK
	movwf	PPSLOCK
	movlw	170
	movwf	PPSLOCK
	bsf	PPSLOCK,PPSLOCKED
	banksel	SYSBITVAR0
	btfss	SYSBITVAR0,1
	bcf	INTCON,GIE
	btfsc	SYSBITVAR0,1
	bsf	INTCON,GIE
	return

;********************************************************************************

INITSYS
;osccon type is 100
	movlw	96
	banksel	OSCCON1
	movwf	OSCCON1
	clrf	OSCCON3
	clrf	OSCEN
	clrf	OSCTUNE
;the mcu is a chip family 15
;osccon type is 102
	movlw	6
	movwf	OSCFRQ
	banksel	ADCON1
	bcf	ADCON1,ADFM
	bcf	ADCON0,ADON
	banksel	ANSELA
	clrf	ANSELA
	clrf	ANSELB
	clrf	ANSELC
	banksel	CM2CON0
	bcf	CM2CON0,C2EN
	bcf	CM1CON0,C1EN
	banksel	PORTA
	clrf	PORTA
	clrf	PORTB
	clrf	PORTC
	clrf	PORTE
	return

;********************************************************************************

;Overloaded signature: BYTE:BYTE:BYTE:
INITTIMER0154
	movlw	240
	banksel	T0CON1
	andwf	T0CON1,W
	banksel	SYSTEMP1
	movwf	SysTemp1
	iorwf	TMRPRES,F
	decf	TMRSOURCE,W
	btfsc	STATUS, Z
	goto	ELSE12_1
	bsf	TMRPOST,5
	goto	ENDIF12
ELSE12_1
	bcf	TMRPOST,5
ENDIF12
	movf	TMRPRES,W
	banksel	T0CON1
	movwf	T0CON1
	movlw	224
	andwf	T0CON0,W
	banksel	SYSTEMP1
	movwf	SysTemp1
	iorwf	TMRPOST,F
	bsf	TMRPOST,4
	movf	TMRPOST,W
	banksel	T0CON0
	movwf	T0CON0
	banksel	STATUS
	return

;********************************************************************************

SETTIMER
	movf	TMRNUMBER,F
	btfss	STATUS, Z
	goto	ENDIF9
	movf	TMRVALUE_H,W
	banksel	TMR0H
	movwf	TMR0H
	banksel	TMRVALUE
	movf	TMRVALUE,W
	banksel	TMR0L
	movwf	TMR0L
	banksel	STATUS
	return
ENDIF9
	decf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF10
	movf	TMRVALUE_H,W
	banksel	TMR1H
	movwf	TMR1H
	banksel	TMRVALUE
	movf	TMRVALUE,W
	banksel	TMR1L
	movwf	TMR1L
ENDIF10
	movlw	2
	banksel	TMRNUMBER
	subwf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF11
	movf	TMRVALUE,W
	banksel	TMR2
	movwf	TMR2
ENDIF11
	banksel	STATUS
	return

;********************************************************************************

STARTTIMER
	movf	TMRNUMBER,F
	btfss	STATUS, Z
	goto	ENDIF6
	banksel	T0CON0
	bsf	T0CON0,T0EN
ENDIF6
	banksel	TMRNUMBER
	decf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF7
	banksel	T1CON
	bsf	T1CON,TMR1ON
ENDIF7
	movlw	2
	banksel	TMRNUMBER
	subwf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF8
	banksel	T2CON
	bsf	T2CON,TMR2ON
ENDIF8
	banksel	STATUS
	return

;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
