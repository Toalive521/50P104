;;============================================
L_Key6_Number:		;6号键 模式
	LDA		R_Key_Flag
	AND		#BIT6
	BNE		L_HoldKey6_Number

	JSR		Judge_Key6_Beep

	LDA		R_Key_Flag
	ORA		#BIT6
	STA		R_Key_Flag

	JSR		F_ClearScreen
	LDA		P_Temp+6
	INC
	STA		P_Temp+6

	LDA		P_Temp+6
	CMP		#4
	BEQ		STZ_PTEMP6
	RTS
STZ_PTEMP6:
	LDA		#0
	STA		P_Temp+6
	RTS


	JSR		Change_Mode			;一个 待补充功能
								
	JSR		L_Mode_Prog	
L_HoldKey6_Number:

L_Key6_Number_End:
	RTS
;============================================================
Change_Mode:;6号键
	LDA		Sys_Flag_A
	AND		#BIT5_
	STA		Sys_Flag_A

	LDA		Sys_Flag_A
	AND		#BIT6_
	STA		Sys_Flag_A
	LDA		#15
	STA		R_Num

	LDA		R_Mode
	INC
	STA		R_Mode
	lda		R_Mode
	cmp		#03h
	BEQ		Stz_Mode	
	jsr		F_ClearScreen
	JSR		L_Mode_Prog
	rts		
Stz_Mode:
	LDA		#0
	STA		R_Mode
	jsr		F_ClearScreen
	JSR		L_Mode_Prog
	rts
;;============================================
L_Key5_Number:		;5号键 清除
	JSR		Judge_Key5_Beep

	LDA		R_Key_Flag
	AND		#BIT6
	BNE		L_HoldKey5_Number

	LDA		R_Key_Flag
	ORA		#BIT6
	STA		R_Key_Flag

	JSR		F_ClearScreen
	LDA		P_Temp+7
	INC
	STA		P_Temp+7

	LDA		P_Temp+7
	CMP		#13
	BEQ		STZ_PTEMP7
	RTS
STZ_PTEMP7:
	LDA		#0
	STA		P_Temp+7
	RTS

L_Key5_Number_Run:
	lda		R_Mode
	CMP		#D_Al_Mode
	BEQ		To_Stz_Al_HMS

	CMP		#D_Time_Mode
	BEQ		To_Change_voice

	CMP		#D_Stw_Mode
	BEQ		Stz_Stw_HMS

L_HoldKey5_Number:
	JSR		L_HoldKey
L_Key5_Number_End:
	RTS

To_Change_voice:
	JMP		Change_voice
To_Stz_Al_HMS:
	JMP		Stz_Al_HMS
;====================================================
Stz_Stw_HMS:				;重置秒表
	LDA		R_Stw_Mode
	BNE		Stz_Stw2_HMS

	LDX		#0
	STX		P_Temp+4
	BRA		Stz_Stw_HMS_Run

Stz_Stw2_HMS:
	LDX		#1
	STX		P_Temp+4

Stz_Stw_HMS_Run:
	LDA		StwFlag_Addr,X
	AND		#BIT3_
	STA		StwFlag_Addr,X

	LDA		StwFlag_Addr,X
	AND		#BIT0
	BNE		L_Key5_Number_End

	LDA		StwFlag_Addr,X
	AND		#BIT5
	BNE		Spl_To_Stw
	LDA		#0
	STA		StwSec_Addr,X
	STA		StwSecSpl_Addr,X
	LDA		#0
	STA		StwMin_Addr,X
	STA		StwMinSpl_Addr,X
	LDA		#0
	STA		StwHr_Addr,X
	STA		StwHrSpl_Addr,X
	JSR		Stz_Stw_Flag_1

	LDA		StwFlag_Addr,X
	AND		#BIT4_
	STA		StwFlag_Addr,X

	JSR		L_Dis_Stw_Mode
	RTS		
Spl_To_Stw:
	LDA		StwSecSpl_Addr,X
	STA		StwSec_Addr,X
	LDA		StwMinSpl_Addr,X
	STA		StwMin_Addr,X
	LDA		StwHrSpl_Addr,X
	STA		StwHr_Addr,X
	LDA		StwFlag_Addr,X
	AND		#05Fh
	STA		StwFlag_Addr,X
	JSR		L_Dis_Stw_Mode
	BRA		L_Key5_Number_End
