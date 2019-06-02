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
HI2CACKPOLLSTATE	EQU	32
HI2CCURRENTMODE	EQU	33
HI2CWAITMSSPTIMEOUT	EQU	34
I2CBYTE	EQU	35
I2C_LCD_BYTE	EQU	36
LCDBYTE	EQU	37
LCDCOLUMN	EQU	38
LCDCRSR	EQU	39
LCDLINE	EQU	40
LCDTEMP	EQU	41
LCD_BACKLIGHT	EQU	42
LCD_I2C_ADDRESS_CURRENT	EQU	43
LCD_STATE	EQU	44
PRINTLEN	EQU	45
STRINGPOINTER	EQU	46
SYSBITVAR0	EQU	47
SYSBYTETEMPA	EQU	117
SYSBYTETEMPB	EQU	121
SYSBYTETEMPX	EQU	112
SYSLCDTEMP	EQU	48
SYSPRINTDATAHANDLER	EQU	49
SYSPRINTDATAHANDLER_H	EQU	50
SYSPRINTTEMP	EQU	51
SYSREPEATTEMP1	EQU	52
SYSREPEATTEMP2	EQU	53
SYSSTRINGA	EQU	119
SYSSTRINGA_H	EQU	120
SYSTEMP1	EQU	54
SYSWAITTEMP10US	EQU	117
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115
SYSWAITTEMPS	EQU	116
SYSWAITTEMPUS	EQU	117
SYSWAITTEMPUS_H	EQU	118

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
	call	HIC2INIT
	call	INITLCD

;Start of the main program
	bsf	TRISB,2
	bsf	TRISB,1
	movlw	12
	movwf	HI2CCURRENTMODE
	call	HI2CMODE
	call	CLS
	movlw	low StringTable1
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable1) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable2
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable2) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
SysDoLoop_S1
	call	CLS
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	movlw	low StringTable3
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable3) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable4
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable4) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	call	CLS
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable5
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable5) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	10
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	call	CLS
	movlw	13
	movwf	LCDCRSR
	call	LCDCURSOR
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable6
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable6) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	call	CLS
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable7
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable7) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	9
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	call	CLS
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable8
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable8) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	14
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable9
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable9) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	10
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	9
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable10
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable10) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	13
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	14
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	call	CLS
	clrf	LCDLINE
	movlw	4
	movwf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable11
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable11) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	movlw	4
	movwf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable12
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable12) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	244
	movwf	SysWaitTempMS
	movlw	1
	movwf	SysWaitTempMS_H
	call	Delay_MS
	movlw	10
	movwf	SysRepeatTemp1
SysRepeatLoop1
	movlw	11
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	244
	movwf	SysWaitTempMS
	movlw	1
	movwf	SysWaitTempMS_H
	call	Delay_MS
	movlw	12
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	244
	movwf	SysWaitTempMS
	movlw	1
	movwf	SysWaitTempMS_H
	call	Delay_MS
	decfsz	SysRepeatTemp1,F
	goto	SysRepeatLoop1
SysRepeatLoopEnd1
	call	CLS
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable13
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable13) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	1
	movwf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	low StringTable14
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable14) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	2
	movwf	SysWaitTempS
	call	Delay_S
	movlw	11
	movwf	LCDCRSR
	call	LCDCURSOR
	clrf	LCDTEMP
	call	LCDBACKLIGHT
	movlw	5
	movwf	SysWaitTempS
	call	Delay_S
	movlw	1
	movwf	LCDTEMP
	call	LCDBACKLIGHT
	call	CLS
	clrf	LCDLINE
	clrf	LCDCOLUMN
	call	LOCATE
	movlw	12
	movwf	LCDCRSR
	call	LCDCURSOR
	movlw	low StringTable15
	movwf	SysPRINTDATAHandler
	movlw	(high StringTable15) | 128
	movwf	SysPRINTDATAHandler_H
	call	PRINT108
	movlw	3
	movwf	SysWaitTempS
	call	Delay_S
	goto	SysDoLoop_S1
SysDoLoop_E1
	goto	BASPROGRAMEND
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

;********************************************************************************

