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
DEVICEID	EQU	33
DISPLAYNEWLINE	EQU	34
HEX	EQU	124
HI2C2ACKPOLLSTATE	EQU	35
HI2C2CURRENTMODE	EQU	36
HI2C2WAITMSSPTIMEOUT	EQU	37
HI2CCURRENTMODE	EQU	38
HSERPRINTCRLFCOUNT	EQU	39
I2CBYTE	EQU	40
PRINTLEN	EQU	41
SERDATA	EQU	42
STRINGPOINTER	EQU	43
SYSBITVAR0	EQU	44
SYSBYTETEMPA	EQU	117
SYSBYTETEMPB	EQU	121
SYSBYTETEMPX	EQU	112
SYSDIVLOOP	EQU	116
SYSPRINTDATAHANDLER	EQU	45
SYSPRINTDATAHANDLER_H	EQU	46
SYSPRINTTEMP	EQU	47
SYSREPEATTEMP1	EQU	48
SYSSTRINGA	EQU	119
SYSSTRINGA_H	EQU	120
SYSSTRINGTEMP	EQU	49
SYSTEMP1	EQU	50
SYSVALTEMP	EQU	51
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115

;********************************************************************************

;Alias variables
AFSR0	EQU	4
AFSR0_H	EQU	5
SYSHEX_0	EQU	124
SYSHEX_1	EQU	125
SYSHEX_2	EQU	126

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
	call	HI2C2INIT
	call	INITUSART
	call	HIC2INIT

;Start of the main program
	bcf	TRISC,0
	bcf	TRISC,1
	bcf	TRISC,2
	bcf	TRISC,3
	bsf	TRISA,1
	bsf	TRISB,2
	bsf	TRISB,1
	movlw	12
	movwf	HI2C2CURRENTMODE
	call	HI2C2MODE
	movlw	1
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
	call	HSERPRINT268
	movlw	2
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
SysDoLoop_S1
	bcf	LATC,0
	bcf	LATC,1
	bcf	LATC,2
	bcf	LATC,3
	movlw	low StringTable2
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable2) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	movlw	255
	movwf	DEVICEID
SysForLoop1
	incf	DEVICEID,F
	movf	DEVICEID,W
	movwf	SYSVALTEMP
	call	FN_HEX
	movlw	low HEX
	movwf	SysPRINTDATAHandler
	movlw	high HEX
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	movlw	low StringTable3
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable3) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	movlw	15
	subwf	DEVICEID,W
	btfss	STATUS, C
	goto	SysForLoop1
SysForLoopEnd1
	movlw	255
	movwf	DEVICEID
SysForLoop2
	incf	DEVICEID,F
	movf	DEVICEID,W
	movwf	SysBYTETempA
	movlw	16
	movwf	SysBYTETempB
	call	SysDivSub
	movf	SysBYTETempX,W
	movwf	DISPLAYNEWLINE
	movf	DISPLAYNEWLINE,F
	btfss	STATUS, Z
	goto	ENDIF2
	movlw	1
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	movf	DEVICEID,W
	movwf	SYSVALTEMP
	call	FN_HEX
	movlw	low HEX
	movwf	SysPRINTDATAHandler
	movlw	high HEX
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	movlw	low StringTable4
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable4) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
ENDIF2
	movlw	low StringTable3
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable3) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	call	HI2C2START
	incf	HI2C2WAITMSSPTIMEOUT,W
	btfsc	STATUS, Z
	goto	ENDIF3
	movf	DEVICEID,W
	movwf	I2CBYTE
	call	HI2C2SEND
	movf	HI2C2ACKPOLLSTATE,F
	btfss	STATUS, Z
	goto	ELSE5_1
	movf	DEVICEID,W
	movwf	SYSVALTEMP
	call	FN_HEX
	movlw	low HEX
	movwf	SysPRINTDATAHandler
	movlw	high HEX
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	goto	ENDIF5
ELSE5_1
	movlw	low StringTable5
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable5) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
ENDIF5
	clrf	I2CBYTE
	call	HI2C2SEND
ENDIF3
	call	HI2C2STOP
	movlw	255
	subwf	DEVICEID,W
	btfss	STATUS, C
	goto	SysForLoop2
SysForLoopEnd2
	movlw	2
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	movlw	low StringTable6
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable6) | 128
	movwf	SysPRINTDATAHandler_H
	movlw	1
	movwf	COMPORT
	call	HSERPRINT268
	movlw	2
	movwf	HSERPRINTCRLFCOUNT
	movlw	1
	movwf	COMPORT
	call	HSERPRINTCRLF
	bsf	LATC,0
	bsf	LATC,1
	bsf	LATC,2
	bsf	LATC,3
SysWaitLoop1
	btfss	PORTA,1
	goto	SysWaitLoop1
	goto	SysDoLoop_S1
SysDoLoop_E1
	goto	BASPROGRAMEND
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

