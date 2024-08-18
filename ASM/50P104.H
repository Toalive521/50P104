;***********************************************************************
	.PAGE0
	.ORG	00H
	
P_PA		EQU		01H		;Default: 1111 11--B
PA			EQU		01H	
P_PA_WAKE	EQU		02H		;Default: 0000 00--B
P_PAWAKE	EQU		02H
P_PA_IO		EQU		04H		;Default: 1111 11--B
PAIO		EQU		04H
P_PADIR		EQU		04H
PADIR		EQU		04H
P_PA_DIR	EQU		04H

P_PB		EQU		05H		;Default: ----00---B
P_PB_TYPE	EQU		06H		;Default: ----11---B, CMOS output
P_PBTYPE	EQU		06H

P_PC		EQU		07H		;Default: 1111 1111B, Pull High
PC			EQU		07H
P_PC_IO		EQU		08H		;Default: 1111 1111B, Input
P_PC_DIR	EQU		P_PC_IO
P_PCDIR		EQU		08H
PCDIR		EQU		08H	

P_PCSEG		EQU		09H		;Default: --00 ----B, PC76,PC54

P_PD		EQU		0AH
P_PDDIR		EQU		0BH

P_PADF0		EQU		0CH		;Default: ---- --0-B, PB3S

P_PADF1		EQU		0DH

P_IER		EQU		0EH		;Default: -0-0 -000B
P_IFR		EQU		0FH		;Default: -0-0 -000B
bDIVF	    EQU	   0
bTMR0F      EQU	   1
bTMR1F      EQU	   2
bTMR2F      EQU	   3
bPAF        EQU	   4
bLCDF       EQU	   6

P_TMR0		EQU		10H		;Default: xxH
P_TMR1H		EQU		12H		;Default: xxH
P_TMR1		EQU		P_TMR1H	
P_TMR2		EQU		14H
	
P_TMRCTRL	EQU		16H		;Default: 0--0 --00B
bTMR0ON    	EQU	   0
bTMR1ON    	EQU	   1
bLCDON	   	EQU	   4
bAUDON	   	EQU	   7
P_TMRC		EQU		16H	

P_TMRCLK	EQU		17H		;Default: ---- xx--B
P_TMCLK		EQU		17H

P_DIVC		EQU		18H		;Default: ---0 xx--B

P_LCDCTRL	EQU		19H		;default: 0--- --11B
LCDCTRL		EQU		19H

P_LCD_COM	EQU		1AH		;Default: 0--- --xxB
P_LCDCOM	EQU		1AH

P_WDTC		EQU		1CH

P_SYSCLK	EQU		1DH		;Default: 0--- -101B, Fcpu=Fsys,Fosc ON,Fext OFF,SubClk strong start

P_HALT		EQU		1EH

P_AUD		EQU		1FH		;Default: xxxx xxxxB
P_AUD0		EQU		1FH

P_AUD_CTL	EQU		20H		;Default: ---- -x--B
P_AUDCR		EQU		P_AUD_CTL

P_MF0		EQU		2FH
P_LVC		EQU		3DH
P_FUSE0		EQU		3EH
P_FUSE1		EQU		4EH
P_PDSEG		EQU		5CH
P_RFCC0		EQU		5DH
P_RFCC1		EQU		5EH
P_MF1		EQU		5FH
	.ENDS
