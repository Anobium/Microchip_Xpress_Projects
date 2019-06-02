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
ANSIXPOS	EQU	32
ANSIYPOS	EQU	33
CHR	EQU	9159
COMPORT	EQU	34
DELAYTEMP	EQU	112
DELAYTEMP2	EQU	113
LCDCRSR	EQU	35
OUTVALUETEMP	EQU	36
PRINTLEN	EQU	37
SERDATA	EQU	38
SERPRINTVAL	EQU	39
STRINGPOINTER	EQU	40
SYSBITVAR0	EQU	41
SYSBYTETEMPA	EQU	117
SYSBYTETEMPB	EQU	121
SYSBYTETEMPX	EQU	112
SYSCALCTEMPX	EQU	112
SYSCHAR	EQU	42
SYSDIVLOOP	EQU	116
SYSPRINTDATAHANDLER	EQU	43
SYSPRINTDATAHANDLER_H	EQU	44
SYSPRINTTEMP	EQU	45
SYSSTRINGA	EQU	119
SYSSTRINGA_H	EQU	120
SYSTEMP1	EQU	46
SYSTEMP2	EQU	47
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115
SYSWAITTEMPS	EQU	116
XPOS	EQU	48
YPOS	EQU	49

;********************************************************************************

;Alias variables
AFSR0	EQU	4
AFSR0_H	EQU	5
SYSCHR_0	EQU	1575
SYSCHR_1	EQU	1576

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
SysDoLoop_S1
	movlw	7
	movwf	SYSCHAR
	call	FN_CHR
	movlw	low CHR
	movwf	SysPRINTDATAHandler
	movlw	high CHR
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	call	ANSIERASECREEN
	movlw	low StringTable1
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable1) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	1
	movwf	ANSIYPOS
	clrf	ANSIXPOS
	call	ANSI_REV
	movlw	low StringTable2
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable2) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	clrf	ANSIYPOS
	clrf	ANSIXPOS
	call	ANSI_REV
	movlw	255
	movwf	YPOS
SysForLoop1
	incf	YPOS,F
	movlw	255
	movwf	XPOS
SysForLoop2
	incf	XPOS,F
	movf	YPOS,W
	movwf	ANSIYPOS
	movf	XPOS,W
	movwf	ANSIXPOS
	call	ANSI_REV
	movlw	low StringTable3
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable3) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	low StringTable4
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable4) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	100
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	16
	subwf	XPOS,W
	btfss	STATUS, C
	goto	SysForLoop2
SysForLoopEnd2
	movlw	1
	subwf	YPOS,W
	btfss	STATUS, C
	goto	SysForLoop1
SysForLoopEnd1
	call	ANSIERASECREEN
	clrf	ANSIYPOS
	clrf	ANSIXPOS
	call	ANSI_REV
	movlw	12
	movwf	LCDCRSR
	call	HSERLCDCURSOR
	movlw	low StringTable5
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable5) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	goto	SysDoLoop_S1
SysDoLoop_E1
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

;********************************************************************************

ANSI
	movlw	27
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movlw	low StringTable6
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable6) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movf	ANSIYPOS,W
	movwf	SERPRINTVAL
	movlw	1
	movwf	COMPORT
	call	HSERPRINT264
	movlw	59
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movf	ANSIXPOS,W
	movwf	SERPRINTVAL
	movlw	1
	movwf	COMPORT
	call	HSERPRINT264
	movlw	low StringTable7
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable7) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	goto	HSERPRINT263

;********************************************************************************

ANSIERASECREEN
	movlw	27
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movlw	low StringTable6
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable6) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	low StringTable8
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable8) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	low StringTable9
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable9) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	clrf	ANSIXPOS
	clrf	ANSIYPOS
	call	ANSI
	movlw	27
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movlw	low StringTable6
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable6) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	low StringTable10
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable10) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	low StringTable11
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable11) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movlw	low StringTable12
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable12) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	goto	HSERPRINT263

;********************************************************************************

ANSI_REV
	incf	ANSIYPOS,F
	movlw	27
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movlw	low StringTable6
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable6) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT263
	movf	ANSIYPOS,W
	movwf	SERPRINTVAL
	movlw	1
	movwf	COMPORT
	call	HSERPRINT264
	movlw	59
	movwf	SERDATA
	movlw	1
	movwf	COMPORT
	call	HSERSEND
	movf	ANSIXPOS,W
	movwf	SERPRINTVAL
	movlw	1
	movwf	COMPORT
	call	HSERPRINT264
	movlw	low StringTable7
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable7) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	goto	HSERPRINT263

