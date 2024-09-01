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

	JSR		L_1Hz_Flash_Prog	;;闪烁
L_End_2Hz_Prog:
	RTS
;========================================================

L_1Hz_Prog:	
	JSR		F_Update_Time_Prog
	JSR		F_Update_STW_Prog	;;更新计时
	JSR		L_Nokey_Save		;;10S无操作保存退出设置
	JSR		L_STWKey_Exit		;;计时模式30S无操作退出
	JSR		L_Display_Mode0Prog
	JSR		F_StwBeepControl

L_1Hz_Prog_End:
	RTS

; ;======================================================
; ;============================================================
;;设置过程中无操作10S，自动保存当前值，并退出设置模式
L_Nokey_Save:
	LDA		R_No_Key
	CMP		#10
	BCC		L_Inc_Nokey_Time
	LDA		#0
	STA		R_Set_Flag
	STA		R_No_Key
	RTS
L_Inc_Nokey_Time:
	LDA		R_No_Key
	INC
	STA		R_No_Key
	RTS	
;===============================================================
;==============================================================
;;计时结束后30秒内无操作退出到时间界面
L_STWKey_Exit:
	BBR0	Sys_Flag_B,?RTS
	BBS1	Sys_Flag_B,?RTS
	LDA		R_STW_Key
	CMP		#30
	BCC		L_Inc_STWKey_Time
	LDA		#0
	STA		R_Set_Flag
	STA		R_STW_Key
	RMB0	Sys_Flag_B
	RTS

?RTS:
	RTS
L_Inc_STWKey_Time:
	LDA		R_STW_Key
	INC
	STA		R_STW_Key
	RTS
;===============================================================
F_StwBeepControl:	
	; LDA		R_Stw_Flag
	; ORA		R_Stw_Flag+1
	; AND		#BIT7
	; BEQ		F_StwBeepControl_End

	lda		R_Beep_Time
	BEQ     F_StwBeepControl_End
	DEC     R_Beep_Time
    BEQ     F_StwBeepControl_End

	LDA		#9
	STA		R_Voice_Unit
	;ST_EN
	EN_LCD_IRQ
F_StwBeepControl_End:
	RTS
;========
Stop_Stw_Beep:
	LDA		#0
	STA		R_Voice_Unit
	STA		R_Beep_Time
	RTS

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

