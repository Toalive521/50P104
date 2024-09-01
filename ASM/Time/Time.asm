;=====================================================
;=====================================================
F_Update_Time_Prog:	
	JSR		F_SecInc
	BCC		L_End_Update_Time_Prog
	JSR		F_MinInc
	BCC		L_End_Update_Time_Prog
	JSR		F_HrInc
	BCC		L_End_Update_Time_Prog

L_End_Update_Time_Prog:
	RTS
;====================================================
F_Update_STW_Prog:
	BBS3	Sys_Flag_B,L_End_MAX_STW_Prog		;判断是否到结束(正计时99M59S)
	BBR1	Sys_Flag_B,L_End_Update_STW_Prog	;;判断计时是否暂停(暂停跳转)

	BBR2	Sys_Flag_B,L_Update_STW_FORW_Prog	;;0：正计时/1：倒计时
	JSR		L_Update_CTW_FORW_Prog
	RTS


;;倒计时
L_Update_CTW_FORW_Prog:
	JSR		R_CtwDec_Sec
	BCS		L_Update_CTW_FORW_End_Prog
	JSR		R_CtwDec_Min
	BCS		L_Update_CTW_FORW_End_Prog
L_Update_CTW_FORW_End_Prog:
	LDA		R_Stw_Sec
	ORA		R_Stw_Min
	BEQ		?Stop
	RTS
?Stop:
	LDA		#30H
	STA		R_Beep_Time
	RMB1	Sys_Flag_B		;;暂停
	SMB7	Sys_Flag_B		;;倒计时结束
	RTS

L_End_MAX_STW_Prog: 
	RMB1	Sys_Flag_B		;;正计时最大值，结束计时(暂停计时)
	rts
L_End_Update_STW_Prog:
	LDA		R_Stw_Sec
	ORA		R_Stw_Min
	BNE		?CTW			;;min sec均为0时，为正计时
	RTS
?CTW:
	; SMB2	Sys_Flag_B		;;标记倒计时
	RTS

;;正计时
L_Update_STW_FORW_Prog:
	JSR		R_CtwInc_Sec
	BCC		L_Update_STW_FORW_End_Prog
	JSR		R_CtwInc_Min
	BCC		L_Update_STW_FORW_End_Prog
L_Update_STW_FORW_End_Prog:
	;对比正计时最大值
	LDA		R_Stw_Sec
	CMP		#$59
	BCC		?RTS
	LDA		R_Stw_Min
	CMP		#$99
	BCC		?RTS

	RMB1	Sys_Flag_B		;;暂停计时
	SMB3	Sys_Flag_B		;;标记正计时达到99M59S
?RTS:
	RTS

;====================================================
;====================================================
;----------------------------------------------------
F_HrInc:
	LDX		#(R_Time_Hr-Time_str_Addr)
L_Inc_0_To_23_Prog:	
L_Inc_To_24:
	LDA		#$23
	BRA		L_Inc_0_To_Any_Count_Prog
	
F_HrDec:
	LDX		#(R_Time_Hr-Time_str_Addr)	
	LDA		#$23
	BRA		L_Dec_To_0_Prog
	
; F_AlHrInc:	;注意范围
; 	LDX		#(R_Al_Hr-Time_str_Addr)
; 	LDA		#$23
; 	; JMP		L_Inc_0_To_Any_Count_Prog
; 	BRA		L_Inc_0_To_23_Prog

;----------------------------------------------------
F_MinInc:
	LDX		#(R_Time_Min-Time_str_Addr)
	BRA		L_Inc_0_To_59_Prog

F_MinDec:
	LDX		#(R_Time_Min-Time_str_Addr)	
	LDA		#$59
	BRA		L_Dec_To_0_Prog

; F_MinSplDec:
; 	LDX		#(R_Al_Min_Spl-Time_str_Addr)
; 	LDA		#10	
; 	BRA		L_Dec_To_0_Prog

