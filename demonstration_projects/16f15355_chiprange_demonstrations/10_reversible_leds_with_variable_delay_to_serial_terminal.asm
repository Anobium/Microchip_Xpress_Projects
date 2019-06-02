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
ADREADPORT	EQU	32
BYTENUM	EQU	33
BYTETOBIN	EQU	9150
CHECK_SWITCH	EQU	34
COMPORT	EQU	35
DELAYTEMP	EQU	112
DELAYTEMP2	EQU	113
DIRECTION	EQU	36
HSERPRINTCRLFCOUNT	EQU	37
LEDS	EQU	38
MYDELAY	EQU	39
OUTVALUETEMP	EQU	40
PRINTLEN	EQU	41
READAD10	EQU	42
READAD10_H	EQU	43
RIGHT	EQU	9159
SERDATA	EQU	44
SERPRINTVAL	EQU	45
STRINGPOINTER	EQU	46
SYSARRAYTEMP1	EQU	47
SYSARRAYTEMP2	EQU	48
SYSBITVAR0	EQU	49
SYSBYTETEMPA	EQU	117
SYSBYTETEMPB	EQU	121
SYSBYTETEMPX	EQU	112
SYSCALCTEMPA	EQU	117
SYSCALCTEMPX	EQU	112
SYSCHARCOUNT	EQU	50
SYSCHARSTART	EQU	51
SYSDIVLOOP	EQU	116
SYSDIVMULTA	EQU	119
SYSDIVMULTA_H	EQU	120
SYSDIVMULTB	EQU	123
SYSDIVMULTB_H	EQU	124
SYSDIVMULTX	EQU	114
SYSDIVMULTX_H	EQU	115
SYSPRINTDATAHANDLER	EQU	52
SYSPRINTDATAHANDLER_H	EQU	53
SYSPRINTTEMP	EQU	54
SYSREPEATTEMP1	EQU	55
SYSREPEATTEMP2	EQU	56
SYSREPEATTEMP3	EQU	57
SYSSTRINGA	EQU	119
SYSSTRINGA_H	EQU	120
SYSSTRINGLENGTH	EQU	118
SYSSTRINGTEMP	EQU	58
SYSSYSINSTRINGHANDLER	EQU	59
SYSSYSINSTRINGHANDLER_H	EQU	60
SYSTEMP1	EQU	61
SYSTEMP1_H	EQU	62
SYSTEMP2	EQU	63
SYSTEMP3	EQU	64
SYSWAITTEMP10US	EQU	117
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115
SYSWAITTEMPS	EQU	116
SYSWORDTEMPA	EQU	117
SYSWORDTEMPA_H	EQU	118
SYSWORDTEMPB	EQU	121
SYSWORDTEMPB_H	EQU	122
SYSWORDTEMPX	EQU	112
SYSWORDTEMPX_H	EQU	113

;********************************************************************************

;Alias variables
AFSR0	EQU	4
AFSR0_H	EQU	5
SYSREADAD10WORD	EQU	42
SYSREADAD10WORD_H	EQU	43
SYSRIGHT_0	EQU	1575

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
	movlw	255
	movwf	DIRECTION
	clrf	TRISC
	movlw	8
	movwf	LEDS
	bsf	TRISA,0
	bsf	TRISA,1
	movlw	2
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	movlw	low StringTable1
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable1) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT258
	movlw	1
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	movlw	low StringTable2
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable2) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT258
	movlw	1
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	movlw	3
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	movlw	1
	movwf	SysWaitTempS
	call	Delay_S
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
SysDoLoop_S1
	clrf	ADREADPORT
	call	FN_READAD106
	movf	SYSREADAD10WORD,W
	movwf	SysWORDTempA
	movf	SYSREADAD10WORD_H,W
	movwf	SysWORDTempA_H
	movlw	4
	movwf	SysWORDTempB
	clrf	SysWORDTempB_H
	call	SysDivSub16
	movf	SysWORDTempA,W
	movwf	MYDELAY
	movlw	low StringTable3
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable3) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT258
	movf	MYDELAY,W
	movwf	SERPRINTVAL
	movlw	1
	movwf	COMPORT
	call	HSERPRINT259
	movlw	9
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movf	MYDELAY,W
	movwf	SysBYTETempA
	movlw	16
	movwf	SysBYTETempB
	call	SysDivSub
	movf	SysBYTETempA,W
	movwf	MYDELAY
