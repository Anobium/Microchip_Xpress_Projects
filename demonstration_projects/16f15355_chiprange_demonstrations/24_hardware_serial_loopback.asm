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
COMPORT	EQU	32
DELAYTEMP	EQU	112
DELAYTEMP2	EQU	113
HSERPRINTCRLFCOUNT	EQU	33
HSERRECEIVE	EQU	34
INCHAR	EQU	35
PRINTLEN	EQU	36
SERDATA	EQU	37
STRINGPOINTER	EQU	38
SYSBITVAR0	EQU	39
SYSPRINTDATAHANDLER	EQU	40
SYSPRINTDATAHANDLER_H	EQU	41
SYSPRINTTEMP	EQU	42
SYSREPEATTEMP1	EQU	43
SYSSTRINGA	EQU	119
SYSSTRINGA_H	EQU	120
SYSTEMP1	EQU	44
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115

;********************************************************************************

;Alias variables
AFSR0	EQU	4
AFSR0_H	EQU	5

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
	call	INITUSART

;Start of the main program
	movlw	244
	movwf	SysWaitTempMS
	movlw	1
	movwf	SysWaitTempMS_H
	call	Delay_MS
	movlw	low StringTable1
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable1) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT257
	movlw	1
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
SysDoLoop_S1
	call	HSERRECEIVE252
	movf	SERDATA,W
	movwf	INCHAR
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
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

;Overloaded signature: STRING:byte:
HSERPRINT257
	movf	SysPRINTDATAHandler,W
	movwf	AFSR0
	movf	SysPRINTDATAHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	PRINTLEN
	movf	PRINTLEN,F
	btfsc	STATUS, Z
	goto	ENDIF8
	clrf	SYSPRINTTEMP
	movlw	1
	subwf	PRINTLEN,W
	btfss	STATUS, C
	goto	SysForLoopEnd1
SysForLoop1
	incf	SYSPRINTTEMP,F
	movf	SYSPRINTTEMP,W
	addwf	SysPRINTDATAHandler,W
	movwf	AFSR0
	movlw	0
	addwfc	SysPRINTDATAHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	SERDATA
	call	HSERSEND
	movf	PRINTLEN,W
	subwf	SYSPRINTTEMP,W
	btfss	STATUS, C
	goto	SysForLoop1
SysForLoopEnd1
ENDIF8
	return

;********************************************************************************

HSERPRINTCRLF
	movf	HSERPRINTCRLFCOUNT,W
	movwf	SysRepeatTemp1
	btfsc	STATUS,Z
	goto	SysRepeatLoopEnd1
SysRepeatLoop1
	movlw	13
	movwf	SERDATA
	call	HSERSEND
	movlw	10
	movwf	SERDATA
	call	HSERSEND
	decfsz	SysRepeatTemp1,F
	goto	SysRepeatLoop1
SysRepeatLoopEnd1
	return

;********************************************************************************

;Overloaded signature: BYTE:
HSERRECEIVE252
	decf	COMPORT,W
	btfss	STATUS, Z
	goto	ENDIF5
	movlw	255
	movwf	SERDATA
SysWaitLoop4
	banksel	PIR3
	btfss	PIR3,RC1IF
	goto	SysWaitLoop4
	btfss	PIR3,RC1IF
	goto	ENDIF6
	banksel	RCREG1
	movf	RCREG1,W
	banksel	SERDATA
	movwf	SERDATA
ENDIF6
	banksel	RC1STA
	btfss	RC1STA,OERR
	goto	ENDIF7
	bcf	RC1STA,CREN
	bsf	RC1STA,CREN
ENDIF7
ENDIF5
	banksel	STATUS
	return

;********************************************************************************

HSERSEND
	decf	COMPORT,W
	btfss	STATUS, Z
	goto	ENDIF4
SysWaitLoop1
	banksel	PIR3
	btfss	PIR3,TX1IF
	goto	SysWaitLoop1
SysWaitLoop2
	btfss	PIR3,TX1IF
	goto	SysWaitLoop2
;txreg equals serdata below will assign serdata to txreg | txreg1 | txreg via the #samevar
	banksel	SERDATA
	movf	SERDATA,W
	banksel	TXREG
	movwf	TXREG
SysWaitLoop3
	btfss	TX1STA,TRMT
	goto	SysWaitLoop3
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	banksel	STATUS
	call	Delay_MS
	return
ENDIF4
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

INITUSART
	movlw	1
	movwf	COMPORT
	movlw	159
	banksel	SPBRG
	movwf	SPBRG
	movlw	1
	movwf	SP1BRGH
	bsf	BAUD1CON,BRG16
	bsf	TX1STA,BRGH
	bcf	TX1STA,SYNC_TX1STA
	bsf	TX1STA,TXEN
	bsf	RC1STA,SPEN
	bsf	RC1STA,CREN
	banksel	STATUS
	return

;********************************************************************************

SysStringTables
	movf	SysStringA_H,W
	movwf	PCLATH
	movf	SysStringA,W
	incf	SysStringA,F
	btfsc	STATUS,Z
	incf	SysStringA_H,F
	movwf	PCL

StringTable1
	retlw	22
	retlw	76	;L
	retlw	111	;o
	retlw	111	;o
	retlw	112	;p
	retlw	32	; 
	retlw	66	;B
	retlw	97	;a
	retlw	99	;c
	retlw	107	;k
	retlw	32	; 
	retlw	84	;T
	retlw	101	;e
	retlw	115	;s
	retlw	116	;t
	retlw	32	; 
	retlw	80	;P
	retlw	114	;r
	retlw	111	;o
	retlw	103	;g
	retlw	114	;r
	retlw	97	;a
	retlw	109	;m


;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
