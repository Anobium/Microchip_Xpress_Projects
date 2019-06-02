;Program compiled by Great Cow BASIC (0.98.<<>> 2019-05-14 (Windows 32 bit))
;Need help? See the GCBASIC forums at http://sourceforge.net/projects/gcbasic/forums,
;check the documentation or email w_cholmondeley at users dot sourceforge dot net.

;********************************************************************************

;Set up the assembler options (Chip type, clock source, other bits and pieces)
 LIST p=10F200, r=DEC
#include <P10F200.inc>
 errorlevel -302
 __CONFIG _MCLRE_OFF & _CP_OFF & _WDTE_OFF & _OSC_INTRC

;********************************************************************************

;Set aside memory locations for variables
OPTION_REG  EQU 16

;********************************************************************************

;Vectors
;Start of program memory page 0
  ORG 0
;Indirect jumps to allow calls to second half of page
  goto  BASPROGRAMSTART
INITSYS
  goto  SysInd_INITSYS

BASPROGRAMSTART
;Call initialisation routines
  call  INITSYS

;Start of the main program
BASPROGRAMEND
  sleep
  goto  BASPROGRAMEND

;********************************************************************************

SysInd_INITSYS
  movwf OSCCAL
  movlw 199
  option
  movlw 199
  movwf OPTION_REG
  clrf  GPIO
  retlw 0

;********************************************************************************


 END