SysDoLoop_S2
	movf	MYDELAY,F
	btfsc	STATUS, Z
	goto	SysDoLoop_E2
	decf	MYDELAY,F
	movlw	20
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	call	FN_CHECK_SWITCH
	incf	CHECK_SWITCH,W
	btfsc	STATUS, Z
	comf	DIRECTION,F
	goto	SysDoLoop_S2
SysDoLoop_E2
	movf	LEDS,W
	movwf	PORTC
	incf	DIRECTION,W
	btfss	STATUS, Z
	goto	ELSE2_1
	movlw	low StringTable4
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable4) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT258
	goto	ENDIF2
ELSE2_1
	movlw	low StringTable5
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable5) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT258
ENDIF2
	movf	LEDS,W
	movwf	BYTENUM
	call	FN_BYTETOBIN
	movlw	low BYTETOBIN
	movwf	SysSYSINSTRINGHandler
	movlw	high BYTETOBIN
	movwf	SysSYSINSTRINGHandler_H
	movlw	4
	movwf	SYSCHARCOUNT
	call	FN_RIGHT
	movlw	low RIGHT
	movwf	SysPRINTDATAHandler
	movlw	high RIGHT
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT258
	movlw	1
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	incf	DIRECTION,W
	btfss	STATUS, Z
	goto	ELSE3_1
	rrf	LEDS,W
	rrf	LEDS,F
	movlw	128
	subwf	LEDS,W
	btfss	STATUS, Z
	goto	ENDIF4
	movlw	8
	movwf	LEDS
ENDIF4
	goto	ENDIF3
ELSE3_1
	bcf	STATUS,C
	rlf	LEDS,F
	movlw	16
	subwf	LEDS,W
	btfss	STATUS, Z
	goto	ENDIF5
	movlw	1
	movwf	LEDS
ENDIF5
ENDIF3
	goto	SysDoLoop_S1
SysDoLoop_E1
	bsf	SYSBITVAR0,0
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

;********************************************************************************

FN_BYTETOBIN
	movlw	low BYTETOBIN
	movwf	FSR1L
	movlw	high BYTETOBIN
	movwf	FSR1H
	movlw	low StringTable30
	movwf	SysStringA
	movlw	(high StringTable30) & 127
	movwf	SysStringA_H
	call	SysReadString
	movlw	8
	movwf	SysRepeatTemp2
SysRepeatLoop2
	btfss	BYTENUM,7
	goto	ELSE24_1
	movlw	low BYTETOBIN
	movwf	FSR1L
	movlw	high BYTETOBIN
	movwf	FSR1H
	clrf	SysStringLength
	movlw	low BYTETOBIN
	movwf	FSR0L
	movlw	high BYTETOBIN
	movwf	FSR0H
	call	SysCopyStringPart
	movlw	low StringTable31
	movwf	SysStringA
	movlw	(high StringTable31) & 127
	movwf	SysStringA_H
	call	SysReadStringPart
	movlw	low BYTETOBIN
	movwf	FSR0L
	movlw	high BYTETOBIN
	movwf	FSR0H
	movf	SysStringLength,W
	movwf	INDF0
	goto	ENDIF24
ELSE24_1
	movlw	low BYTETOBIN
	movwf	FSR1L
	movlw	high BYTETOBIN
	movwf	FSR1H
	clrf	SysStringLength
	movlw	low BYTETOBIN
	movwf	FSR0L
	movlw	high BYTETOBIN
	movwf	FSR0H
	call	SysCopyStringPart
	movlw	low StringTable32
	movwf	SysStringA
	movlw	(high StringTable32) & 127
	movwf	SysStringA_H
	call	SysReadStringPart
	movlw	low BYTETOBIN
	movwf	FSR0L
	movlw	high BYTETOBIN
	movwf	FSR0H
	movf	SysStringLength,W
	movwf	INDF0