Stz_Stw_Flag_1:
	LDA		StwFlag_Addr,X
 	AND		#0DDh
	STA		StwFlag_Addr,X
 	RTS	
;====================================
Stz_Al_HMS:				;重置闹钟
	LDA		Sys_Flag_B
	AND		#BIT0
	BNE		Stz_Al_HMS_End
	LDA		#0
	STA		R_Al_Sec
	STA		R_Al_Min
	STA		R_Al_Hr
	JSR		L_Dis_Al_Mode
Stz_Al_HMS_End:
	RTS
;=======================================
Change_voice:				;时钟模式下更改静音震动
	LDA		Sys_Flag_B
	EOR		#BIT2
	STA		Sys_Flag_B
	JSR		F_KeyBeep
	JSR		Judge_NoVoice
	RTS
;;============================================	
L_Key4_Number:		;4号键  开始/停止

	; JSR		Judge_Lock_Key4
	; BCS		L_Key4_Number_End

	LDA		R_Key_Flag
	AND		#BIT6
	BNE		L_HoldKey4_Number
	
	JSR		Judge_Key4_Beep

	LDA		R_Key_Flag
	ORA		#BIT6
	STA		R_Key_Flag

	JSR		F_ClearScreen
	LDA		P_Temp+5
	INC
	STA		P_Temp+5

	LDA		P_Temp+5
	CMP		#2
	BEQ		STZ_PTEMP5
	RTS
STZ_PTEMP5:
	LDA		#0
	STA		P_Temp+5
	RTS

L_Key4_Number_Run:
	
	lda		R_Mode
	CMP		#D_Al_Mode
	BEQ		Change_Al_Sta

	CMP		#D_Stw_Mode
	BEQ		Change_Stw_Flag


L_HoldKey4_Number:
	JSR		L_HoldKey
L_Key4_Number_End:
	RTS	
;============================================================
Change_Al_Sta:		;4号键
;	JSR		Judge_Alarm1_Start
	LDA		Sys_Flag_B
	AND		#BIT1_
	STA		Sys_Flag_B

	JSR		F_ClrZZ

	LDA		Sys_Flag_B
	EOR		#BIT0
	STA		Sys_Flag_B
;	JSR		Judge_Alarm_Spl
	JSR		Judge_Alarm_Start
	rts
;===================================
; Change_24OR12:
; 	LDA		Sys_Flag_B
; 	EOR		#BIT5
; 	STA		Sys_Flag_B
; 	JSR		L_Dis_TimeHr
; Change_24OR12_End:
; 	RTS
; ;===================================

;===================================
Change_Stw_BIT5:
	LDA		StwFlag_Addr,X
	AND		#BIT5
	BNE		Change_Stw_BIT5_End
	LDA		StwFlag_Addr,X
	ORA		#BIT5
	STA		StwFlag_Addr,X
	LDA		StwSec_Addr,X
	STA		StwSecSpl_Addr,X	;备份秒
	LDA		StwMin_Addr,X
	STA		StwMinSpl_Addr,X	;备份分
	LDA		StwHr_Addr,X
	STA		StwHrSpl_Addr,X	;备份时
	JSR		L_Dis_Stw_Mode 
Change_Stw_BIT5_End:	
	RTS

To_Spl_To_Stw:
	JSR		Stop_Stw_Beep
	JMP		Spl_To_Stw

Change_Stw_Flag:			;更改BIT0位开始或停止秒表
	LDA		R_Stw_Mode
	BNE		Change_Stw2_Flag

	LDX		#0
	STX		P_Temp+4
	BRA		Change_Stw_Flag_Run
Change_Stw2_Flag:
	LDX		#1
	STX		P_Temp+4

Change_Stw_Flag_Run:
	lda		StwFlag_Addr,X	
	eor		#BIT0
	ORA		#BIT3
	sta		StwFlag_Addr,X

	JSR		F_ClrTime_end 

	LDX		P_Temp+4
	LDA		StwFlag_Addr,X
	AND		#BIT7
	BNE		To_Spl_To_Stw	

	LDA		StwFlag_Addr,X
	AND		#BIT0
	BNE		Change_Stw_BIT5	;若按下为开始，则将时分秒计入备份
			
	rts
