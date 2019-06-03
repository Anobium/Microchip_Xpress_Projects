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
DELAYTEMP	EQU	112
DELAYTEMP2	EQU	113
MYWORD	EQU	31
MYWORD_E	EQU	34
MYWORD_H	EQU	32
MYWORD_U	EQU	33
SYSTEMP1	EQU	32
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115

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

;Start of the main program
	movlw	52
	movwf	MYWORD
	movlw	18
	movwf	MYWORD_H
	clrf	MYWORD_U
	clrf	MYWORD_E
;debughere
	nop
	bcf	TRISC,0
SysDoLoop_S1
	movlw	232
	movwf	SysWaitTempMS
	movlw	3
	movwf	SysWaitTempMS_H
	call	Delay_MS
;debughere
	nop
	clrf	SysTemp1
	btfsc	PORTC,0
	incf	SysTemp1,F
	comf	SysTemp1,F
	bcf	LATC,0
	btfsc	SysTemp1,0
	bsf	LATC,0
	goto	SysDoLoop_S1
SysDoLoop_E1
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

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

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