ENDIF24
	rlf	BYTENUM,F
	decfsz	SysRepeatTemp2,F
	goto	SysRepeatLoop2
SysRepeatLoopEnd2
	return

;********************************************************************************

FN_CHECK_SWITCH
	btfsc	PORTA,1
	goto	ELSE9_1
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	clrf	SysByteTempX
	btfss	SYSBITVAR0,0
	comf	SysByteTempX,F
	movf	SysByteTempX,W
	movwf	SysTemp1
	clrf	SysByteTempX
	btfss	PORTA,1
	comf	SysByteTempX,F
	movf	SysByteTempX,W
	movwf	SysTemp2
	movf	SysTemp1,W
	andwf	SysTemp2,W
	movwf	SysTemp3
	btfss	SysTemp3,0
	goto	ELSE10_1
	clrf	CHECK_SWITCH
	return
	goto	ENDIF10
ELSE10_1
	btfsc	PORTA,1
	goto	ELSE11_1
	bcf	SYSBITVAR0,0
	movlw	255
	movwf	CHECK_SWITCH
	return
	goto	ENDIF11
ELSE11_1
	bsf	SYSBITVAR0,0
	clrf	CHECK_SWITCH
	return
ENDIF11
ENDIF10
	goto	ENDIF9
ELSE9_1
	bsf	SYSBITVAR0,0
	clrf	CHECK_SWITCH
	return
ENDIF9
	return

;********************************************************************************

Delay_10US
D10US_START
	movlw	25
	movwf	DELAYTEMP
DelayUS0
	decfsz	DELAYTEMP,F
	goto	DelayUS0
	nop
	decfsz	SysWaitTemp10US, F
	goto	D10US_START
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

Delay_S
DS_START
	movlw	232
	movwf	SysWaitTempMS
	movlw	3
	movwf	SysWaitTempMS_H
	call	Delay_MS
	decfsz	SysWaitTempS, F
	goto	DS_START
	return

;********************************************************************************

;Overloaded signature: STRING:byte:
HSERPRINT258
	movf	SysPRINTDATAHandler,W
	movwf	AFSR0
	movf	SysPRINTDATAHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	PRINTLEN
	movf	PRINTLEN,F
	btfsc	STATUS, Z
	goto	ENDIF26
	clrf	SYSPRINTTEMP
	movlw	1
	subwf	PRINTLEN,W
	btfss	STATUS, C
	goto	SysForLoopEnd2
SysForLoop2
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
	goto	SysForLoop2
SysForLoopEnd2
ENDIF26
	return

;********************************************************************************

;Overloaded signature: BYTE:byte:
HSERPRINT259
	clrf	OUTVALUETEMP
	movlw	100
	subwf	SERPRINTVAL,W
	btfss	STATUS, C
	goto	ENDIF29
	movf	SERPRINTVAL,W
	movwf	SysBYTETempA
	movlw	100
	movwf	SysBYTETempB
	call	SysDivSub
	movf	SysBYTETempA,W
	movwf	OUTVALUETEMP
	movf	SYSCALCTEMPX,W
	movwf	SERPRINTVAL
	movlw	48
	addwf	OUTVALUETEMP,W
	movwf	SERDATA
	call	HSERSEND
ENDIF29
	movf	OUTVALUETEMP,W
	movwf	SysBYTETempB
	clrf	SysBYTETempA
	call	SysCompLessThan
	movf	SysByteTempX,W
	movwf	SysTemp2
	movf	SERPRINTVAL,W
	movwf	SysBYTETempA
	movlw	10
	movwf	SysBYTETempB
	call	SysCompLessThan
	comf	SysByteTempX,F
	movf	SysTemp2,W
	iorwf	SysByteTempX,W
	movwf	SysTemp3
	btfss	SysTemp3,0
	goto	ENDIF30
	movf	SERPRINTVAL,W
	movwf	SysBYTETempA
	movlw	10
	movwf	SysBYTETempB
	call	SysDivSub
	movf	SysBYTETempA,W
	movwf	OUTVALUETEMP
	movf	SYSCALCTEMPX,W
	movwf	SERPRINTVAL
	movlw	48
	addwf	OUTVALUETEMP,W
	movwf	SERDATA
	call	HSERSEND