;============================================================
Start_Fast_Key3:				;FastKey功能，快加
	LDA		R_Fast_Time
	CMP		#C_Fast_Time
	BEQ		Start_Fast_Key3_End
	INC		R_Fast_Time
	RTS
Start_Fast_Key3_End:
	LDA		#0
	STA		R_Fast_Time
	BRA		L_Key3_Number_Run
	
;;============================================
L_Key3_Number:		;3号键  秒
	LDA		R_Key_Flag
	AND		#BIT4
	BNE		Start_Fast_Key3		

	JSR		Judge_Key3_Beep

	LDA		R_Key_Flag
	AND		#BIT6
	BNE		L_HoldKey3_Number 

	LDA		R_Key_Flag
	ORA		#BIT6
	STA		R_Key_Flag
L_Key3_Number_Run:
	JSR		Judge_Lock_Key3
	BCS		L_Key3_Number_End

	lda		R_Mode
	CMP		#D_Al_Mode
	BEQ		Change_Al_Sec

	CMP		#D_Stw_Mode
	BEQ		Change_Stw_Sec
	
	CMP		#D_Time_Mode
	BEQ		Change_Timer_Sec

L_HoldKey3_Number:
	JMP		L_HoldKey


L_Key3_Number_End:
	RTS	
;;============================================
Change_Al_Sec:		;3号键
	JSR		F_AlInc
	JSR		L_Dis_Al
Change_Al_Sec_End:
	rts

;===================================
Change_Stw_Sec:
	JSR		Judge_Min_Sec_Run
	BCS		L_Key3_Number_End

	LDA		R_Stw_Mode
	BNE		Change_Stw2_Sec

	LDX		#0
	STX		P_Temp+4
	BRA		Stw_Sec_Inc
Change_Stw2_Sec:
	LDX		#1
	STX		P_Temp+4

Stw_Sec_Inc:
	JSR		R_Stw_Flag_1to1	
	JSR		F_StwSecInc
	JSR		L_Dis_Stw_Mode
	LDA		Sys_Flag_A
	ORA		#BIT5
	STA		Sys_Flag_A
	rts	
;===================================
Change_Timer_Sec:
	LDA		Sys_Flag_A
	AND		#BIT6_
	STA		Sys_Flag_A
	LDA		#15
	STA		R_Num		
	JSR		F_SecInc
	JSR		L_Dis_Time
	rts	
;;============================================
Start_Fast_Key2:				;FastKey功能
	LDA		R_Fast_Time
	CMP		#C_Fast_Time
	BEQ		Start_Fast_Key2_End
	INC		R_Fast_Time
	RTS
Start_Fast_Key2_End:
	LDA		#0
	STA		R_Fast_Time
	BRA		L_Key2_Number_Run

;;============================================
L_Key2_Number:		;2号键  分针
	LDA		R_Key_Flag
	AND		#BIT4
	BNE		Start_Fast_Key2

	JSR		Judge_Key2_Beep

	LDA		R_Key_Flag
	AND		#BIT6
	BNE		L_HoldKey2_Number

	LDA		R_Key_Flag
	ORA		#BIT6
	STA		R_Key_Flag
L_Key2_Number_Run:
	JSR		Judge_Lock_Key2
	BCS		L_Key2_Number_End

	lda		R_Mode
	CMP		#D_Al_Mode
	BEQ		Change_Al_Min
	
	CMP		#D_Stw_Mode
	BEQ		Change_Stw_Min

	CMP		#D_Time_Mode
	BEQ		Change_Timer_Min

L_HoldKey2_Number:
	JMP		L_HoldKey
L_Key2_Number_End:
	RTS	
;===================================
R_Stw_Flag_1to1:
	LDA		StwFlag_Addr,X
	ORA		#BIT1
	STA		StwFlag_Addr,X		;BIT1位用于保证时分秒有值时位倒计时
	RTS

;============================================================
Change_Al_Min:					;2号键
	JSR		F_AlMinInc
	JSR		L_Dis_Al
Change_Al_Min_End:
	rts