;********************************************************************************

FN_CHR
	movlw	0
	subwf	SYSCHAR,W
	btfsc	STATUS, C
	goto	ENDIF6
	banksel	SYSCHR_0
	clrf	SYSCHR_0
	banksel	STATUS
	return
ENDIF6
	movlw	1
	banksel	SYSCHR_0
	movwf	SYSCHR_0
	banksel	SYSCHAR
	movf	SYSCHAR,W
	banksel	SYSCHR_1
	movwf	SYSCHR_1
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

HSERLCDCURSOR
	return

;********************************************************************************

;Overloaded signature: STRING:byte:
HSERPRINT263
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
	goto	SysForLoopEnd3
SysForLoop3
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
	goto	SysForLoop3
SysForLoopEnd3
ENDIF8
	return

;********************************************************************************

;Overloaded signature: BYTE:byte:
HSERPRINT264
	clrf	OUTVALUETEMP
	movlw	100
	subwf	SERPRINTVAL,W
	btfss	STATUS, C
	goto	ENDIF11
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
ENDIF11
	movf	OUTVALUETEMP,W
	movwf	SysBYTETempB
	clrf	SysBYTETempA
	call	SysCompLessThan
	movf	SysByteTempX,W
	movwf	SysTemp1
	movf	SERPRINTVAL,W
	movwf	SysBYTETempA
	movlw	10
	movwf	SysBYTETempB
	call	SysCompLessThan
	comf	SysByteTempX,F
	movf	SysTemp1,W
	iorwf	SysByteTempX,W
	movwf	SysTemp2
	btfss	SysTemp2,0
	goto	ENDIF12
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
ENDIF12
	movlw	48
	addwf	SERPRINTVAL,W
	movwf	SERDATA
	goto	HSERSEND

;********************************************************************************

HSERSEND
	decf	COMPORT,W
	btfss	STATUS, Z
	goto	ENDIF7
SysWaitLoop1
	banksel	PIR3
	btfss	PIR3,TX1IF
	goto	SysWaitLoop1
;txreg equals serdata below will assign serdata to txreg | txreg1 | txreg via the #samevar
	banksel	SERDATA
	movf	SERDATA,W
	banksel	TXREG
	movwf	TXREG
SysWaitLoop2
	btfss	TX1STA,TRMT
	goto	SysWaitLoop2
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	banksel	STATUS
	call	Delay_MS
	return
ENDIF7
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

SYSCOMPLESSTHAN
	clrf	SYSBYTETEMPX
	bsf	STATUS, C
	movf	SYSBYTETEMPB, W
	subwf	SYSBYTETEMPA, W
	btfss	STATUS, C
	comf	SYSBYTETEMPX,F
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

SysStringTables
	movf	SysStringA_H,W
	movwf	PCLATH
	movf	SysStringA,W
	incf	SysStringA,F
	btfsc	STATUS,Z
	incf	SysStringA_H,F
	movwf	PCL

StringTable1
	retlw	10
	retlw	83	;S
	retlw	84	;T
	retlw	65	;A
	retlw	82	;R
	retlw	84	;T
	retlw	32	; 
	retlw	84	;T
	retlw	69	;E
	retlw	83	;S
	retlw	84	;T


StringTable2
	retlw	10
	retlw	68	;D
	retlw	73	;I
	retlw	83	;S
	retlw	80	;P
	retlw	76	;L
	retlw	65	;A
	retlw	89	;Y
	retlw	32	; 
	retlw	79	;O
	retlw	78	;N


StringTable3
	retlw	1
	retlw	42	;*


StringTable4
	retlw	0


StringTable5
	retlw	8
	retlw	69	;E
	retlw	78	;N
	retlw	68	;D
	retlw	32	; 
	retlw	84	;T
	retlw	69	;E
	retlw	83	;S
	retlw	84	;T


StringTable6
	retlw	1
	retlw	91	;[


StringTable7
	retlw	1
	retlw	72	;H


StringTable8
	retlw	1
	retlw	50	;2


StringTable9
	retlw	1
	retlw	74	;J


StringTable10
	retlw	1
	retlw	63	;?


StringTable11
	retlw	2
	retlw	50	;2
	retlw	53	;5


StringTable12
	retlw	1
	retlw	108	;l


;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