ENDIF30
	movlw	48
	addwf	SERPRINTVAL,W
	movwf	SERDATA
	goto	HSERSEND

;********************************************************************************

HSERPRINTCRLF
	movf	HSERPRINTCRLFCOUNT,W
	movwf	SysRepeatTemp3
	btfsc	STATUS,Z
	goto	SysRepeatLoopEnd3
SysRepeatLoop3
	movlw	13
	movwf	SERDATA
	call	HSERSEND
	movlw	10
	movwf	SERDATA
	call	HSERSEND
	decfsz	SysRepeatTemp3,F
	goto	SysRepeatLoop3
SysRepeatLoopEnd3
	return

;********************************************************************************

HSERSEND
	decf	COMPORT,W
	btfss	STATUS, Z
	goto	ENDIF25
SysWaitLoop2
	banksel	PIR3
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
ENDIF25
	return

;********************************************************************************

INITPPS
	bcf	SYSBITVAR0,2
	btfsc	INTCON,GIE
	bsf	SYSBITVAR0,2
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
	btfss	SYSBITVAR0,2
	bcf	INTCON,GIE
	btfsc	SYSBITVAR0,2
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

;Overloaded signature: BYTE:
FN_READAD106
	banksel	ADCON1
	bsf	ADCON1,ADFM
SysSelect1Case1
	banksel	ADREADPORT
	movf	ADREADPORT,F
	btfss	STATUS, Z
	goto	SysSelect1Case2
	banksel	ANSELA
	bsf	ANSELA,0
	goto	SysSelectEnd1
SysSelect1Case2
	decf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case3
	banksel	ANSELA
	bsf	ANSELA,1
	goto	SysSelectEnd1
SysSelect1Case3
	movlw	2
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case4
	banksel	ANSELA
	bsf	ANSELA,2
	goto	SysSelectEnd1
SysSelect1Case4
	movlw	3
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case5
	banksel	ANSELA
	bsf	ANSELA,3
	goto	SysSelectEnd1
SysSelect1Case5
	movlw	4
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case6
	banksel	ANSELA
	bsf	ANSELA,4
	goto	SysSelectEnd1
SysSelect1Case6
	movlw	5
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case7
	banksel	ANSELA
	bsf	ANSELA,5
	goto	SysSelectEnd1
SysSelect1Case7
	movlw	6
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case8
	banksel	ANSELA
	bsf	ANSELA,6
	goto	SysSelectEnd1
SysSelect1Case8
	movlw	7
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case9
	banksel	ANSELA
	bsf	ANSELA,7
	goto	SysSelectEnd1
SysSelect1Case9
	movlw	8
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case10
	banksel	ANSELB
	bsf	ANSELB,0
	goto	SysSelectEnd1
SysSelect1Case10
	movlw	9
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case11
	banksel	ANSELB
	bsf	ANSELB,1
	goto	SysSelectEnd1
SysSelect1Case11
	movlw	10
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case12
	banksel	ANSELB
	bsf	ANSELB,2
	goto	SysSelectEnd1
SysSelect1Case12
	movlw	11
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case13
	banksel	ANSELB
	bsf	ANSELB,3
	goto	SysSelectEnd1
SysSelect1Case13
	movlw	12
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case14
	banksel	ANSELB
	bsf	ANSELB,4
	goto	SysSelectEnd1
SysSelect1Case14
	movlw	13
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case15
	banksel	ANSELB
	bsf	ANSELB,5
	goto	SysSelectEnd1
SysSelect1Case15
	movlw	14
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case16
	banksel	ANSELB
	bsf	ANSELB,6
	goto	SysSelectEnd1
SysSelect1Case16
	movlw	15
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case17
	banksel	ANSELB
	bsf	ANSELB,7
	goto	SysSelectEnd1
SysSelect1Case17
	movlw	16
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case18
	banksel	ANSELC
	bsf	ANSELC,0
	goto	SysSelectEnd1
SysSelect1Case18
	movlw	17
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case19
	banksel	ANSELC
	bsf	ANSELC,1
	goto	SysSelectEnd1