CLS
	bcf	SYSLCDTEMP,1
	movlw	1
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	4
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	128
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	12
	movwf	SysWaitTemp10US
	goto	Delay_10US

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

HI2CMODE
	banksel	SSP1STAT
	bsf	SSP1STAT,SMP
	bsf	SSP1CON1,CKP
	bcf	SSP1CON1,WCOL
	movlw	12
	banksel	HI2CCURRENTMODE
	subwf	HI2CCURRENTMODE,W
	btfss	STATUS, Z
	goto	ENDIF32
	banksel	SSP1CON1
	bsf	SSP1CON1,SSPM3
	bcf	SSP1CON1,SSPM2
	bcf	SSP1CON1,SSPM1
	bcf	SSP1CON1,SSPM0
	movlw	19
	movwf	SSP1ADD
ENDIF32
	banksel	HI2CCURRENTMODE
	movf	HI2CCURRENTMODE,F
	btfss	STATUS, Z
	goto	ENDIF33
	banksel	SSP1CON1
	bcf	SSP1CON1,SSPM3
	bsf	SSP1CON1,SSPM2
	bsf	SSP1CON1,SSPM1
	bcf	SSP1CON1,SSPM0
ENDIF33
	movlw	3
	banksel	HI2CCURRENTMODE
	subwf	HI2CCURRENTMODE,W
	btfss	STATUS, Z
	goto	ENDIF34
	banksel	SSP1CON1
	bcf	SSP1CON1,SSPM3
	bsf	SSP1CON1,SSPM2
	bsf	SSP1CON1,SSPM1
	bsf	SSP1CON1,SSPM0
ENDIF34
	banksel	SSP1CON1
	bsf	SSP1CON1,SSPEN
	banksel	STATUS
	return

;********************************************************************************

HI2CSEND
RETRYHI2CSEND
	banksel	SSP1CON1
	bcf	SSP1CON1,WCOL
	banksel	I2CBYTE
	movf	I2CBYTE,W
	banksel	SSP1BUF
	movwf	SSP1BUF
	banksel	STATUS
	call	HI2CWAITMSSP
	banksel	SSP1CON2
	btfss	SSP1CON2,ACKSTAT
	goto	ELSE37_1
	movlw	255
	banksel	HI2CACKPOLLSTATE
	movwf	HI2CACKPOLLSTATE
	goto	ENDIF37
ELSE37_1
	banksel	HI2CACKPOLLSTATE
	clrf	HI2CACKPOLLSTATE
ENDIF37
	banksel	SSP1CON1
	btfss	SSP1CON1,WCOL
	goto	ENDIF38
	banksel	HI2CCURRENTMODE
	movf	HI2CCURRENTMODE,W
	sublw	10
	btfsc	STATUS, C
	goto	RETRYHI2CSEND
ENDIF38
	banksel	HI2CCURRENTMODE
	movf	HI2CCURRENTMODE,W
	sublw	10
	btfss	STATUS, C
	goto	ENDIF39
	banksel	SSP1CON1
	bsf	SSP1CON1,CKP
ENDIF39
	banksel	STATUS
	return

;********************************************************************************

HI2CSTART
	movf	HI2CCURRENTMODE,W
	sublw	10
	btfsc	STATUS, C
	goto	ELSE35_1
	banksel	SSP1CON2
	bsf	SSP1CON2,SEN
	banksel	STATUS
	call	HI2CWAITMSSP
	goto	ENDIF35
ELSE35_1
SysWaitLoop1
	banksel	SSP1STAT
	btfss	SSP1STAT,S
	goto	SysWaitLoop1
ENDIF35
	banksel	STATUS
	return

;********************************************************************************

HI2CSTOP
	movf	HI2CCURRENTMODE,W
	sublw	10
	btfsc	STATUS, C
	goto	ELSE36_1
SysWaitLoop2
	banksel	SSP1STAT
	btfsc	SSP1STAT,R_NOT_W
	goto	SysWaitLoop2
	bsf	SSP1CON2,PEN
	banksel	STATUS
	call	HI2CWAITMSSP
	goto	ENDIF36
ELSE36_1
SysWaitLoop3
	banksel	SSP1STAT
	btfss	SSP1STAT,P
	goto	SysWaitLoop3
