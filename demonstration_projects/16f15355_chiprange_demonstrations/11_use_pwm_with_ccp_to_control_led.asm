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
BRIGHT	EQU	32
CCPCONCACHE	EQU	33
DELAYTEMP	EQU	112
DELAYTEMP2	EQU	113
PR4	EQU	34
PR6	EQU	35
PRX_TEMP	EQU	36
PRX_TEMP_E	EQU	39
PRX_TEMP_H	EQU	37
PRX_TEMP_U	EQU	38
PWMCHANNEL	EQU	40
PWMDUTY	EQU	41
PWMDUTY_H	EQU	42
PWMFREQ	EQU	43
PWMRESOLUTION	EQU	44
PWMRESOLUTION_H	EQU	45
SYSBITVAR0	EQU	46
SYSBYTETEMPX	EQU	112
SYSDIVLOOP	EQU	116
SYSLONGDIVMULTA	EQU	47
SYSLONGDIVMULTA_E	EQU	50
SYSLONGDIVMULTA_H	EQU	48
SYSLONGDIVMULTA_U	EQU	49
SYSLONGDIVMULTB	EQU	51
SYSLONGDIVMULTB_E	EQU	54
SYSLONGDIVMULTB_H	EQU	52
SYSLONGDIVMULTB_U	EQU	53
SYSLONGDIVMULTX	EQU	55
SYSLONGDIVMULTX_E	EQU	58
SYSLONGDIVMULTX_H	EQU	56
SYSLONGDIVMULTX_U	EQU	57
SYSLONGTEMPA	EQU	117
SYSLONGTEMPA_E	EQU	120
SYSLONGTEMPA_H	EQU	118
SYSLONGTEMPA_U	EQU	119
SYSLONGTEMPB	EQU	121
SYSLONGTEMPB_E	EQU	124
SYSLONGTEMPB_H	EQU	122
SYSLONGTEMPB_U	EQU	123
SYSLONGTEMPX	EQU	112
SYSLONGTEMPX_E	EQU	115
SYSLONGTEMPX_H	EQU	113
SYSLONGTEMPX_U	EQU	114
SYSREPEATTEMP1	EQU	59
SYSTEMP1	EQU	60
SYSTEMP1_E	EQU	63
SYSTEMP1_H	EQU	61
SYSTEMP1_U	EQU	62
SYSWAITTEMPMS	EQU	114
SYSWAITTEMPMS_H	EQU	115
TIMERSELECTIONBITS	EQU	64
TX_PR	EQU	65
_PWMTIMERSELECTED	EQU	66

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
	call	INITPWM

;Start of the main program
	bcf	TRISC,0
SysDoLoop_S1
	movlw	255
	movwf	BRIGHT
SysForLoop1
	incf	BRIGHT,F
	movlw	1
	movwf	PWMCHANNEL
	movlw	40
	movwf	PWMFREQ
	movf	BRIGHT,W
	movwf	PWMDUTY
	clrf	PWMDUTY_H
	call	HPWM23
	movf	PWMDUTY,W
	movwf	BRIGHT
	movlw	25
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movlw	255
	subwf	BRIGHT,W
	btfss	STATUS, C
	goto	SysForLoop1
SysForLoopEnd1
	clrf	BRIGHT
SysForLoop2
	decf	BRIGHT,F
	movlw	1
	movwf	PWMCHANNEL
	movlw	40
	movwf	PWMFREQ
	movf	BRIGHT,W
	movwf	PWMDUTY
	clrf	PWMDUTY_H
	call	HPWM23
	movf	PWMDUTY,W
	movwf	BRIGHT
	movlw	25
	movwf	SysWaitTempMS
	clrf	SysWaitTempMS_H
	call	Delay_MS
	movf	BRIGHT,W
	sublw	0
	btfss	STATUS, C
	goto	SysForLoop2
SysForLoopEnd2
	goto	SysDoLoop_S1
SysDoLoop_E1
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