FN_HEX
	movlw	2
	movwf	SYSHEX_0
	movlw	15
	andwf	SYSVALTEMP,W
	movwf	SYSSTRINGTEMP
	sublw	9
	btfsc	STATUS, C
	goto	ENDIF20
	movlw	7
	addwf	SYSSTRINGTEMP,F
ENDIF20
	movlw	48
	addwf	SYSSTRINGTEMP,W
	movwf	SYSHEX_2
	clrf	SYSSTRINGTEMP
SysForLoop3
	incf	SYSSTRINGTEMP,F
	rrf	SYSVALTEMP,F
	movlw	4
	subwf	SYSSTRINGTEMP,W
	btfss	STATUS, C
	goto	SysForLoop3
SysForLoopEnd3
	movlw	15
	andwf	SYSVALTEMP,W
	movwf	SYSSTRINGTEMP
	sublw	9
	btfsc	STATUS, C
	goto	ENDIF22
	movlw	7
	addwf	SYSSTRINGTEMP,F
ENDIF22
	movlw	48
	addwf	SYSSTRINGTEMP,W
	movwf	SYSHEX_1
	return

;********************************************************************************

HI2C2INIT
	clrf	HI2C2CURRENTMODE
	return

;********************************************************************************

HI2C2MODE
	banksel	SSP2STAT
	bsf	SSP2STAT,SSP2STAT_SMP
	bsf	SSP2CON1,SSP2CON1_CKP
	bcf	SSP2CON1,SSP2CON1_WCOL
	movlw	12
	banksel	HI2C2CURRENTMODE
	subwf	HI2C2CURRENTMODE,W
	btfss	STATUS, Z
	goto	ENDIF9
	banksel	SSP2CON1
	bsf	SSP2CON1,SSP2CON1_SSPM3
	bcf	SSP2CON1,SSP2CON1_SSPM2
	bcf	SSP2CON1,SSP2CON1_SSPM1
	bcf	SSP2CON1,SSP2CON1_SSPM0
	movlw	19
	movwf	SSP2ADD
ENDIF9
	banksel	HI2C2CURRENTMODE
	movf	HI2C2CURRENTMODE,F
	btfss	STATUS, Z
	goto	ENDIF10
	banksel	SSP2CON1
	bcf	SSP2CON1,SSP2CON1_SSPM3
	bsf	SSP2CON1,SSP2CON1_SSPM2
	bsf	SSP2CON1,SSP2CON1_SSPM1
	bcf	SSP2CON1,SSP2CON1_SSPM0
ENDIF10
	movlw	3
	banksel	HI2C2CURRENTMODE
	subwf	HI2C2CURRENTMODE,W
	btfss	STATUS, Z
	goto	ENDIF11
	banksel	SSP2CON1
	bcf	SSP2CON1,SSP2CON1_SSPM3
	bsf	SSP2CON1,SSP2CON1_SSPM2
	bsf	SSP2CON1,SSP2CON1_SSPM1
	bsf	SSP2CON1,SSP2CON1_SSPM0
ENDIF11
	banksel	SSP2CON1
	bsf	SSP2CON1,SSP2CON1_SSPEN
	banksel	STATUS
	return

;********************************************************************************

HI2C2SEND
RETRYHI2C2SEND
	banksel	SSP2CON1
	bcf	SSP2CON1,SSP2CON1_WCOL
	banksel	I2CBYTE
	movf	I2CBYTE,W
	banksel	SSP2BUF
	movwf	SSP2BUF
	banksel	STATUS
	call	HI2C2WAITMSSP
	banksel	SSP2CON2
	btfss	SSP2CON2,SSP2CON2_ACKSTAT
	goto	ELSE14_1
	movlw	255
	banksel	HI2C2ACKPOLLSTATE
	movwf	HI2C2ACKPOLLSTATE
	goto	ENDIF14
ELSE14_1
	banksel	HI2C2ACKPOLLSTATE
	clrf	HI2C2ACKPOLLSTATE
ENDIF14
	banksel	SSP2CON1
	btfss	SSP2CON1,SSP2CON1_WCOL
	goto	ENDIF15
	banksel	HI2C2CURRENTMODE
	movf	HI2C2CURRENTMODE,W
	sublw	10
	btfsc	STATUS, C
	goto	RETRYHI2C2SEND
ENDIF15
	banksel	HI2C2CURRENTMODE
	movf	HI2C2CURRENTMODE,W
	sublw	10
	btfss	STATUS, C
	goto	ENDIF16
	banksel	SSP2CON1
	bsf	SSP2CON1,SSP2CON1_CKP
ENDIF16
	banksel	STATUS
	return

;********************************************************************************

HI2C2START
	movf	HI2C2CURRENTMODE,W
	sublw	10
	btfsc	STATUS, C
	goto	ELSE12_1
	banksel	SSP2CON2
	bsf	SSP2CON2,SSP2CON2_SEN
	banksel	STATUS
	call	HI2C2WAITMSSP
	goto	ENDIF12
