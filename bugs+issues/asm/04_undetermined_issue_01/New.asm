;Program compiled by Great Cow BASIC (0.98.06 RC01 2019-04-20 (Windows 32 bit))
;Need help? See the GCBASIC forums at http://sourceforge.net/projects/gcbasic/forums,
;check the documentation or email w_cholmondeley at users dot sourceforge dot net.

;********************************************************************************

;Set up the assembler options (Chip type, clock source, other bits and pieces)
 LIST p=16F18446, r=DEC
#include <P16F18446.inc>
 __CONFIG _CONFIG1, _CLKOUTEN_OFF & _RSTOSC_HFINT32 & _FEXTOSC_OFF
 __CONFIG _CONFIG2, _MCLRE_OFF
 __CONFIG _CONFIG3, _WDTE_OFF
 __CONFIG _CONFIG4, _LVP_OFF & _WRTD_OFF
 __CONFIG _CONFIG5, _CP_OFF

;********************************************************************************

;Set aside memory locations for variables
EEADR	EQU	32
EEDATAVALUE	EQU	33
SOMEVAR	EQU	34
TABLELOC	EQU	35

;********************************************************************************

;Alias variables
EEADDRESS	EQU	32

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
;Must use ReadTable and a variable for the index, or the table won't be
;downloaded to EEPROM
;TableLoc = 2
	movlw	2
	movwf	TABLELOC
;ReadTable TestDataSource, TableLoc, SomeVar
	movlw	low(TableTESTDATASOURCE)
	addwf	TABLELOC,W
	movwf	EEAddress
	call	SysEPRead
	movf	EEDataValue,W
	movwf	SOMEVAR
;Table of values to write to EEPROM
;EEPROM location 0 will store length of table
;Subsequent locations will each store a value
BASPROGRAMEND
	sleep
	goto	BASPROGRAMEND

;********************************************************************************

INITSYS
;Set up internal oscillator
;Handle OSCCON1 register for parts that have this register
;asm showdebug OSCCON type is 100 'This is the routine to support OSCCON1 config addresss
;osccon type is 100
;OSCCON1 = 0x60 ' NOSC HFINTOSC; NDIV 1 - Common as this simply sets the HFINTOSC
	movlw	96
	banksel	OSCCON1
	movwf	OSCCON1
;OSCCON3 = 0x00 ' CSWHOLD may proceed; SOSCPWR Low power
	clrf	OSCCON3
;OSCEN = 0x00   ' MFOEN disabled; LFOEN disabled; ADOEN disabled; SOSCEN disabled; EXTOEN disabled; HFOEN disabled
	clrf	OSCEN
;OSCTUNE = 0x00 ' HFTUN 0
	clrf	OSCTUNE
;asm showdebug The MCU is a chip family ChipFamily
;the mcu is a chip family 15
;asm showdebug OSCCON type is 102
;osccon type is 102
;Set OSCFRQ values for MCUs with OSCSTAT... the 16F18855 MCU family
;OSCFRQ = 0b00000110
	movlw	6
	movwf	OSCFRQ
;Ensure all ports are set for digital I/O and, turn off A/D
;SET ADFM OFF
	banksel	ADCON0
	bcf	ADCON0,ADFM0
;Switch off A/D Var(ADCON0)
;SET ADCON0.ADON OFF
	bcf	ADCON0,ADON
;Commence clearing any ANSEL variants in the part
;ANSELA = 0
	banksel	ANSELA
	clrf	ANSELA
;ANSELB = 0
	clrf	ANSELB
;ANSELC = 0
	clrf	ANSELC
;End clearing any ANSEL variants in the part
;Set comparator register bits for many MCUs with register CM2CON0
;C2EN = 0
	banksel	CM2CON0
	bcf	CM2CON0,C2EN
;C1EN = 0
	bcf	CM1CON0,C1EN
;Turn off all ports
;PORTA = 0
	banksel	PORTA
	clrf	PORTA
;PORTB = 0
	clrf	PORTB
;PORTC = 0
	clrf	PORTC
	return

;********************************************************************************

SYSEPREAD
;Variable alias
;Dim EEAddress Alias EEADR
;Disable interrupt
;IntOff
;Select data memory
;Set CFGS OFF
	banksel	NVMCON1
	bcf	NVMCON1,NVMREGS
;Read
;SET RD ON
	bsf	NVMCON1,RD
;Restore interrupt
;IntOn
	banksel	STATUS
	return

;********************************************************************************

;Start of program memory page 1
	ORG	2048
;Start of program memory page 2
	ORG	4096
;Start of program memory page 3
	ORG	6144
;Start of program memory page 4
	ORG	8192
;Start of program memory page 5
	ORG	10240
;Start of program memory page 6
	ORG	12288
;Start of program memory page 7
	ORG	14336
;********************************************************************************

; Data Lookup Tables (data memory)
	ORG	0xF000
TableTESTDATASOURCE	equ	0
	de	59, 84, 104, 105, 115, 32, 105, 115, 32, 97, 32, 100, 101, 109, 111, 110, 115, 116, 114, 97, 116, 105, 111, 110, 32, 111, 102, 32, 119, 114, 105, 116, 105, 110, 103, 32, 116, 111, 32, 69, 69, 80, 114, 111, 109, 32, 119, 105, 116, 104, 32, 97, 32, 115, 116, 114, 105, 110, 103, 33

 END