;********************************************************************************

CALCULATEDUTY
	movlw	1
	addwf	PRX_TEMP,W
	movwf	SysTemp1
	movlw	0
	addwfc	PRX_TEMP_H,W
	movwf	SysTemp1_H
	movlw	0
	addwfc	PRX_TEMP_U,W
	movwf	SysTemp1_U
	movlw	0
	addwfc	PRX_TEMP_E,W
	movwf	SysTemp1_E
	movf	PWMDUTY,W
	movwf	SysLONGTempA
	movf	PWMDUTY_H,W
	movwf	SysLONGTempA_H
	clrf	SysLONGTempA_U
	clrf	SysLONGTempA_E
	movf	SysTemp1,W
	movwf	SysLONGTempB
	movf	SysTemp1_H,W
	movwf	SysLONGTempB_H
	movf	SysTemp1_U,W
	movwf	SysLONGTempB_U
	movf	SysTemp1_E,W
	movwf	SysLONGTempB_E
	call	SysMultSub32
	movf	SysLONGTempX,W
	movwf	PRX_TEMP
	movf	SysLONGTempX_H,W
	movwf	PRX_TEMP_H
	movf	SysLONGTempX_U,W
	movwf	PRX_TEMP_U
	movf	SysLONGTempX_E,W
	movwf	PRX_TEMP_E
	bcf	STATUS,C
	movlw	2
	movwf	SysRepeatTemp1
SysRepeatLoop1
	rlf	PRX_TEMP,F
	rlf	PRX_TEMP_H,F
	rlf	PRX_TEMP_U,F
	rlf	PRX_TEMP_E,F
	decfsz	SysRepeatTemp1,F
	goto	SysRepeatLoop1
SysRepeatLoopEnd1
	movf	PRX_TEMP,W
	movwf	SysLONGTempA
	movf	PRX_TEMP_H,W
	movwf	SysLONGTempA_H
	movf	PRX_TEMP_U,W
	movwf	SysLONGTempA_U
	movf	PRX_TEMP_E,W
	movwf	SysLONGTempA_E
	movf	PWMRESOLUTION,W
	movwf	SysLONGTempB
	movf	PWMRESOLUTION_H,W
	movwf	SysLONGTempB_H
	clrf	SysLONGTempB_U
	clrf	SysLONGTempB_E
	call	SysDivSub32
	movf	SysLONGTempA,W
	movwf	PRX_TEMP
	movf	SysLONGTempA_H,W
	movwf	PRX_TEMP_H
	movf	SysLONGTempA_U,W
	movwf	PRX_TEMP_U
	movf	SysLONGTempA_E,W
	movwf	PRX_TEMP_E
	bcf	STATUS,C
	movlw	6
	movwf	SysRepeatTemp1
SysRepeatLoop2
	rlf	PRX_TEMP,F
	rlf	PRX_TEMP_H,F
	rlf	PRX_TEMP_U,F
	rlf	PRX_TEMP_E,F
	decfsz	SysRepeatTemp1,F
	goto	SysRepeatLoop2
SysRepeatLoopEnd2
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

;Overloaded signature: BYTE:BYTE:BYTE:
HPWM23
	movlw	255
	movwf	PWMRESOLUTION
	clrf	PWMRESOLUTION_H
	movlw	1
	movwf	TX_PR
	movlw	64
	movwf	SysLONGTempA
	movlw	31
	movwf	SysLONGTempA_H
	clrf	SysLONGTempA_U
	clrf	SysLONGTempA_E
	movf	PWMFREQ,W
	movwf	SysLONGTempB
	clrf	SysLONGTempB_H
	clrf	SysLONGTempB_U
	clrf	SysLONGTempB_E
	call	SysDivSub32
	movf	SysLONGTempA,W
	movwf	PRX_TEMP
	movf	SysLONGTempA_H,W
	movwf	PRX_TEMP_H
	movf	SysLONGTempA_U,W
	movwf	PRX_TEMP_U
	movf	SysLONGTempA_E,W
	movwf	PRX_TEMP_E
	movf	PRX_TEMP_H,W
	sublw	0
	btfsc	STATUS, C
	goto	ENDIF6
	movlw	4
	movwf	TX_PR
	bcf	STATUS,C
	rrf	PRX_TEMP_E,F
	rrf	PRX_TEMP_U,F
	rrf	PRX_TEMP_H,F
	rrf	PRX_TEMP,F
	bcf	STATUS,C
	rrf	PRX_TEMP_E,F
	rrf	PRX_TEMP_U,F
	rrf	PRX_TEMP_H,F
	rrf	PRX_TEMP,F
