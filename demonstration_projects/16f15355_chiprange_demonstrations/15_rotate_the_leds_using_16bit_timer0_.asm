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
SYSBITVAR0	EQU	33
SYSTEMP1	EQU	34
TMRNUMBER	EQU	35
TMRPOST	EQU	36
TMRPRES	EQU	37
TMRSOURCE	EQU	38
TMRVALUE	EQU	39
TMRVALUE_H	EQU	40

;********************************************************************************

;Vectors
	ORG	0
	pagesel	BASPROGRAMSTART
	goto	BASPROGRAMSTART
	ORG	4
	retfie

;********************************************************************************

;Start of program memory page 0
	ORG	5
BASPROGRAMSTART
;Call initialisation routines
	call	INITSYS
	call	INITPPS

;Start of the main program
	bcf	TRISC,0
	bcf	TRISC,1
	bcf	TRISC,2
	bcf	TRISC,3
	clrf	PORTC
	bsf	LATC,3
	movlw	1
	movwf	TMRSOURCE
	movlw	104
	movwf	TMRPRES
	movlw	1
	movwf	TMRPOST
	call	INITTIMER0153
	clrf	TMRNUMBER
	call	STARTTIMER
	clrf	TMRNUMBER
	movlw	220
	movwf	TMRVALUE
	movlw	11
	movwf	TMRVALUE_H
	call	SETTIMER
SysDoLoop_S1
SysWaitLoop1
	banksel	PIR0
	btfss	PIR0,TMR0IF
	goto	SysWaitLoop1
	bcf	PIR0,TMR0IF
	movlw	15
	banksel	PORTC
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
	clrf	TMRNUMBER
	movlw	220
	movwf	TMRVALUE
	movlw	11
	movwf	TMRVALUE_H
	call	SETTIMER
	goto	SysDoLoop_S1
SysDoLoop_E1
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

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
INITTIMER0153
	movlw	240
	banksel	T0CON1
	andwf	T0CON1,W
	banksel	SYSTEMP1
	movwf	SysTemp1
	iorwf	TMRPRES,F
	decf	TMRSOURCE,W
	btfsc	STATUS, Z
	goto	ELSE11_1
	bsf	TMRPOST,5
	goto	ENDIF11
ELSE11_1
	bcf	TMRPOST,5
ENDIF11
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
	goto	ENDIF8
	movf	TMRVALUE_H,W
	banksel	TMR0H
	movwf	TMR0H
	banksel	TMRVALUE
	movf	TMRVALUE,W
	banksel	TMR0L
	movwf	TMR0L
	banksel	STATUS
	return
ENDIF8
	decf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF9
	movf	TMRVALUE_H,W
	banksel	TMR1H
	movwf	TMR1H
	banksel	TMRVALUE
	movf	TMRVALUE,W
	banksel	TMR1L
	movwf	TMR1L
ENDIF9
	movlw	2
	banksel	TMRNUMBER
	subwf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF10
	movf	TMRVALUE,W
	banksel	TMR2
	movwf	TMR2
ENDIF10
	banksel	STATUS
	return

;********************************************************************************

STARTTIMER
	movf	TMRNUMBER,F
	btfss	STATUS, Z
	goto	ENDIF5
	banksel	T0CON0
	bsf	T0CON0,T0EN
ENDIF5
	banksel	TMRNUMBER
	decf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF6
	banksel	T1CON
	bsf	T1CON,TMR1ON
ENDIF6
	movlw	2
	banksel	TMRNUMBER
	subwf	TMRNUMBER,W
	btfss	STATUS, Z
	goto	ENDIF7
	banksel	T2CON
	bsf	T2CON,TMR2ON
ENDIF7
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
