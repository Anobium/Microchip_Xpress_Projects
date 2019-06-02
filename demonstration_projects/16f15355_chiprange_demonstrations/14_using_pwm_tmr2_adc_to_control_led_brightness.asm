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
CCPCONCACHE	EQU	33
DELAYTEMP	EQU	112
FNLSL	EQU	34
FNLSL_E	EQU	37
FNLSL_H	EQU	35
FNLSL_U	EQU	36
NUMBITS	EQU	38
PRX_TEMP	EQU	39
PRX_TEMP_CACHE	EQU	43
PRX_TEMP_CACHE_E	EQU	46
PRX_TEMP_CACHE_H	EQU	44
PRX_TEMP_CACHE_U	EQU	45
PRX_TEMP_E	EQU	42
PRX_TEMP_H	EQU	40
PRX_TEMP_U	EQU	41
PWMCHANNEL	EQU	47
PWMDUTY	EQU	48
PWMDUTY_H	EQU	49
PWMFREQ	EQU	50
PWMFREQ_H	EQU	51
PWMRESOLUTION	EQU	52
PWMRESOLUTION_H	EQU	53
READAD10	EQU	54
READAD10_H	EQU	55
SYSBITVAR0	EQU	56
SYSBYTETEMPX	EQU	112
SYSDIVLOOP	EQU	116
SYSLONGDIVMULTA	EQU	57
SYSLONGDIVMULTA_E	EQU	60
SYSLONGDIVMULTA_H	EQU	58
SYSLONGDIVMULTA_U	EQU	59
SYSLONGDIVMULTB	EQU	61
SYSLONGDIVMULTB_E	EQU	64
SYSLONGDIVMULTB_H	EQU	62
SYSLONGDIVMULTB_U	EQU	63
SYSLONGDIVMULTX	EQU	65
SYSLONGDIVMULTX_E	EQU	68
SYSLONGDIVMULTX_H	EQU	66
SYSLONGDIVMULTX_U	EQU	67
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
SYSREPEATTEMP1	EQU	69
SYSREPEATTEMP3	EQU	70
SYSTEMP1	EQU	71
SYSTEMP1_E	EQU	74
SYSTEMP1_H	EQU	72
SYSTEMP1_U	EQU	73
SYSWAITTEMP10US	EQU	117
SYSWORDTEMPB	EQU	121
SYSWORDTEMPB_H	EQU	122
TX_PR	EQU	75
_PWMTIMERSELECTED	EQU	76

;********************************************************************************

;Alias variables
BRIGHT	EQU	908
BRIGHT_H	EQU	909
SYSFNLSLWORD	EQU	34
SYSFNLSLWORD_H	EQU	35
SYSREADAD10WORD	EQU	54
SYSREADAD10WORD_H	EQU	55

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
	bcf	TRISC,1
	bcf	TRISC,2
	bcf	TRISC,3
	bsf	TRISA,0
	movlw	6
	movwf	PWMCHANNEL
	movlw	62
	movwf	PWMFREQ
	clrf	PWMFREQ_H
	clrf	PWMDUTY
	clrf	PWMDUTY_H
	movlw	2
	movwf	_PWMTIMERSELECTED
	movlw	255
	movwf	PWMRESOLUTION
	clrf	PWMRESOLUTION_H
	call	HPWM24
SysDoLoop_S1
	banksel	ADREADPORT
	clrf	ADREADPORT
	call	FN_READAD105
	movf	SYSREADAD10WORD,W
	movwf	SYSWORDTEMPB
	movf	SYSREADAD10WORD_H,W
	movwf	SYSWORDTEMPB_H
	movlw	6
	movwf	NUMBITS
	call	FN_FNLSL86
	movf	SYSFNLSLWORD,W
	banksel	BRIGHT
	movwf	BRIGHT
	banksel	SYSFNLSLWORD_H
	movf	SYSFNLSLWORD_H,W
	banksel	BRIGHT_H
	movwf	BRIGHT_H
	goto	SysDoLoop_S1
SysDoLoop_E1
	goto	BASPROGRAMEND
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