SysSelect1Case19
	movlw	18
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case20
	banksel	ANSELC
	bsf	ANSELC,2
	goto	SysSelectEnd1
SysSelect1Case20
	movlw	19
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case21
	banksel	ANSELC
	bsf	ANSELC,3
	goto	SysSelectEnd1
SysSelect1Case21
	movlw	20
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case22
	banksel	ANSELC
	bsf	ANSELC,4
	goto	SysSelectEnd1
SysSelect1Case22
	movlw	21
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case23
	banksel	ANSELC
	bsf	ANSELC,5
	goto	SysSelectEnd1
SysSelect1Case23
	movlw	22
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelect1Case24
	banksel	ANSELC
	bsf	ANSELC,6
	goto	SysSelectEnd1
SysSelect1Case24
	movlw	23
	subwf	ADREADPORT,W
	btfss	STATUS, Z
	goto	SysSelectEnd1
	banksel	ANSELC
	bsf	ANSELC,7
SysSelectEnd1
	banksel	ADCON1
	bcf	ADCON1,ADCS2
	bcf	ADCON1,ADCS1
	bsf	ADCON1,ADCS0
	bcf	ADCON0,CHS0
	bcf	ADCON0,CHS1
	bcf	ADCON0,CHS2
	bcf	ADCON0,CHS3
	bcf	ADCON0,CHS4
	bcf	ADCON0,CHS5
	banksel	ADREADPORT
	btfss	ADREADPORT,0
	goto	ENDIF12
	banksel	ADCON0
	bsf	ADCON0,CHS0
ENDIF12
	banksel	ADREADPORT
	btfss	ADREADPORT,1
	goto	ENDIF13
	banksel	ADCON0
	bsf	ADCON0,CHS1
ENDIF13
	banksel	ADREADPORT
	btfss	ADREADPORT,2
	goto	ENDIF14
	banksel	ADCON0
	bsf	ADCON0,CHS2
ENDIF14
	banksel	ADREADPORT
	btfss	ADREADPORT,3
	goto	ENDIF15
	banksel	ADCON0
	bsf	ADCON0,CHS3
ENDIF15
	banksel	ADREADPORT
	btfss	ADREADPORT,4
	goto	ENDIF16
	banksel	ADCON0
	bsf	ADCON0,CHS4
ENDIF16
	banksel	ADREADPORT
	btfss	ADREADPORT,5
	goto	ENDIF17
	banksel	ADCON0
	bsf	ADCON0,CHS5
ENDIF17
	banksel	ADCON0
	bsf	ADCON0,ADON
	movlw	2
	movwf	SysWaitTemp10US
	banksel	STATUS
	call	Delay_10US
	banksel	ADCON0
	bsf	ADCON0,GONDONE
	nop
SysWaitLoop1
	btfsc	ADCON0,GONDONE
	goto	SysWaitLoop1
	bcf	ADCON0,ADON
	banksel	ANSELA
	clrf	ANSELA
	clrf	ANSELB
	clrf	ANSELC
	banksel	ADRESL
	movf	ADRESL,W
	banksel	READAD10
	movwf	READAD10
	clrf	READAD10_H
	banksel	ADRESH
	movf	ADRESH,W
	banksel	READAD10_H
	movwf	READAD10_H
	banksel	ADCON1
	bcf	ADCON1,ADFM
	banksel	STATUS
	return

;********************************************************************************

FN_RIGHT
	movf	SysSYSINSTRINGHandler,W
	movwf	AFSR0
	movf	SysSYSINSTRINGHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,F
	btfss	STATUS, Z
	goto	ENDIF20
	banksel	SYSRIGHT_0
	clrf	SYSRIGHT_0
	banksel	STATUS
	return
ENDIF20
	movf	SysSYSINSTRINGHandler,W
	movwf	AFSR0
	movf	SysSYSINSTRINGHandler_H,W
	movwf	AFSR0_H
	movf	SYSCHARCOUNT,W
	subwf	INDF0,W
	btfsc	STATUS, C
	goto	ENDIF21
	movf	SysSYSINSTRINGHandler,W
	movwf	AFSR0
	movf	SysSYSINSTRINGHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	SYSCHARCOUNT
