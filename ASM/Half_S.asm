;=======================================================
L_2Hz_Prog:
	LDA		Sys_Flag_A
	AND		#BIT0	
	BEQ		L_End_2Hz_Prog
	

	LDA		Sys_Flag_A
	AND		#~BIT0		;清半秒标志	
	EOR		#BIT1
	STA		Sys_Flag_A

	;JSR		Judge_Alarm_T1_Flash
	;JSR		Judge_Stw_TimeKeeping
	;JSR		Judge_Stw_Forward
	
	LDA		Sys_Flag_A
	AND		#BIT1
	BEQ		L_1Hz_Prog

	JSR		L_1Hz_Flash_Prog
L_End_2Hz_Prog:
	RTS
;========================================================

L_1Hz_Prog:	
	JSR		F_Update_Time_Prog
	JSR		L_Nokey_Save		;;10S无操作保存退出设置
	JSR		L_Display_Mode0Prog

L_1Hz_Prog_End:
	RTS

; ;======================================================
; L_1Hz_Prog_Num:
; 	JSR		F_Update_Time_Prog
	
; 	JSR		Judge_F_AlarmBeepControl	;闹钟声音
; 	JSR		F_StwBeepControl

; 	JSR		L_Mode_Prog
; L_Skip_Update_Time_Prog:	
; 	RTS
; ;========================================================

; Judge_Lock_Num:
; 	LDA		R_Mode
; 	CMP		#D_Time_Mode
; 	BNE		Judge_Lock_Num_End

; 	LDA		Sys_Flag_A
; 	AND		#BIT6
; 	BNE		Judge_Lock_Num_End

; 	LDA		R_Num
; 	DEC
; 	STA		R_Num
; 	BNE		Judge_Lock_Num_End		

; 	LDA		Sys_Flag_A
; 	ORA		#BIT6	
; 	STA		Sys_Flag_A
; Judge_Lock_Num_End:
; 	RTS