;Overloaded signature: WORD:BYTE:
FN_FNLSL86
	movf	NUMBITS,W
	movwf	SysRepeatTemp3
	btfsc	STATUS,Z
	goto	SysRepeatLoopEnd3
SysRepeatLoop3
	bcf	STATUS,C
	rlf	SYSWORDTEMPB,F
	rlf	SYSWORDTEMPB_H,F
	decfsz	SysRepeatTemp3,F
	goto	SysRepeatLoop3
SysRepeatLoopEnd3
	movf	SYSWORDTEMPB,W
	movwf	FNLSL
	movf	SYSWORDTEMPB_H,W
	movwf	FNLSL_H
	return

;********************************************************************************

;Overloaded signature: BYTE:WORD:BYTE:BYTE:word:
HPWM24
	goto	HPWM25

;********************************************************************************

;Overloaded signature: BYTE:WORD:WORD:BYTE:word:
HPWM25
	movlw	64
	movwf	SysLONGTempA
	movlw	31
	movwf	SysLONGTempA_H
	clrf	SysLONGTempA_U
	clrf	SysLONGTempA_E
	movf	PWMFREQ,W
	movwf	SysLONGTempB
	movf	PWMFREQ_H,W
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
	movlw	1
	movwf	TX_PR
	movf	PRX_TEMP_H,W
	sublw	0
	btfsc	STATUS, C
	goto	ENDIF10
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
ENDIF10
	movf	PRX_TEMP_H,W
	sublw	0
	btfsc	STATUS, C
	goto	ENDIF11
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
ENDIF11
	movf	PRX_TEMP_H,W
	sublw	0
	btfsc	STATUS, C
	goto	ENDIF12
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
ENDIF12
SysSelect2Case1
	movlw	2
	subwf	_PWMTIMERSELECTED,W
	btfss	STATUS, Z
	goto	SysSelectEnd2
	movf	PRX_TEMP,W
	banksel	PR2
	movwf	PR2
	movlw	1
	movwf	T2CLKCON
	clrf	T2HLT
	clrf	T2RST
	clrf	T2TMR
	bcf	T2CON,T2CKPS0
	bcf	T2CON,T2CKPS1
	bcf	T2CON,T2CKPS2
	movlw	4
	banksel	TX_PR
	subwf	TX_PR,W
	btfss	STATUS, Z
	goto	ENDIF13
	banksel	T2CON
	bsf	T2CON,T2CKPS1
ENDIF13
	movlw	16
	banksel	TX_PR
	subwf	TX_PR,W
	btfss	STATUS, Z
	goto	ENDIF14
	banksel	T2CON
	bsf	T2CON,T2CKPS2
ENDIF14
	movlw	64
	banksel	TX_PR
	subwf	TX_PR,W
	btfss	STATUS, Z
	goto	ENDIF15
	banksel	T2CON
	bsf	T2CON,T2CKPS2
	bsf	T2CON,T2CKPS1
ENDIF15
	banksel	PIR4
	bcf	PIR4,TMR2IF
	banksel	T2CON
	bsf	T2CON,TMR2ON
SysSelectEnd2
TENBITPMWSECTION
	banksel	PRX_TEMP
	movf	PRX_TEMP,W
	movwf	PRX_TEMP_CACHE
	movf	PRX_TEMP_H,W
	movwf	PRX_TEMP_CACHE_H
	movf	PRX_TEMP_U,W
	movwf	PRX_TEMP_CACHE_U
	movf	PRX_TEMP_E,W
	movwf	PRX_TEMP_CACHE_E
	movlw	3
	subwf	PWMCHANNEL,W
	btfss	STATUS, Z
	goto	ENDIF16
	call	CALCULATEDUTY
	movf	PRX_TEMP_H,W
	banksel	PWM3DCH
	movwf	PWM3DCH
	banksel	PRX_TEMP
	movf	PRX_TEMP,W
	banksel	PWM3DCL
	movwf	PWM3DCL
	bsf	PWM3CON,PWM3EN
