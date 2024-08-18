
;------------------------------------------------------
;L_Init_SystemRam_Prog:
;	LDA		#3
;	STA		R_Reset_1S
;	STA		R_Strong_2S
	
;	LDA		#$06
;	STA		R_Alarm1_Hr
;	LDA		#$12
;	STA		R_Alarm2_Hr
;	RTS
;------------------------------------------------------	
;------------------------------------------------------
;-----------------------------------------------------
;-----------------------------------------------------	
F_Delay30Ms_32KHz:
	LDA		#140		;2
	STA		R_Temp+5
?OOP_DELAY:
	DEC		R_Temp+5	;2*256
	LDA		R_Temp+5	;
	BNE		?OOP_DELAY	;3*256
	RTS		
;------------------------------------------------------
L_InitSPR_Prog:
	LDA		#00001100B
	STA		P_PAWAKE
	
	LDA		#00000100B
	STA		P_PADIR
	
	LDA		#0
	STA		P_PA	;PA56���0,������������
	
	PB2_PB2_CMOS
	PB3_PB3_CMOS
	WDTC_CLR
	PC03_PC03	
	PC45_PC45
	PC67_SEG
	PD03_SEG	
	PD47_SEG	
;	LDA		#$FF
;	STA		P_PB
	LDA		#0
	STA		P_PB
	STA		P_PC_IO
	STA		P_PC
	STA		P_PDDIR
	STA		P_PD
	LCD_4COM
	LCD_DRIVE_4
	LCD_ENCH_EN	
	LCD_1_2_BAIS_3V
	LCDS_2
	LDA		#0
	STA		P_PADF1
	STA		P_TMR0
	STA		P_TMR1
	STA		P_TMR2		
	STA		P_DIVC
	STA		P_IER
	STA		P_IFR
	STA		P_AUD0
	STA		P_AUDCR
;	LDA		#01111100B
;	STA		P_PA_WAKE
	DIV_512HZ
	TMR0_CLK_128K	
	TMR1_CLK_512Hz
	TMR2_CLK_512Hz
	WDTC_CLK_TMR1
	WDTC_OFF
	RTS
;------------------------------------------------------