ENDIF6
	movf	PRX_TEMP_H,W
	sublw	0
	btfsc	STATUS, C
	goto	ENDIF7
	movlw	16
	movwf	TX_PR
	bcf	STATUS,C
	rrf	PRX_TEMP_E,F
	rrf	PRX_TEMP_U,F
	rrf	PRX_TEMP_H,F
	rrf	PRX_TEMP,F
	bcf	STATUS,C
	rrf	PRX_TEMP_E,F
	rrf	PRX_TEMP_U,F
	rrf	PRX_TEMP_H,F
	rrf	PRX_TEMP,F
ENDIF7
	movf	PRX_TEMP_H,W
	sublw	0
	btfsc	STATUS, C
	goto	ENDIF8
	movlw	64
	movwf	TX_PR
	bcf	STATUS,C
	rrf	PRX_TEMP_E,F
	rrf	PRX_TEMP_U,F
	rrf	PRX_TEMP_H,F
	rrf	PRX_TEMP,F
	bcf	STATUS,C
	rrf	PRX_TEMP_E,F
	rrf	PRX_TEMP_U,F
	rrf	PRX_TEMP_H,F
	rrf	PRX_TEMP,F
ENDIF8
CCPPWMSETUPCLOCKSOURCE
SysSelect1Case1
	movlw	2
	subwf	_PWMTIMERSELECTED,W
	btfss	STATUS, Z
	goto	SysSelect1Case2
	movf	PRX_TEMP,W
	banksel	PR2
	movwf	PR2
	bcf	T2CON,T2CKPS0
	bcf	T2CON,T2CKPS1
	bcf	T2CON,T2CKPS2
	movlw	4
	banksel	TX_PR
	subwf	TX_PR,W
	btfss	STATUS, Z
	goto	ENDIF9
	banksel	T2CON
	bsf	T2CON,T2CKPS1
ENDIF9
	movlw	16
	banksel	TX_PR
	subwf	TX_PR,W
	btfss	STATUS, Z
	goto	ENDIF10
	banksel	T2CON
	bsf	T2CON,T2CKPS2
ENDIF10
	movlw	64
	banksel	TX_PR
	subwf	TX_PR,W
	btfss	STATUS, Z
	goto	ENDIF11
	banksel	T2CON
	bsf	T2CON,T2CKPS2
	bsf	T2CON,T2CKPS1
ENDIF11
	banksel	T2CLKCON
	bsf	T2CLKCON,T2CS0
	bcf	T2CLKCON,T2CS1
	bcf	T2CLKCON,T2CS2
	bcf	T2CLKCON,T2CS3
	goto	SysSelectEnd1
SysSelect1Case2
	movlw	4
	subwf	_PWMTIMERSELECTED,W
	btfss	STATUS, Z
	goto	SysSelect1Case3
	movf	PRX_TEMP,W
	movwf	PR4
	goto	SysSelectEnd1
SysSelect1Case3
	movlw	6
	subwf	_PWMTIMERSELECTED,W
	btfss	STATUS, Z
	goto	SysSelectEnd1
	movf	PRX_TEMP,W
	movwf	PR6
