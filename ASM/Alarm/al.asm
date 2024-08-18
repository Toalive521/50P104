;======================================
L_CMP_Alarm_Prog:
	LDA		Sys_Flag_B
	AND		#BIT0
	BEQ		L_End_CMP_Alarm_Prog	;AL OFF
	


	LDA		R_Sec
	CMP		R_Al_Sec
	BNE		L_End_CMP_Alarm_Prog

	LDA		R_Min
	CMP		R_Al_Min
	BNE		L_End_CMP_Alarm_Prog
	
	LDA		R_Hr
	CMP		R_Al_Hr
	BNE		L_End_CMP_Alarm_Prog	;匹配时分秒
L_Alarm_Arrive:
	LDA		Sys_Flag_B
	AND		#BIT1_
	STA		Sys_Flag_B

	JSR		F_ClrZZ

	LDA		R_Beep_Time
	BEQ		L_JumpAlam

;	JSR		F_ClrAlarm
L_JumpAlam:	
	LDA		#0
	STA		R_Alarm_Mode

	LDA		Sys_Flag_B
	ORA		#BIT4
	STA		Sys_Flag_B

	LDA		#$31
	STA		R_Beep_Time	;响铃次数
L_End_CMP_Alarm_Prog:
	RTS

;================================================
L_ZZ_Dec_Prog:
	JSR		F_SecSplDec
	BCS		L_ZZ_Dec_Prog_End
	JSR		F_MinSplDec
	BCS		L_ZZ_Dec_Prog_End

	JSR		Judge_Alarm_ZZ
	BCS		L_Alarm_Arrive
L_ZZ_Dec_Prog_End:
	RTS


;================================================
Judge_F_AlarmBeepControl:		;判断闹铃
	LDA		Sys_Flag_B
	AND		#BIT0
	BNE		F_AlarmBeepControl
Judge_F_AlarmBeepControl_End:
	RTS

F_AlarmBeepControl:
	LDA		R_Beep_Time
	BEQ		L_End_AlarmBeepControl
	DEC		R_Beep_Time
	BEQ		L_CloseAlarmBeep

;	LDX		R_Alarm_Mode
;	LDA		#5
;	STA		R_Moto_Unit
	LDA		#7
	STA		R_Voice_Unit
	;ST_EN
	EN_LCD_IRQ
L_End_AlarmBeepControl:
	RTS

L_CloseAlarmBeep:
	JSR		Stop_Alarm_Beep
	RTS

Stop_Alarm_Beep:			;停止闹铃
	LDA		Sys_Flag_B
	AND		#BIT4_
	STA		Sys_Flag_B

	LDA		#0
	STA		R_Beep_Time
	STA		R_Voice_Unit
	RTS

;=================================================
Judge_Alarm_Spl:
	LDA		R_Sec
	STA		R_Al_Sec_Spl


	LDA		R_Min
	STA		R_Al_Min_Spl

	CLC
	SED

	LDA		R_Al_Min_Spl
	ADC		#10
	STA		R_Al_Min_Spl

	CLD
	LDA		R_Al_Min_Spl
	CMP		#60
	BCS		Change_AlHrInc

	

Judge_Alarm_Spl_End:
	RTS

Change_AlHrInc:
	STA		R_Al_Min_Spl
	RTS

;=======================================
Judge_Alarm_ZZ:
	LDA		Sys_Flag_B
	AND		#BIT1
	BEQ		Judge_Alarm_ZZ_End

	LDA		#0
	STA		R_Al_Sec_Spl
	LDA		#010h
	STA		R_Al_Min_Spl

	SEC
	RTS
Judge_Alarm_ZZ_End:
	CLC
	RTS
;=================================================
Judge_Al_ZZ_Runing:
	LDA		Sys_Flag_B
	AND		#(BIT1+BIT4)
	BEQ		Judge_Al_ZZ_Runing_End

	JSR		L_ZZ_Dec_Prog
	RTS

Judge_Al_ZZ_Runing_End:
	LDA		#0
	STA		R_Al_Sec_Spl
	LDA		#010h;#010h
	STA		R_Al_Min_Spl
	RTS