ENDIF36
	banksel	STATUS
	return

;********************************************************************************

HI2CWAITMSSP
	clrf	HI2CWAITMSSPTIMEOUT
HI2CWAITMSSPWAIT
	banksel	HI2CWAITMSSPTIMEOUT
	incf	HI2CWAITMSSPTIMEOUT,F
	movlw	255
	subwf	HI2CWAITMSSPTIMEOUT,W
	btfsc	STATUS, C
	goto	ENDIF41
	banksel	PIR3
	btfss	PIR3,SSP1IF
	goto	HI2CWAITMSSPWAIT
	bcf	PIR3,SSP1IF
	banksel	STATUS
	return
	banksel	PIR3
	btfss	PIR3,SSP1IF
	goto	HI2CWAITMSSPWAIT
	bcf	PIR3,SSP1IF
	banksel	STATUS
	return
ENDIF41
	return

;********************************************************************************

HIC2INIT
	clrf	HI2CCURRENTMODE
	return

;********************************************************************************

INITI2CLCD
	movlw	15
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	3
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	5
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	3
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	3
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	3
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	2
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	40
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	12
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	1
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	15
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	6
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	1
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	goto	CLS

;********************************************************************************

INITLCD
	movlw	12
	movwf	HI2CCURRENTMODE
	call	HI2CMODE
	movlw	1
	movwf	LCD_BACKLIGHT
	movlw	2
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	2
	movwf	SysRepeatTemp2
SysRepeatLoop2
	movlw	78
	movwf	LCD_I2C_ADDRESS_CURRENT
	call	INITI2CLCD
	decfsz	SysRepeatTemp2,F
	goto	SysRepeatLoop2
SysRepeatLoopEnd2
	movlw	12
	movwf	LCD_STATE
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
	movlw	9
	banksel	SSP1CLKPPS
	movwf	SSP1CLKPPS
	movlw	10
	movwf	SSP1DATPPS
	movlw	21
	banksel	RB1PPS
	movwf	RB1PPS
	movlw	22
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

LCDBACKLIGHT
	movf	LCDTEMP,F
	btfsc	STATUS, Z
	clrf	LCD_BACKLIGHT
	decf	LCDTEMP,W
	btfss	STATUS, Z
	goto	ENDIF31
	movlw	1
	movwf	LCD_BACKLIGHT
ENDIF31
	bcf	SYSLCDTEMP,1
	clrf	LCDBYTE
	goto	LCDNORMALWRITEBYTE

;********************************************************************************

LCDCURSOR
	bcf	SYSLCDTEMP,1
	decf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF21
	movlw	12
	iorwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF21
	movlw	12
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF22
	movlw	12
	iorwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF22
	movf	LCDCRSR,F
	btfss	STATUS, Z
	goto	ENDIF23
	movlw	11
	andwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF23
	movlw	11
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF24
	movlw	11
	andwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF24
	movlw	10
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF25
	movlw	10
	iorwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF25
	movlw	13
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF26
	movlw	13
	andwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF26
	movlw	9
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF27
	movlw	9
	iorwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF27
	movlw	9
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF28
	movlw	9
	iorwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF28
	movlw	14
	subwf	LCDCRSR,W
	btfss	STATUS, Z
	goto	ENDIF29
	movlw	14
	andwf	LCD_STATE,W
	movwf	LCDTEMP
ENDIF29
	movf	LCDTEMP,W
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movf	LCDTEMP,W
	movwf	LCD_STATE
	return

;********************************************************************************

LCDNORMALWRITEBYTE
	btfss	SYSLCDTEMP,1
	goto	ELSE8_1
	bsf	I2C_LCD_BYTE,0
	goto	ENDIF8
ELSE8_1
	bcf	I2C_LCD_BYTE,0