; F_SecSplDec:
; 	LDX		#(R_Al_Sec_Spl-Time_str_Addr)
; 	BRA		L_Dec_To_60_Prog

	
; F_AlMinInc:
; 	LDX		#(R_Al_Min-Time_str_Addr)
; 	BRA		L_Inc_0_To_59_Prog	
; F_AlInc:
; 	LDX		#(R_Al_Sec-Time_str_Addr)
; 	BRA		L_Inc_0_To_59_Prog	

F_SecInc:
	LDX 	#(R_Time_Sec-Time_str_Addr)
L_Inc_0_To_59_Prog:
L_Inc_To_60:
	LDA		#$59
L_Inc_0_To_Any_Count_Prog:	
	STA		P_Temp+1	;最大值
	LDA		#$00
L_Inc_Any_To_Any_Count_Prog:	
	STA		P_Temp		;最小值	
	LDA		Time_Addr,X	;P_Temp+1		
	CMP		P_Temp+1	;Time_Addr,X
	BCS		L_Inc_Over
	CLC
	SED
	LDA		Time_Addr,X
	ADC		#1
	STA		Time_Addr,X
	CLD
	RTS
L_Inc_Over:
	LDA		P_Temp		
	STA		Time_Addr,X
	SEC
	RTS	   
;=====================================================	
L_Dec_To_60_Prog:
	LDA		#$59
L_Dec_To_0_Prog:
	STA		P_Temp
	LDA		#0
L_Dec_To_Anycount_Prog:
	SEC
    SBC     Time_Addr,X
	BEQ		L_Dec_Over_Prog
	BCS		L_Dec_Over_Prog
	
	SEC
	SED
	LDA		Time_Addr,X
	SBC		#1
	STA		Time_Addr,X
	CLD
	SEC
	RTS
L_Dec_Over_Prog:
	LDA		P_Temp
	STA		Time_Addr,X
	CLC	
	RTS
;=====================================================
R_CtwInc_Sec:		
	LDX		#(R_Stw_Sec-Time_str_Addr)
	; TXA
	; CLC
	; ADC		P_Temp+4
	; TAX
	BRA		L_Inc_To_60

R_CtwInc_Min:
	LDX		#(R_Stw_Min-Time_str_Addr)
	LDA		#$99
	; TXA
	; CLC
	; ADC		P_Temp+4
	; TAX
	BRA		L_Inc_0_To_99_Count_Prog

L_Inc_0_To_99_Count_Prog:
	STA		P_Temp+1	;最大值
	LDA		#$00
	BRA		L_Inc_Any_To_Any_Count_Prog


; F_StwHrInc:
; 	LDX		#(R_Stw_Hr-Time_str_Addr)
; 	TXA
; 	CLC
; 	ADC		P_Temp+4
; 	TAX
; 	LDA		#$23
; 	BRA		L_Inc_0_To_Any_Count_Prog
;-------------------------------------------------

R_CtwDec_Sec:		
	LDX		#(R_Stw_Sec-Time_str_Addr)
	; TXA
	; CLC
	; ADC		P_Temp+4
	; TAX
	BRA		L_Dec_To_60_Prog

R_CtwDec_Min:
	LDX		#(R_Stw_Min-Time_str_Addr)
	; TXA
	; CLC
	; ADC		P_Temp+4
	; TAX
	BRA		L_Dec_To_60_Prog

; F_StwHrDec:
; 	LDX		#(R_Stw_Hr-Time_str_Addr)
; 	TXA
; 	CLC
; 	ADC		P_Temp+4
; 	TAX
; 	LDA		#$99
; 	BRA		L_Dec_To_0_Prog

;-------------------------------------------------

; F_KeyIncSec:
; 	JSR		F_SecInc
; 	JSR		L_Dis_Time ;L_Dis_TimeSec
; 	RTS
	
; F_KeyIncMin:
; 	JSR		F_MinInc
; 	JMP		L_Dis_Time ;L_Dis_TimeMin
; F_KeyIncHr:
; 	JSR		F_HrInc
; 	LDA		R_Time_Hr
; 	BNE		L_Exit_KeyIncHr
; 	LDA		Sys_Flag_B
; 	EOR		#BIT5
; 	STA		Sys_Flag_B	;12hr/24hr
; L_Exit_KeyIncHr:	
; 	JMP		L_Dis_Time ;L_Dis_TimeHr