;==================================
;===================================
Change_Stw_Min:
	JSR		Judge_Min_Sec_Run
	BCS		L_Key2_Number_End

	LDA		R_Stw_Mode
	BNE		Change_Stw2_Min

	LDX		#0
	STX		P_Temp+4
	BRA		Stw_Min_Inc
Change_Stw2_Min:
	LDX		#1
	STX		P_Temp+4

Stw_Min_Inc:
	JSR		R_Stw_Flag_1to1
	JSR		F_StwMinInc
	JSR		L_Dis_Stw_Mode
	LDA		Sys_Flag_A
	ORA		#BIT5
	STA		Sys_Flag_A
	rts
;=====================================
Change_Timer_Min:
	LDA		Sys_Flag_A
	AND		#BIT6_
	STA		Sys_Flag_A
	LDA		#15
	STA		R_Num
	JSR		F_MinInc
	JSR		L_Dis_Time
	rts


;;============================================
Start_Fast_Key1:				;FastKey功能
	LDA		R_Fast_Time
	CMP		#C_Fast_Time
	BEQ		Start_Fast_Key1_End
	INC		R_Fast_Time
	RTS
Start_Fast_Key1_End:
	LDA		#0
	STA		R_Fast_Time
	BRA		L_Key1_Number_Run

;;============================================
L_Key1_Number:		;1号键 小时
	LDA		R_Key_Flag
	AND		#BIT4
	BNE		Start_Fast_Key1

	JSR		Judge_Key1_Beep

	LDA		R_Key_Flag
	AND		#BIT6
	BNE		L_HoldKey1_Number

	LDA		R_Key_Flag
	ORA		#BIT6
	STA		R_Key_Flag
L_Key1_Number_Run:	
	JSR		Judge_Lock_Key1
	BCS		L_Key1_Number_End

	lda		R_Mode
	CMP		#D_Al_Mode
	BEQ		Change_Al_Hr
	
	CMP		#D_Stw_Mode
	BEQ		Change_Stw_Hr

	CMP		#D_Time_Mode
	BEQ		Change_Timer_Hr
	
L_HoldKey1_Number:
	JMP		L_HoldKey
L_Key1_Number_End:
	RTS	

;============================================================
Change_Al_Hr:	;1号键
	JSR		F_AlHrInc
	JSR		L_Dis_Al
Change_Al_Hr_End:
	rts					


;==============================
Change_Stw_Hr:
	LDA		Sys_Flag_A
	AND		#BIT5
	BEQ		Change_Stw2_Mode

	JSR		Judge_Min_Sec_Run
	BCS		L_Key1_Number_End
	
	LDA		R_Stw_Mode
	BNE		Change_Stw2_Hr

	LDX		#0
	STX		P_Temp+4
	BRA		Stw_Hr_Inc
Change_Stw2_Hr:
	LDA		Sys_Flag_A
	AND		#BIT5
	BEQ		Change_Stw_Mode

	LDX		#1
	STX		P_Temp+4
Stw_Hr_Inc:
	JSR		R_Stw_Flag_1to1
	JSR		F_StwHrInc
	JSR		L_Dis_Stw_Mode
	RTS
;===============================
Change_Stw2_Mode:
	LDA		R_Stw_Mode
	INC
	STA		R_Stw_Mode
	LDA		R_Stw_Mode
	CMP		#2
	BEQ		Change_Stw_Mode

	BRA		Dis_Stw_Mode
Change_Stw_Mode:
	LDA		#0
	STA		R_Stw_Mode
Dis_Stw_Mode:
	jsr		F_ClearScreen
	JSR		L_Dis_Stw_Mode
	RTS
;===============================
Change_Timer_Hr:
	LDA		Sys_Flag_A
	AND		#BIT6_
	STA		Sys_Flag_A
	LDA		#15
	STA		R_Num

	JSR		F_HrInc
	JSR		L_Dis_Time
	rts

;============================================================
L_HoldKey:					;按键压下		
	LDA		R_KeyHold_Time
	CMP		#D_Key2S
	BCS		L_HoldKey_BIT6

	INC		R_KeyHold_Time
	BRA		L_End_HoldKey
L_HoldKey_BIT6:
	LDA		R_Key_Flag
	ORA		#BIT4
	STA		R_Key_Flag
L_End_HoldKey:
	RTS
;=================================