ENDIF16
	movlw	4
	banksel	PWMCHANNEL
	subwf	PWMCHANNEL,W
	btfss	STATUS, Z
	goto	ENDIF17
	call	CALCULATEDUTY
	movf	PRX_TEMP_H,W
	banksel	PWM4DCH
	movwf	PWM4DCH
	banksel	PRX_TEMP
	movf	PRX_TEMP,W
	banksel	PWM4DCL
	movwf	PWM4DCL
	bsf	PWM4CON,PWM4EN
ENDIF17
	movlw	5
	banksel	PWMCHANNEL
	subwf	PWMCHANNEL,W
	btfss	STATUS, Z
	goto	ENDIF18
	call	CALCULATEDUTY
	movf	PRX_TEMP_H,W
	banksel	PWM5DCH
	movwf	PWM5DCH
	banksel	PRX_TEMP
	movf	PRX_TEMP,W
	banksel	PWM5DCL
	movwf	PWM5DCL
	bsf	PWM5CON,PWM5EN
ENDIF18
	movlw	6
	banksel	PWMCHANNEL
	subwf	PWMCHANNEL,W
	btfss	STATUS, Z
	goto	ENDIF19
	call	CALCULATEDUTY
	movf	PRX_TEMP_H,W
	banksel	PWM6DCH
	movwf	PWM6DCH
	banksel	PRX_TEMP
	movf	PRX_TEMP,W
	banksel	PWM6DCL
	movwf	PWM6DCL
	bsf	PWM6CON,PWM6EN
ENDIF19
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
	movlw	14
	banksel	RC0PPS
	movwf	RC0PPS
	movlw	14
	movwf	RC3PPS
	movlw	14
	movwf	RC1PPS
	movlw	14
	movwf	RC2PPS
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

;Overloaded signature: BYTE:
FN_READAD105
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
	goto	ENDIF4
	banksel	ADCON0
	bsf	ADCON0,CHS0
ENDIF4
	banksel	ADREADPORT
	btfss	ADREADPORT,1
	goto	ENDIF5
	banksel	ADCON0
	bsf	ADCON0,CHS1
ENDIF5
	banksel	ADREADPORT
	btfss	ADREADPORT,2
	goto	ENDIF6
	banksel	ADCON0
	bsf	ADCON0,CHS2
ENDIF6
	banksel	ADREADPORT
	btfss	ADREADPORT,3
	goto	ENDIF7
	banksel	ADCON0
	bsf	ADCON0,CHS3
ENDIF7
	banksel	ADREADPORT
	btfss	ADREADPORT,4
	goto	ENDIF8
	banksel	ADCON0
	bsf	ADCON0,CHS4
ENDIF8
	banksel	ADREADPORT
	btfss	ADREADPORT,5
	goto	ENDIF9
	banksel	ADCON0
	bsf	ADCON0,CHS5
ENDIF9
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
	goto	ENDIF22
	clrf	SYSLONGTEMPA
	clrf	SYSLONGTEMPA_H
	clrf	SYSLONGTEMPA_U
	clrf	SYSLONGTEMPA_E
	return
ENDIF22
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
	goto	ENDIF23
	bcf	SYSLONGDIVMULTA,0
	movf	SYSLONGDIVMULTB,W
	addwf	SYSLONGDIVMULTX,F
	movf	SYSLONGDIVMULTB_H,W
	addwfc	SYSLONGDIVMULTX_H,F
	movf	SYSLONGDIVMULTB_U,W
	addwfc	SYSLONGDIVMULTX_U,F
	movf	SYSLONGDIVMULTB_E,W
	addwfc	SYSLONGDIVMULTX_E,F
ENDIF23
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
	goto	ENDIF20
	movf	SYSLONGDIVMULTA,W
	addwf	SYSLONGDIVMULTX,F
	movf	SYSLONGDIVMULTA_H,W
	addwfc	SYSLONGDIVMULTX_H,F
	movf	SYSLONGDIVMULTA_U,W
	addwfc	SYSLONGDIVMULTX_U,F
	movf	SYSLONGDIVMULTA_E,W
	addwfc	SYSLONGDIVMULTX_E,F
ENDIF20
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
