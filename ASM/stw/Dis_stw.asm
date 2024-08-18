;==========================================
L_Dis_Stw_Mode:
;	JSR		F_ClearScreen
	JSR		F_DisCol		;显示col图标

	LDA		R_Stw_Mode
	CMP		#D_Stw2
	BEQ		L_Dis_Stw_Ttwo

	JSR		F_DisStwOne
	LDX		#0
	STX		P_Temp+4

	;JSR		Judge_Forward_Timekeeping
	JSR		Judge_Stw_TimeKeeping
	JSR		Judge_Stw_Forward
	LDX		P_Temp+4
	JMP		L_Dis_Stw_Mode_OnlyDigit
	
L_Dis_Stw_Ttwo:
	JSR		F_DisStwTwo
	LDX		#1
	STX		P_Temp+4
	;JSR		Judge_Forward_Timekeeping
	JSR		Judge_Stw_TimeKeeping
	JSR		Judge_Stw_Forward
	LDX		P_Temp+4
	JMP		L_Dis_Stw_Mode_OnlyDigit

L_Dis_Stw_Mode_OnlyDigit:	
	LDA		StwMin_Addr,X
	JSR		L_Dis_Digit34
	LDX		P_Temp+4

	LDA		StwSec_Addr,X
	JSR		L_Dis_Digit56
	LDX		P_Temp+4

	LDA		StwHr_Addr,X
	JMP		L_Dis_Hr
L_End_Dis_Stw_Mode:
	RTS

;====================================================
Judge_Stw_TimeKeeping:
	LDA		R_Mode
	CMP		#D_Stw_Mode
	BNE		Judge_NoStw_TimeKeeping

 	LDA		R_Stw_Mode
 	CMP		#D_Stw
 	BNE		Stw2_TimeKeeping		;需要判断的与当前状态相反
	
 	LDX		#0
 	STX		P_Temp+4
 	BRA		Stw_TimeKeeping_Status
Stw2_TimeKeeping:
	LDX		#1
	STX		P_Temp+4
Stw_TimeKeeping_Status:
	LDA		StwFlag_Addr,X
 	AND		#BIT5			
 	BEQ		Dis_Timekeeping_2	

	LDA		StwFlag_Addr,X
 	AND		#BIT1			
 	BNE		Dis_Timekeeping_2

	JSR		Change_Stw_X

	LDA		StwFlag_Addr,X
 	AND		#BIT0			
 	BEQ		Clr_Timekeeping

	LDA		StwFlag_Addr,X
 	AND		#BIT1			
 	BEQ		Clr_Timekeeping

	BRA		FLash_TimeKeeping

Judge_NoStw_TimeKeeping:
	LDA		R_Stw_Flag
	AND		#BIT0			
	BEQ		Judge_NoStw2_TimeKeeping;stw判断计时开始后正/倒计时标志

	LDA		R_Stw_Flag
	AND		#BIT1			
	BEQ		Judge_NoStw2_TimeKeeping;stw判断计时开始后正/倒计时标志

	BRA		FLash_TimeKeeping
Judge_NoStw2_TimeKeeping:
	LDA		R_Stw_Flag+1
	AND		#BIT0			
	BEQ		Clr_Timekeeping;stw判断计时开始后正/倒计时标志

	LDA		R_Stw_Flag+1
	AND		#BIT1			
	BEQ		Clr_Timekeeping;stw判断计时开始后正/倒计时标志


FLash_TimeKeeping:
	LDA		Sys_Flag_A
	AND		#BIT1
	BNE		Clr_Timekeeping		;半秒闪烁
Dis_Timekeeping_2:
	JSR		F_DisTimekeeping
	RTS
Clr_Timekeeping:
	JSR		F_ClrTimekeeping
Judge_Stw_TimeKeeping_End:
	RTS


;====================================================
Judge_Stw_Forward:
	LDA		R_Mode
	CMP		#D_Stw_Mode
	BNE		Judge_NoStw_Forward

 	LDA		R_Stw_Mode
 	CMP		#D_Stw
 	BNE		Stw2_Forward
	
 	LDX		#0
 	STX		P_Temp+4
 	BRA		Stw_Forward_Status

Stw2_Forward:
 	LDX		#1
 	STX		P_Temp+4
 	; JSR		F_ClrForward
Stw_Forward_Status:
 	

	LDA		StwFlag_Addr,X
 	AND		#BIT1			
 	BNE		Stw2_Forward_Status

	LDA		StwFlag_Addr,X
 	AND		#BIT5			
 	BNE		Dis_Forward	

Stw2_Forward_Status:
	JSR		Change_Stw_X

	LDA		StwFlag_Addr,X
 	AND		#BIT0			
 	BEQ		Judge_Stw_Forward_End

	LDA		StwFlag_Addr,X
 	AND		#BIT1			
 	BNE		Judge_Stw_Forward_End

 	BRA		Flash_Forward


Judge_NoStw_Forward:
	LDA		R_Stw_Flag
	AND		#BIT0
	BEQ		Judge_NoStw2_Forward
	
	LDA		R_Stw_Flag
	AND		#BIT1
	BNE		Judge_NoStw2_Forward

	BRA		Flash_Forward
Judge_NoStw2_Forward:
	LDA		R_Stw_Flag+1
	AND		#BIT0
	BEQ		Judge_Stw_Forward_End
	
	LDA		R_Stw_Flag+1
	AND		#BIT1
	BNE		Judge_Stw_Forward_End


Flash_Forward:
	LDA		Sys_Flag_A
	AND		#BIT1
	BNE		Judge_Stw_Forward_End		;半秒闪烁
Dis_Forward:
	JSR		F_DisForward	
	RTS
Judge_Stw_Forward_End:
	JSR		F_ClrForward

Judge_Stw_Forward_End_RTS:
	RTS

Change_Stw_X:
	LDA		P_Temp+4
	CMP		#0
	BEQ		Change_Stw_X_
	LDX		#0
;	STX		P_Temp+4
	RTS
Change_Stw_X_:
	LDX		#1
;	STX		P_Temp+4
Change_Stw_X_End:
	RTS
;====================================================
Judge_Forward_Timekeeping:
	LDA		StwFlag_Addr,X
	AND		#BIT1
	BNE		DIS_Timekeeping

	LDA		StwFlag_Addr,X
	AND		#BIT5
	BEQ		DIS_Timekeeping

;	JSR		F_ClrTimekeeping
	JSR		F_DisForward
	RTS
DIS_Timekeeping:
;	JSR		F_ClrForward
	JSR		F_DisTimekeeping
Judge_Forward_Timekeeping_End:
	RTS

;===========================================
Judge_TimeEnd:
	LDA		R_Stw_Flag
	ORA		R_Stw_Flag+1
	AND		#BIT7	
	BEQ		Judge_TimeEnd_End

	JSR		F_DisTime_end
Judge_TimeEnd_End:
	RTS