ENDIF8
	bcf	I2C_LCD_BYTE,1
	bcf	I2C_LCD_BYTE,3
	btfsc	LCD_BACKLIGHT,0
	bsf	I2C_LCD_BYTE,3
	call	HI2CSTART
	movf	LCD_I2C_ADDRESS_CURRENT,W
	movwf	I2CBYTE
	call	HI2CSEND
	bcf	I2C_LCD_BYTE,7
	btfsc	LCDBYTE,7
	bsf	I2C_LCD_BYTE,7
	bcf	I2C_LCD_BYTE,6
	btfsc	LCDBYTE,6
	bsf	I2C_LCD_BYTE,6
	bcf	I2C_LCD_BYTE,5
	btfsc	LCDBYTE,5
	bsf	I2C_LCD_BYTE,5
	bcf	I2C_LCD_BYTE,4
	btfsc	LCDBYTE,4
	bsf	I2C_LCD_BYTE,4
	bcf	I2C_LCD_BYTE,2
	movf	I2C_LCD_BYTE,W
	movwf	I2CBYTE
	call	HI2CSEND
	bsf	I2C_LCD_BYTE,2
	movf	I2C_LCD_BYTE,W
	movwf	I2CBYTE
	call	HI2CSEND
	bcf	I2C_LCD_BYTE,2
	movf	I2C_LCD_BYTE,W
	movwf	I2CBYTE
	call	HI2CSEND
	bcf	I2C_LCD_BYTE,7
	btfsc	LCDBYTE,3
	bsf	I2C_LCD_BYTE,7
	bcf	I2C_LCD_BYTE,6
	btfsc	LCDBYTE,2
	bsf	I2C_LCD_BYTE,6
	bcf	I2C_LCD_BYTE,5
	btfsc	LCDBYTE,1
	bsf	I2C_LCD_BYTE,5
	bcf	I2C_LCD_BYTE,4
	btfsc	LCDBYTE,0
	bsf	I2C_LCD_BYTE,4
	bcf	I2C_LCD_BYTE,2
	movf	I2C_LCD_BYTE,W
	movwf	I2CBYTE
	call	HI2CSEND
	bsf	I2C_LCD_BYTE,2
	movf	I2C_LCD_BYTE,W
	movwf	I2CBYTE
	call	HI2CSEND
	bcf	I2C_LCD_BYTE,2
	movf	I2C_LCD_BYTE,W
	movwf	I2CBYTE
	call	HI2CSEND
	call	HI2CSTOP
	movlw	12
	movwf	LCD_STATE
	movlw	26
	movwf	DELAYTEMP
DelayUS1
	decfsz	DELAYTEMP,F
	goto	DelayUS1
	nop
	btfsc	SYSLCDTEMP,1
	goto	ENDIF9
	movlw	16
	subwf	LCDBYTE,W
	btfsc	STATUS, C
	goto	ENDIF10
	movf	LCDBYTE,W
	sublw	7
	btfsc	STATUS, C
	goto	ENDIF11
	movf	LCDBYTE,W
	movwf	LCD_STATE
ENDIF11
ENDIF10
ENDIF9
	return

;********************************************************************************

LOCATE
	bcf	SYSLCDTEMP,1
	movf	LCDLINE,W
	sublw	1
	btfsc	STATUS, C
	goto	ENDIF4
	movlw	2
	subwf	LCDLINE,F
	movlw	20
	addwf	LCDCOLUMN,F
ENDIF4
	movf	LCDLINE,W
	movwf	SysBYTETempA
	movlw	64
	movwf	SysBYTETempB
	call	SysMultSub
	movf	LCDCOLUMN,W
	addwf	SysBYTETempX,W
	movwf	SysTemp1
	movlw	128
	iorwf	SysTemp1,W
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movlw	5
	movwf	SysWaitTemp10US
	goto	Delay_10US

;********************************************************************************

;Overloaded signature: STRING:
PRINT108
	movf	SysPRINTDATAHandler,W
	movwf	AFSR0
	movf	SysPRINTDATAHandler_H,W
	movwf	AFSR0_H
	movf	INDF0,W
	movwf	PRINTLEN
	movf	PRINTLEN,F
	btfsc	STATUS, Z
	return
	bsf	SYSLCDTEMP,1
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
	movwf	LCDBYTE
	call	LCDNORMALWRITEBYTE
	movf	PRINTLEN,W
	subwf	SYSPRINTTEMP,W
	btfss	STATUS, C
	goto	SysForLoop1
SysForLoopEnd1
	return

;********************************************************************************

SYSMULTSUB
	clrf	SYSBYTETEMPX
