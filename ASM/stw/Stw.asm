;==============================================================百分秒跑秒
L_Judge_Run_Stw_Prog:
	LDA		StwFlag_Addr,X
	AND		#BIT7						;倒计时结束后开始加
	BNE		L_Inc_StwSec_Prog

	LDA		StwFlag_Addr,X
	AND		#BIT1
	BNE		L_Dec_StwSec_Prog

L_Inc_StwSec_Prog:
	JSR		F_StwSecInc					;秒的更新
	BCC		L_End_Judge_Run_Stw_Prog	
	
	JSR		F_StwMinInc					;分的更新
	BCC		L_End_Judge_Run_Stw_Prog

	JSR		F_StwHrInc					;时的更新
	BCS		L_End_Judge_Run_Stw_Prog						
L_End_Judge_Run_Stw_Prog:	
	RTS


L_Dec_StwSec_Prog:
	JSR		F_StwSecDec				;秒的更新
	BCS		Stw_End_Judge
	JSR		F_StwMinDec				;分的更新
	BCS		L_End_Judge_Run_Stw_Prog
	JSR		F_StwHrDec					;时的更新
	BRA		L_End_Judge_Run_Stw_Prog


;=============================================
Judge_Stw_Start:
	LDX		#0
	STX		P_Temp+4


	LDA		StwFlag_Addr,X
	AND		#BIT0
	BEQ		Judge_Stw2_Start

	JSR		L_Judge_Run_Stw_Prog
	

Judge_Stw2_Start:
	LDX		#1
	STX		P_Temp+4

	LDA		StwFlag_Addr,X
	and		#BIT0
	BEQ		Judge_Stw_Start_End

	JSR		L_Judge_Run_Stw_Prog

Judge_Stw_Start_End:
	RTS

;=======================================
Stw_End_Judge:
	LDX		P_Temp+4
	LDA		StwSec_Addr,X
	ORA		StwMin_Addr,X
	ORA		StwHr_Addr,X
	CMP		#0
	BNE		Stw_End_Judge_End
	LDA		StwFlag_Addr,X
 	ORA		#BIT7
	STA		StwFlag_Addr,X

	;JSR		Judge_Alarm_Beep

    LDA     #61;#$31
    STA     R_Beep_Time    	

Stw_End_Judge_End:
	RTS

;==================================	
F_StwBeepControl:	
	LDA		R_Stw_Flag
	ORA		R_Stw_Flag+1
	AND		#BIT7
	BEQ		F_StwBeepControl_End

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
;========================================
Judge_Min_Sec_Run:
	LDA		R_Stw_Mode
	CMP		#0
	BNE		Judge_Min_Sec_TWO

	LDA		R_Stw_Flag
	AND		#BIT0
	BNE		Skip_Min_Sec

	BRA		Judge_Min_Sec_Run_End
Judge_Min_Sec_TWO:
	LDA		R_Stw_Flag+1
	AND		#BIT0
	BNE		Skip_Min_Sec

	BRA		Judge_Min_Sec_Run_End
Skip_Min_Sec:
	SEC
	RTS
Judge_Min_Sec_Run_End:
	CLC
	RTS

;====================================
Judge_Key5_Lock_Stw:		;秒表运行则清除键失效
	LDA		R_Mode
	CMP		#D_Stw_Mode
	BNE		Judge_Key_Lock_StwF_End

	LDA		R_Stw_Mode
	CMP		#0
	BNE		Judge_Key5_Stw_Lock_TWO

	LDA     R_Stw_Flag
    AND     #BIT0
    BEQ     Judge_Key_Lock_StwF_End

	BRA		Skip_Lock_Key5
Judge_Key5_Stw_Lock_TWO
	; LDA     R_Stw_Flag
    ; AND     #BIT1
    ; BNE     Judge_Key_Lock_StwF_End

	LDA     R_Stw_Flag+1
    AND     #BIT0
    BEQ     Judge_Key_Lock_StwF_End

Skip_Lock_Key5:
    SEC
    RTS     
Judge_Key_Lock_StwF_End:
    CLC
    RTS