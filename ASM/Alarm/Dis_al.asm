;==========================================
L_Dis_Al_Mode:
	LDX		#lcd_alarm
	JSR		F_DispSymbol
	JSR		F_DisCol

L_Dis_Al:	
	JSR		L_Dis_AlSec
	JSR		L_Dis_AlMin
	JSR		L_Dis_AlHr

;=====================================================
L_Dis_AlSec:
	LDA		R_Al_Sec
	JSR		L_Dis_Digit56
	rts
	
L_Dis_AlMin:
	LDA		R_Al_Min
	JSR		L_Dis_Digit34
	rts
	
L_Dis_AlHr:
	LDA		R_Al_Hr
	JSR		L_Dis_Hr
	rts
;===============================================
Judge_Alarm_Start:
	LDA		Sys_Flag_B
	AND		#BIT0
	BEQ		Judge_Alarm_Start_End
	JSR		F_DisT1
	RTS
Judge_Alarm_Start_End:
	JSR		F_ClrT1
	RTS
;================================================
Judge_Alarm_T1_Flash:
	lda		Sys_Flag_B
	AND		#BIT4
	BEQ		Judge_Alarm_T1_Flash_End

	LDA		Sys_Flag_A
	AND		#BIT1
	BNE		Flash_Alarm
Clr_Alarm:
	JSR		F_ClrT1
	BRA		Judge_Alarm_T1_Flash_End
Flash_Alarm:
	JSR		F_DisT1
Judge_Alarm_T1_Flash_End:
	RTS
;=========================================
Judge_Al_ZZ:
	lda		Sys_Flag_B
	AND		#BIT1
	BEQ		Judge_Al_ZZ_End	

	JSR		F_DisZZ
Judge_Al_ZZ_End:
	RTS