MUL8LOOP
	movf	SYSBYTETEMPA, W
	btfsc	SYSBYTETEMPB, 0
	addwf	SYSBYTETEMPX, F
	bcf	STATUS, C
	rrf	SYSBYTETEMPB, F
	bcf	STATUS, C
	rlf	SYSBYTETEMPA, F
	movf	SYSBYTETEMPB, F
	btfss	STATUS, Z
	goto	MUL8LOOP
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
	retlw	15
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


StringTable2
	retlw	16
	retlw	49	;1
	retlw	54	;6
	retlw	102	;f
	retlw	49	;1
	retlw	53	;5
	retlw	51	;3
	retlw	53	;5
	retlw	53	;5
	retlw	32	; 
	retlw	105	;i
	retlw	50	;2
	retlw	67	;C
	retlw	47	;/
	retlw	76	;L
	retlw	67	;C
	retlw	68	;D


StringTable3
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


StringTable4
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


StringTable5
	retlw	9
	retlw	67	;C
	retlw	117	;u
	retlw	114	;r
	retlw	115	;s
	retlw	111	;o
	retlw	114	;r
	retlw	32	; 
	retlw	79	;O
	retlw	78	;N


StringTable6
	retlw	10
	retlw	67	;C
	retlw	117	;u
	retlw	114	;r
	retlw	115	;s
	retlw	111	;o
	retlw	114	;r
	retlw	32	; 
	retlw	79	;O
	retlw	70	;F
	retlw	70	;F


StringTable7
	retlw	8
	retlw	70	;F
	retlw	76	;L
	retlw	65	;A
	retlw	83	;S
	retlw	72	;H
	retlw	32	; 
	retlw	79	;O
	retlw	78	;N


StringTable8
	retlw	9
	retlw	70	;F
	retlw	76	;L
	retlw	65	;A
	retlw	83	;S
	retlw	72	;H
	retlw	32	; 
	retlw	79	;O
	retlw	70	;F
	retlw	70	;F


StringTable9
	retlw	15
	retlw	67	;C
	retlw	85	;U
	retlw	82	;R
	retlw	83	;S
	retlw	82	;R
	retlw	32	; 
	retlw	38	;&
	retlw	32	; 
	retlw	70	;F
	retlw	76	;L
	retlw	83	;S
	retlw	72	;H
	retlw	32	; 
	retlw	79	;O
	retlw	78	;N


StringTable10
	retlw	16
	retlw	67	;C
	retlw	85	;U
	retlw	82	;R
	retlw	83	;S
	retlw	82	;R
	retlw	32	; 
	retlw	38	;&
	retlw	32	; 
	retlw	70	;F
	retlw	76	;L
	retlw	83	;S
	retlw	72	;H
	retlw	32	; 
	retlw	79	;O
	retlw	70	;F
	retlw	70	;F


StringTable11
	retlw	8
	retlw	70	;F
	retlw	108	;l
	retlw	97	;a
	retlw	115	;s
	retlw	104	;h
	retlw	105	;i
	retlw	110	;n
	retlw	103	;g


StringTable12
	retlw	7
	retlw	68	;D
	retlw	105	;i
	retlw	115	;s
	retlw	112	;p
	retlw	108	;l
	retlw	97	;a
	retlw	121	;y


StringTable13
	retlw	16
	retlw	68	;D
	retlw	73	;I
	retlw	83	;S
	retlw	80	;P
	retlw	76	;L
	retlw	65	;A
	retlw	89	;Y
	retlw	32	; 
	retlw	38	;&
	retlw	32	; 
	retlw	66	;B
	retlw	65	;A
	retlw	67	;C
	retlw	75	;K
	retlw	76	;L
	retlw	46	;.


StringTable14
	retlw	9
	retlw	70	;F
	retlw	79	;O
	retlw	82	;R
	retlw	32	; 
	retlw	53	;5
	retlw	32	; 
	retlw	83	;S
	retlw	69	;E
	retlw	67	;C


StringTable15
	retlw	8
	retlw	69	;E
	retlw	78	;N
	retlw	68	;D
	retlw	32	; 
	retlw	84	;T
	retlw	69	;E
	retlw	83	;S
	retlw	84	;T


;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