SysSelectEnd1
END_OF_CCPPWMSETUPCLOCKSOURCE
SETUPTHECORRECTTIMERBITS
	bcf	STATUS,C
	banksel	_PWMTIMERSELECTED
	rrf	_PWMTIMERSELECTED,W
	movwf	SysTemp1
	decf	SysTemp1,W
	movwf	TIMERSELECTIONBITS
SETUPCCPPWMREGISTERS
	decf	PWMCHANNEL,W
	btfss	STATUS, Z
	goto	ENDIF12
	call	CALCULATEDUTY
	movf	PRX_TEMP_H,W
	banksel	CCPR1H
	movwf	CCPR1H
	banksel	PRX_TEMP
	movf	PRX_TEMP,W
	banksel	CCPR1L
	movwf	CCPR1L
	bsf	CCP1CON,CCP1MODE3
	bsf	CCP1CON,CCP1MODE2
	bsf	CCP1CON,CCP1MODE1
	bsf	CCP1CON,CCP1MODE0
	bsf	CCP1CON,CCP1EN
	bsf	CCP1CON,CCP1FMT
ENDIF12
	banksel	STATUS
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
	movlw	9
	banksel	RC0PPS
	movwf	RC0PPS
	movlw	21
	banksel	RX1DTPPS
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

INITPWM
	movlw	2
	movwf	_PWMTIMERSELECTED
LEGACY_STARTOFFIXEDCCPPWMMODECODE
	clrf	CCPCONCACHE
	movlw	210
	banksel	PR2
	movwf	PR2
	bcf	T2CON,T2CKPS0
	bcf	T2CON,T2CKPS1
	bcf	T2CON,T2CKPS2
	banksel	CCPCONCACHE
	bsf	CCPCONCACHE,CCP1FMT
	movlw	105
	banksel	CCPR1H
	movwf	CCPR1H
	movlw	128
	movwf	CCPR1L
	movlw	1
	banksel	T2CLKCON
	movwf	T2CLKCON
	banksel	CCPCONCACHE
	bsf	CCPCONCACHE,EN
	bsf	CCPCONCACHE,CCP1MODE3
	bsf	CCPCONCACHE,CCP1MODE2
	bcf	CCPCONCACHE,CCP1MODE1
	bcf	CCPCONCACHE,CCP1MODE0
	banksel	T2CON
	bsf	T2CON,TMR2ON
STARTOFFIXEDPWMMODECODE
SETPWMDUTYCODE
REV2018_ENDOFFIXEDPWMMODECODE
	banksel	STATUS
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

SYSCOMPEQUAL32
	clrf	SYSBYTETEMPX
	movf	SYSLONGTEMPA, W
	subwf	SYSLONGTEMPB, W
	btfss	STATUS, Z
	return
	movf	SYSLONGTEMPA_H, W
	subwf	SYSLONGTEMPB_H, W
	btfss	STATUS, Z
	return
	movf	SYSLONGTEMPA_U, W
	subwf	SYSLONGTEMPB_U, W
	btfss	STATUS, Z
	return
	movf	SYSLONGTEMPA_E, W
	subwf	SYSLONGTEMPB_E, W
	btfss	STATUS, Z
	return
	comf	SYSBYTETEMPX,F
	return

;********************************************************************************

SYSCOMPLESSTHAN32
	clrf	SYSBYTETEMPX
	movf	SYSLONGTEMPA_E,W
	subwf	SYSLONGTEMPB_E,W
	btfss	STATUS,C
	return
	btfss	STATUS,Z
	goto	SCLT32TRUE
	movf	SYSLONGTEMPA_U,W
	subwf	SYSLONGTEMPB_U,W
	btfss	STATUS,C
	return
	btfss	STATUS,Z
	goto	SCLT32TRUE
	movf	SYSLONGTEMPA_H,W
	subwf	SYSLONGTEMPB_H,W
	btfss	STATUS,C
	return
	btfss	STATUS,Z
	goto	SCLT32TRUE
	movf	SYSLONGTEMPB,W
	subwf	SYSLONGTEMPA,W
	btfsc	STATUS,C
	return