ENDIF21
	movf	SysSYSINSTRINGHandler,W
	movwf	AFSR0
	movf	SysSYSINSTRINGHandler_H,W
	movwf	AFSR0_H
	movf	SYSCHARCOUNT,W
	subwf	INDF0,W
	movwf	SYSCHARSTART
	clrf	SYSSTRINGTEMP
	movlw	1
	subwf	SYSCHARCOUNT,W
	btfss	STATUS, C
	goto	SysForLoopEnd1
SysForLoop1
	incf	SYSSTRINGTEMP,F
	movf	SYSSTRINGTEMP,W
	addwf	SYSCHARSTART,W
	movwf	SysTemp2
	addwf	SysSYSINSTRINGHandler,W
	movwf	AFSR0
	movlw	0
	addwfc	SysSYSINSTRINGHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	SysArrayTemp2
	movwf	SysArrayTemp1
	movlw	low(RIGHT)
	addwf	SYSSTRINGTEMP,W
	movwf	AFSR0
	clrf	SysTemp2
	movlw	high(RIGHT)
	addwfc	SysTemp2,W
	movwf	AFSR0_H
	movf	SysArrayTemp1,W
	movwf	INDF0
	movf	SYSCHARCOUNT,W
	subwf	SYSSTRINGTEMP,W
	btfss	STATUS, C
	goto	SysForLoop1
SysForLoopEnd1
	movf	SYSCHARCOUNT,W
	banksel	SYSRIGHT_0
	movwf	SYSRIGHT_0
	banksel	STATUS
	return

;********************************************************************************

SYSCOMPEQUAL16
	clrf	SYSBYTETEMPX
	movf	SYSWORDTEMPA, W
	subwf	SYSWORDTEMPB, W
	btfss	STATUS, Z
	return
	movf	SYSWORDTEMPA_H, W
	subwf	SYSWORDTEMPB_H, W
	btfss	STATUS, Z
	return
	comf	SYSBYTETEMPX,F
	return

;********************************************************************************

SYSCOMPLESSTHAN
	clrf	SYSBYTETEMPX
	bsf	STATUS, C
	movf	SYSBYTETEMPB, W
	subwf	SYSBYTETEMPA, W
	btfss	STATUS, C
	comf	SYSBYTETEMPX,F
	return

;********************************************************************************

SYSCOPYSTRING
	movf	INDF0, W
	movwf	SYSCALCTEMPA
	movwf	INDF1
	goto	SYSCOPYSTRINGCHECK
SYSCOPYSTRINGPART
	movf	INDF0, W
	movwf	SYSCALCTEMPA
	addwf	SYSSTRINGLENGTH, F
SYSCOPYSTRINGCHECK
	movf	SYSCALCTEMPA,F
	btfsc	STATUS,Z
	return
SYSSTRINGCOPY
	addfsr	0, 1
	addfsr	1, 1
	movf	INDF0, W
	movwf	INDF1
	decfsz	SYSCALCTEMPA, F
	goto	SYSSTRINGCOPY
	return

;********************************************************************************

SYSDIVSUB
	movf	SYSBYTETEMPB, F
	btfsc	STATUS, Z
	return
	clrf	SYSBYTETEMPX
	movlw	8
	movwf	SYSDIVLOOP
SYSDIV8START
	bcf	STATUS, C
	rlf	SYSBYTETEMPA, F
	rlf	SYSBYTETEMPX, F
	movf	SYSBYTETEMPB, W
	subwf	SYSBYTETEMPX, F
	bsf	SYSBYTETEMPA, 0
	btfsc	STATUS, C
	goto	DIV8NOTNEG
	bcf	SYSBYTETEMPA, 0
	movf	SYSBYTETEMPB, W
	addwf	SYSBYTETEMPX, F
DIV8NOTNEG
	decfsz	SYSDIVLOOP, F
	goto	SYSDIV8START
	return

;********************************************************************************