ELSE12_1
SysWaitLoop2
	banksel	SSP2STAT
	btfss	SSP2STAT,SSP2STAT_S
	goto	SysWaitLoop2
ENDIF12
	banksel	STATUS
	return

;********************************************************************************

HI2C2STOP
	movf	HI2C2CURRENTMODE,W
	sublw	10
	btfsc	STATUS, C
	goto	ELSE13_1
SysWaitLoop3
	banksel	SSP2STAT
	btfsc	SSP2STAT,SSP2STAT_R_NOT_W
	goto	SysWaitLoop3
	bsf	SSP2CON2,SSP2CON2_PEN
	banksel	STATUS
	call	HI2C2WAITMSSP
	goto	ENDIF13
ELSE13_1
SysWaitLoop4
	banksel	SSP2STAT
	btfss	SSP2STAT,SSP2STAT_P
	goto	SysWaitLoop4
ENDIF13
	banksel	STATUS
	return

;********************************************************************************

HI2C2WAITMSSP
	clrf	HI2C2WAITMSSPTIMEOUT
HI2C2WAITMSSPWAIT
	banksel	HI2C2WAITMSSPTIMEOUT
	incf	HI2C2WAITMSSPTIMEOUT,F
	movlw	255
	subwf	HI2C2WAITMSSPTIMEOUT,W
	btfsc	STATUS, C
	goto	ENDIF18
	banksel	PIR3
	btfss	PIR3,SSP2IF
	goto	HI2C2WAITMSSPWAIT
	bcf	PIR3,SSP2IF
ENDIF18
	banksel	STATUS
	return

;********************************************************************************

HIC2INIT
	clrf	HI2CCURRENTMODE
	return

;********************************************************************************

;Overloaded signature: STRING:byte:
HSERPRINT268
	movf	SysPRINTDATAHandler,W
	movwf	AFSR0
	movf	SysPRINTDATAHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	PRINTLEN
	movf	PRINTLEN,F
	btfsc	STATUS, Z
	goto	ENDIF24
	clrf	SYSPRINTTEMP
	movlw	1
	subwf	PRINTLEN,W
	btfss	STATUS, C
	goto	SysForLoopEnd4
SysForLoop4
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
	goto	SysForLoop4
SysForLoopEnd4
ENDIF24
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

HSERSEND
	decf	COMPORT,W
	btfss	STATUS, Z
	goto	ENDIF23
SysWaitLoop5
	banksel	PIR3
	btfss	PIR3,TX1IF
	goto	SysWaitLoop5
;txreg equals serdata below will assign serdata to txreg | txreg1 | txreg via the #samevar
	banksel	SERDATA
	movf	SERDATA,W
	banksel	TXREG
	movwf	TXREG
SysWaitLoop6
	btfss	TX1STA,TRMT
	goto	SysWaitLoop6
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	banksel	STATUS
	call	Delay_MS
	return
ENDIF23
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
	movlw	23
	movwf	RB1PPS
	movlw	9
	banksel	SSP2CLKPPS
	movwf	SSP2CLKPPS
	movlw	10
	movwf	SSP2DATPPS
	movlw	24
	banksel	RB2PPS
	movwf	RB2PPS
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
	retlw	14
	retlw	72	;H
	retlw	97	;a
	retlw	114	;r
	retlw	100	;d
	retlw	119	;w
	retlw	97	;a
	retlw	114	;r
	retlw	101	;e
	retlw	32	; 
	retlw	73	;I
	retlw	50	;2
	retlw	67	;C
	retlw	50	;2
	retlw	32	; 


StringTable2
	retlw	5
	retlw	32	; 
	retlw	32	; 
	retlw	32	; 
	retlw	32	; 
	retlw	32	; 


StringTable3
	retlw	1
	retlw	32	; 


StringTable4
	retlw	2
	retlw	58	;:
	retlw	32	; 


StringTable5
	retlw	2
	retlw	45	;-
	retlw	45	;-


StringTable6
	retlw	43
	retlw	69	;E
	retlw	110	;n
	retlw	100	;d
	retlw	32	; 
	retlw	111	;o
	retlw	102	;f
	retlw	32	; 
	retlw	83	;S
	retlw	101	;e
	retlw	97	;a
	retlw	114	;r
	retlw	99	;c
	retlw	104	;h
	retlw	32	; 
	retlw	45	;-
	retlw	32	; 
	retlw	80	;P
	retlw	114	;r
	retlw	101	;e
	retlw	115	;s
	retlw	115	;s
	retlw	32	; 
	retlw	98	;b
	retlw	117	;u
	retlw	116	;t
	retlw	116	;t
	retlw	111	;o
	retlw	110	;n
	retlw	32	; 
	retlw	116	;t
	retlw	111	;o
	retlw	32	; 
	retlw	114	;r
	retlw	101	;e
	retlw	112	;p
	retlw	101	;e
	retlw	97	;a
	retlw	116	;t
	retlw	32	; 
	retlw	116	;t
	retlw	101	;e
	retlw	115	;s
	retlw	116	;t


;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