SCLT32TRUE
	comf	SYSBYTETEMPX,F
	return

;********************************************************************************

SYSDIVSUB32
	movf	SYSLONGTEMPA,W
	movwf	SYSLONGDIVMULTA
	movf	SYSLONGTEMPA_H,W
	movwf	SYSLONGDIVMULTA_H
	movf	SYSLONGTEMPA_U,W
	movwf	SYSLONGDIVMULTA_U
	movf	SYSLONGTEMPA_E,W
	movwf	SYSLONGDIVMULTA_E
	movf	SYSLONGTEMPB,W
	movwf	SYSLONGDIVMULTB
	movf	SYSLONGTEMPB_H,W
	movwf	SYSLONGDIVMULTB_H
	movf	SYSLONGTEMPB_U,W
	movwf	SYSLONGDIVMULTB_U
	movf	SYSLONGTEMPB_E,W
	movwf	SYSLONGDIVMULTB_E
	clrf	SYSLONGDIVMULTX
	clrf	SYSLONGDIVMULTX_H
	clrf	SYSLONGDIVMULTX_U
	clrf	SYSLONGDIVMULTX_E
	movf	SYSLONGDIVMULTB,W
	movwf	SysLONGTempA
	movf	SYSLONGDIVMULTB_H,W
	movwf	SysLONGTempA_H
	movf	SYSLONGDIVMULTB_U,W
	movwf	SysLONGTempA_U
	movf	SYSLONGDIVMULTB_E,W
	movwf	SysLONGTempA_E
	clrf	SysLONGTempB
	clrf	SysLONGTempB_H
	clrf	SysLONGTempB_U
	clrf	SysLONGTempB_E
	call	SysCompEqual32
	btfss	SysByteTempX,0
	goto	ENDIF15
	clrf	SYSLONGTEMPA
	clrf	SYSLONGTEMPA_H
	clrf	SYSLONGTEMPA_U
	clrf	SYSLONGTEMPA_E
	return
ENDIF15
	movlw	32
	movwf	SYSDIVLOOP
SYSDIV32START
	bcf	STATUS,C
	rlf	SYSLONGDIVMULTA,F
	rlf	SYSLONGDIVMULTA_H,F
	rlf	SYSLONGDIVMULTA_U,F
	rlf	SYSLONGDIVMULTA_E,F
	rlf	SYSLONGDIVMULTX,F
	rlf	SYSLONGDIVMULTX_H,F
	rlf	SYSLONGDIVMULTX_U,F
	rlf	SYSLONGDIVMULTX_E,F
	movf	SYSLONGDIVMULTB,W
	subwf	SYSLONGDIVMULTX,F
	movf	SYSLONGDIVMULTB_H,W
	subwfb	SYSLONGDIVMULTX_H,F
	movf	SYSLONGDIVMULTB_U,W
	subwfb	SYSLONGDIVMULTX_U,F
	movf	SYSLONGDIVMULTB_E,W
	subwfb	SYSLONGDIVMULTX_E,F
	bsf	SYSLONGDIVMULTA,0
	btfsc	STATUS,C
	goto	ENDIF16
	bcf	SYSLONGDIVMULTA,0
	movf	SYSLONGDIVMULTB,W
	addwf	SYSLONGDIVMULTX,F
	movf	SYSLONGDIVMULTB_H,W
	addwfc	SYSLONGDIVMULTX_H,F
	movf	SYSLONGDIVMULTB_U,W
	addwfc	SYSLONGDIVMULTX_U,F
	movf	SYSLONGDIVMULTB_E,W
	addwfc	SYSLONGDIVMULTX_E,F