SYSDIVSUB16
	movf	SYSWORDTEMPA,W
	movwf	SYSDIVMULTA
	movf	SYSWORDTEMPA_H,W
	movwf	SYSDIVMULTA_H
	movf	SYSWORDTEMPB,W
	movwf	SYSDIVMULTB
	movf	SYSWORDTEMPB_H,W
	movwf	SYSDIVMULTB_H
	clrf	SYSDIVMULTX
	clrf	SYSDIVMULTX_H
	movf	SYSDIVMULTB,W
	movwf	SysWORDTempA
	movf	SYSDIVMULTB_H,W
	movwf	SysWORDTempA_H
	clrf	SysWORDTempB
	clrf	SysWORDTempB_H
	call	SysCompEqual16
	btfss	SysByteTempX,0
	goto	ENDIF18
	clrf	SYSWORDTEMPA
	clrf	SYSWORDTEMPA_H
	return
ENDIF18
	movlw	16
	movwf	SYSDIVLOOP
SYSDIV16START
	bcf	STATUS,C
	rlf	SYSDIVMULTA,F
	rlf	SYSDIVMULTA_H,F
	rlf	SYSDIVMULTX,F
	rlf	SYSDIVMULTX_H,F
	movf	SYSDIVMULTB,W
	subwf	SYSDIVMULTX,F
	movf	SYSDIVMULTB_H,W
	subwfb	SYSDIVMULTX_H,F
	bsf	SYSDIVMULTA,0
	btfsc	STATUS,C
	goto	ENDIF19
	bcf	SYSDIVMULTA,0
	movf	SYSDIVMULTB,W
	addwf	SYSDIVMULTX,F
	movf	SYSDIVMULTB_H,W
	addwfc	SYSDIVMULTX_H,F
ENDIF19
	decfsz	SYSDIVLOOP, F
	goto	SYSDIV16START
	movf	SYSDIVMULTA,W
	movwf	SYSWORDTEMPA
	movf	SYSDIVMULTA_H,W
	movwf	SYSWORDTEMPA_H
	movf	SYSDIVMULTX,W
	movwf	SYSWORDTEMPX
	movf	SYSDIVMULTX_H,W
	movwf	SYSWORDTEMPX_H
	return

;********************************************************************************

SYSREADSTRING
	call	SYSSTRINGTABLES
	movwf	SYSCALCTEMPA
	movwf	INDF1
	goto	SYSSTRINGREADCHECK
SYSREADSTRINGPART
	call	SYSSTRINGTABLES
	movwf	SYSCALCTEMPA
	addwf	SYSSTRINGLENGTH,F
SYSSTRINGREADCHECK
	movf	SYSCALCTEMPA,F
	btfsc	STATUS,Z
	return
SYSSTRINGREAD
	call	SYSSTRINGTABLES
	addfsr	1,1
	movwf	INDF1
	decfsz	SYSCALCTEMPA, F
	goto	SYSSTRINGREAD
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
	retlw	21
	retlw	71	;G
	retlw	114	;r
	retlw	101	;e
	retlw	97	;a
	retlw	116	;t
	retlw	32	; 
	retlw	67	;C
	retlw	111	;o
	retlw	119	;w
	retlw	32	; 
	retlw	66	;B
	retlw	97	;a
	retlw	115	;s
	retlw	105	;i
	retlw	99	;c
	retlw	32	; 
	retlw	64	;
	retlw	50	;2
	retlw	48	;0
	retlw	49	;1
	retlw	54	;6


StringTable2
	retlw	14
	retlw	49	;1
	retlw	54	;6
	retlw	102	;f
	retlw	49	;1
	retlw	53	;5
	retlw	51	;3
	retlw	53	;5
	retlw	53	;5
	retlw	32	; 
	retlw	68	;D
	retlw	101	;e
	retlw	109	;m
	retlw	111	;o
	retlw	32	; 


StringTable3
	retlw	3
	retlw	80	;P
	retlw	58	;:
	retlw	32	; 


StringTable4
	retlw	3
	retlw	62	;>
	retlw	62	;>
	retlw	32	; 


StringTable5
	retlw	3
	retlw	60	;<
	retlw	60	;<
	retlw	32	; 


StringTable30
	retlw	0


StringTable31
	retlw	1
	retlw	49	;1


StringTable32
	retlw	1
	retlw	48	;0


;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