ENDIF16
	decfsz	SYSDIVLOOP, F
	goto	SYSDIV32START
	movf	SYSLONGDIVMULTA,W
	movwf	SYSLONGTEMPA
	movf	SYSLONGDIVMULTA_H,W
	movwf	SYSLONGTEMPA_H
	movf	SYSLONGDIVMULTA_U,W
	movwf	SYSLONGTEMPA_U
	movf	SYSLONGDIVMULTA_E,W
	movwf	SYSLONGTEMPA_E
	movf	SYSLONGDIVMULTX,W
	movwf	SYSLONGTEMPX
	movf	SYSLONGDIVMULTX_H,W
	movwf	SYSLONGTEMPX_H
	movf	SYSLONGDIVMULTX_U,W
	movwf	SYSLONGTEMPX_U
	movf	SYSLONGDIVMULTX_E,W
	movwf	SYSLONGTEMPX_E
	return

;********************************************************************************

SYSMULTSUB32
	movf	SYSLONGTEMPA,W
	movwf	SYSLONGDIVMULTA
	movf	SYSLONGTEMPA_H,W
	movwf	SYSLONGDIVMULTA_H
	movf	SYSLONGTEMPA_U,W
	movwf	SYSLONGDIVMULTA_U
	movf	SYSLONGTEMPA_E,W
	movwf	SYSLONGDIVMULTA_E
	movf	SYSLONGTEMPB,W
	movwf	SYSLONGDIVMULTB
	movf	SYSLONGTEMPB_H,W
	movwf	SYSLONGDIVMULTB_H
	movf	SYSLONGTEMPB_U,W
	movwf	SYSLONGDIVMULTB_U
	movf	SYSLONGTEMPB_E,W
	movwf	SYSLONGDIVMULTB_E
	clrf	SYSLONGDIVMULTX
	clrf	SYSLONGDIVMULTX_H
	clrf	SYSLONGDIVMULTX_U
	clrf	SYSLONGDIVMULTX_E
MUL32LOOP
	btfss	SYSLONGDIVMULTB,0
	goto	ENDIF13
	movf	SYSLONGDIVMULTA,W
	addwf	SYSLONGDIVMULTX,F
	movf	SYSLONGDIVMULTA_H,W
	addwfc	SYSLONGDIVMULTX_H,F
	movf	SYSLONGDIVMULTA_U,W
	addwfc	SYSLONGDIVMULTX_U,F
	movf	SYSLONGDIVMULTA_E,W
	addwfc	SYSLONGDIVMULTX_E,F
ENDIF13
	bcf	STATUS,C
	rrf	SYSLONGDIVMULTB_E,F
	rrf	SYSLONGDIVMULTB_U,F
	rrf	SYSLONGDIVMULTB_H,F
	rrf	SYSLONGDIVMULTB,F
	bcf	STATUS,C
	rlf	SYSLONGDIVMULTA,F
	rlf	SYSLONGDIVMULTA_H,F
	rlf	SYSLONGDIVMULTA_U,F
	rlf	SYSLONGDIVMULTA_E,F
	movf	SYSLONGDIVMULTB,W
	movwf	SysLONGTempB
	movf	SYSLONGDIVMULTB_H,W
	movwf	SysLONGTempB_H
	movf	SYSLONGDIVMULTB_U,W
	movwf	SysLONGTempB_U
	movf	SYSLONGDIVMULTB_E,W
	movwf	SysLONGTempB_E
	clrf	SysLONGTempA
	clrf	SysLONGTempA_H
	clrf	SysLONGTempA_U
	clrf	SysLONGTempA_E
	call	SysCompLessThan32
	btfsc	SysByteTempX,0
	goto	MUL32LOOP
	movf	SYSLONGDIVMULTX,W
	movwf	SYSLONGTEMPX
	movf	SYSLONGDIVMULTX_H,W
	movwf	SYSLONGTEMPX_H
	movf	SYSLONGDIVMULTX_U,W
	movwf	SYSLONGTEMPX_U
	movf	SYSLONGDIVMULTX_E,W
	movwf	SYSLONGTEMPX_E
	return

;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144

 END
