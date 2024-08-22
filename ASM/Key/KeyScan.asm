;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
D_Key1S		.EQU  32*1
D_Key2S		.EQU  25*2
D_Key3S		.EQU  30*3

D_Key2		.EQU  %00000100
D_Key5		.EQU  %00100000
D_Key7		.EQU  %10000000
D_Key57		.EQU  %10100000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
L_32Hz_Prog:	
	LDA		Sys_Flag_A
	AND		#BIT2
	BEQ		L_End_32Hz_Prog
	
	SEI
	LDA		Sys_Flag_A
	AND		#BIT2_
	STA		Sys_Flag_A
	CLI
	; JSR		L_Beep_Control_Prog
	JSR		L_Scankey_Prog
L_End_32Hz_Prog:
	RTS
;---------------------------------------------------------
L_Scankey_Prog:
	JSR		F_KeyIoPAInputHigh

	JSR		L_ScanKey_Delay_Prog		;	等待功能，跑循环
	LDA     P_PA
    EOR     #10100100B			;;取反，区分按下和未按下的键
    AND     #10100100B			;;去除其余干扰位，确定按键
    STA     P_Temp+1
	BNE		L_Havekey		
	JMP		L_Null_Key_Prog
L_Havekey:
	LDA		P_Temp+1
	CMP		R_KeyValue
	BEQ		L_KeyLine1
	STA		R_KeyValue
	RTS

L_KeyLine1:
	LDA		R_Key_Flag
	AND		#BIT7
	BEQ		L_KeyLine1_
	RTS

L_KeyLine1_:
;	JSR		Stop_Alarm_Beep		;有键按下即关闭闹钟

	LDA		P_Temp+1
	CMP		#D_Key2
	BEQ		L_Key2_Enter
	
	CMP		#D_Key5
	BEQ		L_Key5_Enter

	CMP		#D_Key7
	BEQ		L_Key7_Enter

	CMP		#D_Key57
	BEQ		L_Key57_Enter

	JMP		L_ManyKey
;============================================================
L_Key57_Enter:
	BBR0	Sys_Flag_B,L_Key57_Enter_RTS	;;判断是否在计时模式下
	BBS4	Sys_Flag_A,L_Key57_Enter_RTS	;;标记57键是否为按下状态
	SMB4	Sys_Flag_A
	
	LDA		#0
	STA		R_Stw_Sec		;;同时按下则清零
	STA		R_Stw_Min
	RMB2	Sys_Flag_B			;;清零后，标记为正计时
	RMB1	Sys_Flag_B			;;计时暂停状态
	JMP		L_Display_Mode0Prog
L_Key57_Enter_RTS:
	RTS
;============================================================
L_Key2_Enter:
	BBS4	Sys_Flag_A,?RTS		;;判断Sys_Flag_A的bit4=1？ 不为1，则往下执行；为1 说明按键已经按下，直接跳转
	SMB4	Sys_Flag_A		;;标记Sys_Flag_A的bit4=1
	SMB0	R_Key_Flag		;;R_Key_Flag的bit0=1

?RTS:
	LDA		R_KeyHold_Time
	CMP		#D_Key3S
	BEQ		L_Key2_Enter_End		;;判断是否按下满足3S
	LDA		R_KeyHold_Time
	INC
	STA		R_KeyHold_Time
	RTS

L_Key2_Enter_End:			;;满足3S
	BBR0	R_Key_Flag, ?RTS  ;;判断bit0=0?  =0：不是2key，跳转
	RMB0	R_Key_Flag			;;bit0=1时，清除-->bit0=0
	LDA		#0					
	STA		R_No_Key			;;若10S内有按键按下，重置R_No_Key
	LDA		#0					
	STA		R_STW_Key			;;若30S内有按键按下，重置R_STW_Key
	LDA		R_Set_Flag			
	BNE		?RTS				;;判断R_Set_Flag不为0 ？ 不为0：跳转	为0 ：R_Set_Flag加1,R_Set_Flag=1
	INC		R_Set_Flag
	JSR		L_Display_Mode0Prog	;;R_Set_Flag=1
?RTS:
	RTS
;=================================================	
L_Key5_Enter:
	BBS6	Sys_Flag_A,?RTS
	SMB6	Sys_Flag_A
	SMB1	R_Key_Flag		;;bit1=1

?RTS:
	LDA		R_KeyHold_Time
	CMP		#D_Key3S
	BEQ		L_Key5_Enter_End
	LDA		R_KeyHold_Time
	INC
	STA		R_KeyHold_Time
	RTS
?End:
	RTS

L_Key5_Enter_End:
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	LDA		#0
	STA		R_No_Key			;;若10S内有按键按下，重置R_No_Key
	LDA		#0					
	STA		R_STW_Key			;;若30S内有按键按下，重置R_STW_Key
	LDA		R_Fast_Time
	CMP		#C_Fast_Time
	BCC		L_Inc_Fast_Time		;;R_Fast_Time<C_Fast_Time,C=0时跳转,R_Fast_Time继续累加
	LDA		#0
	STA		R_Fast_Time			;;达到按键时长,R_Fast_Time>=C_Fast_Time,C=1不跳转,R_Fast_Time重置为0,一次快加结束
	; BBS0	Sys_Flag_B,?STW_CTW		;;判断时间(0)/计时(1)模式
	JSR		L_FastAdd_Prog
	RTS
; ?STW_CTW:
; 	BBS1	Sys_Flag_B,?RTS		;;判断计时开始(1)/暂停(0)
; 	JSR		L_FastAdd_Prog
; ?RTS:
; 	RTS

;==================================================	
L_Key7_Enter:
	BBS7	Sys_Flag_A,?RTS
	SMB7	Sys_Flag_A
	SMB2	R_Key_Flag		;;bit2=1

?RTS:
	LDA		R_KeyHold_Time
	CMP		#D_Key3S
	BEQ		L_Key7_Enter_End
	LDA		R_KeyHold_Time
	INC
	STA		R_KeyHold_Time
	RTS
?End:
	RTS	

L_Key7_Enter_End:
	LDA		#0
	STA		R_No_Key		;;若10S内有按键按下，重置R_No_Key
	LDA		#0					
	STA		R_STW_Key			;;若30S内有按键按下，重置R_STW_Key
	RMB2	R_Key_Flag
	LDA		R_Fast_Time
	CMP		#C_Fast_Time
	BCC		L_Inc_Fast_Time		;;R_Fast_Time<C_Fast_Time,C=0时跳转,R_Fast_Time继续累加
	LDA		#0
	STA		R_Fast_Time	
	JSR		L_FastDec_Prog
	RTS

;============================================================
L_Inc_Fast_Time:
	CLC
	LDA		R_Fast_Time
	ADC		#1
	STA		R_Fast_Time
	RTS	
;============================================================
L_ManyKey:
	LDA		R_Key_Flag
	ORA		#BIT7
	STA		R_Key_Flag
L_End_KeyScan_Prog:	
	RTS
	
;============================================================
;============================================================
L_Null_Key_Prog:				
	JSR		F_KeyIoPAInputHigh
	LDA		#$0
	STA		R_KeyHold_Time

	JSR		L_REALSE_2KEY
	JSR		L_REALSE_5KEY
	JSR		L_REALSE_7KEY

	RMB4 	Sys_Flag_A
	RMB6 	Sys_Flag_A
	RMB7 	Sys_Flag_A

	RMB0	Sys_Flag_C		;;清除快加/快减标志位

	LDA		R_Key_Flag
	AND		#%01111111
	STA		R_Key_Flag

	JSR		Stz_Fast_Hold_Key
	LDA		R_Voice_Unit
	BNE		L_End_Null_Key_Prog

;	JSR		L_Mode_Prog
;;L_Exit_Null_Key_Prog:	
;	ST_DIS
	DIS_LCD_IRQ
	RMB4	P_IFR
	EN_PA_IRQ
L_End_Null_Key_Prog:
	RTS
;============================================================
L_REALSE_2KEY:
	BBR0	R_Key_Flag, L_REALSE_2KEY_RTS  ;;判断bit0=0?  =0：不是2key，跳转
	RMB0	R_Key_Flag			;;bit0=1时，清除-->bit0=0
	LDA		#0
	STA		R_No_Key		;;若10S内有按键按下，重置R_No_Key
	LDA		#0					
	STA		R_STW_Key			;;若30S内有按键按下，重置R_STW_Key
	BBS0	Sys_Flag_B,?Start		;;判断是否为计时模式
	LDA		R_Set_Flag
	BEQ		?RTS		;;判断R_Set_Flag=0？ 为0 ：不执行 不为0：R_Set_Flag+1
	INC		R_Set_Flag
	LDA		R_Set_Flag
	CMP		#4			;;判断R_Set_Flag
	BEQ		?ZERO
	JSR		L_Display_Mode0Prog
	RTS
?ZERO:
	LDA		#0				;;R_Set_Flag置0
	STA		R_Set_Flag
	RTS

?RTS:
	SMB0	Sys_Flag_B			;;set=0，短按标记，进入计时模式(默认正计时)
	SMB2	Sys_Flag_B			;;标记倒计时
	JSR		L_Display_Mode0Prog
	RTS

?Start:
	BBS2	Sys_Flag_B,?STW			;;判断正/倒计时
	BBS3	Sys_Flag_B,?CTW_Zero	;;判断是否是正计时为99MS59
	LDA		Sys_Flag_B		;;控制计时开始/暂停
	EOR		#BIT1
	STA		Sys_Flag_B
	rts
?STW:
	BBS7	Sys_Flag_B,?STW_Zero			;;倒计时00MS00
	LDA		Sys_Flag_B		;;控制计时开始/暂停
	EOR		#BIT1
	STA		Sys_Flag_B
	rts


?CTW_Zero:
	LDA		#0
	STA		R_Stw_Sec		;;清零
	STA		R_Stw_Min
	RMB3	Sys_Flag_B
	RMB2	Sys_Flag_B			;;清零后，标记为正计时
	RMB0	R_Key_Flag
	JMP		L_Display_Mode0Prog
	RTS

?STW_Zero:
	RMB2	Sys_Flag_B		;;清除倒计时
	RMB0	Sys_Flag_B		;;时间模式
	RMB7	Sys_Flag_B		;;清除倒计时结束
	RMB0	R_Key_Flag

	RMB1	Sys_Flag_B
	JSR		L_Display_Mode0Prog
	RTS	

L_REALSE_2KEY_RTS:
	RTS
;============================================================
L_REALSE_5KEY:
	BBR1	R_Key_Flag,L_REALSE_5KEY_RTS	;;判断是否是PA5按下
	LDA		#0
	STA		R_No_Key
	LDA		#0			
	STA		R_STW_Key			;;若30S内有按键按下，重置R_STW_Key
	LDA		R_Set_Flag
	BEQ		?STW					;;Set=0？ =0：跳转去判断计时模式
	JSR		L_Set_Flag_Prog
	JSR		L_Display_Mode0Prog
	RTS
?STW:
	BBR0	Sys_Flag_B,?CTW_5Key		;;判断是否为计时模式(BIT0=0,跳转)，时间模式切换为计时模式的时候
	BBS2	Sys_Flag_B,?Ctw_D			;;计时模式下，判断正/倒计时
	BBS1	Sys_Flag_B,L_REALSE_5KEY_RTS	;;正计时模式，判断是否为暂停状态
	SMB2	Sys_Flag_B						;;正计时暂停状态下，按下PA5，标记倒计时
	JSR		L_Set_Flag_Prog
	RTS

?Ctw_D:
	BBS1	Sys_Flag_B,L_REALSE_5KEY_RTS	;;倒计时模式，判断是否为暂停状态
	BBS7	Sys_Flag_B,?STW_Zero			;;00MS00
	JSR		L_Set_Flag_Prog
	RTS

?CTW_5Key:
	RMB1	R_Key_Flag
	SMB0	Sys_Flag_B			;;标记计时模式
	SMB2	Sys_Flag_B			;;标记开始时进入计时为倒计时
	JSR		L_Display_Mode0Prog
	RTS

?STW_Zero:
	RMB2	Sys_Flag_B		;;清除倒计时
	RMB0	Sys_Flag_B		;;时间模式
	RMB7	Sys_Flag_B		;;清除倒计时结束
	RMB1	R_Key_Flag

	RMB1	Sys_Flag_B
	JSR		L_Display_Mode0Prog
	RTS

L_REALSE_5KEY_RTS:
	RMB1	R_Key_Flag
	RTS

;===============================================================
L_REALSE_7KEY:
	BBR2	R_Key_Flag,L_REALSE_7KEY_RTS
	LDA		#0
	STA		R_No_Key
	LDA		#0					
	STA		R_STW_Key			;;若30S内有按键按下，重置R_STW_Key
	LDA		R_Set_Flag
	BEQ		?STW
	JSR		L_Set_Flag_Prog
	JSR		L_Display_Mode0Prog
	RTS
?STW:
	BBR0	Sys_Flag_B,?CTW_7Key		;;判断是否为计时模式(BIT0=0,跳转)，时间模式切换为计时模式的时候
	BBS2	Sys_Flag_B,?Ctw_D			;;判断正/倒计时
	BBS1	Sys_Flag_B,L_REALSE_7KEY_RTS	;;正计时模式，判断是否为暂停状态
	SMB2	Sys_Flag_B						;;正计时暂停状态下，按下PA7，标记倒计时
	JSR		L_Set_Flag_Prog
	RTS

?Ctw_D:
	BBS1	Sys_Flag_B,L_REALSE_7KEY_RTS	;;倒计时模式，判断是否为暂停状态
	BBS7	Sys_Flag_B,?STW_Zero			;;00MS00
	JSR		L_Set_Flag_Prog
	RTS

?CTW_7Key:
	RMB2	R_Key_Flag
	SMB0	Sys_Flag_B			;;标记计时模式
	SMB2	Sys_Flag_B			;;标记开始进入计时为倒计时
	JSR		L_Display_Mode0Prog
	RTS

?STW_Zero:
	RMB2	Sys_Flag_B		;;清除倒计时
	RMB0	Sys_Flag_B		;;时间模式
	RMB7	Sys_Flag_B		;;清除倒计时结束
	RMB2	R_Key_Flag
	
	RMB1	Sys_Flag_B
	JSR		L_Display_Mode0Prog
	RTS

L_REALSE_7KEY_RTS:
	RMB2	R_Key_Flag
	RTS

;===============================================================
;===============================================================
L_Display_Mode0Prog:
	BBS0	Sys_Flag_B,?STW
	LDA		R_Set_Flag
	CLC
	ROL
	TAX
	LDA		T_Display_Table+1,X
	PHA
	LDA		T_Display_Table,X
	PHA
	RTS
?STW:
	RMB1	R_Key_Flag
	RMB2	R_Key_Flag
	JMP		L_STWDisplay_Prog

T_Display_Table:
	DW		L_Display_Prog-1	;;R_Set_Flag=0
	DW		L_Key5_DisHR-1		;;R_Set_Flag=1
	DW		L_Display_Prog-1	;;R_Set_Flag=2
	DW		L_Display_Prog-1	;;R_Set_Flag=3

L_Display_Prog:
	JSR		F_ClrMs
	JSR		L_Dis_TimeHr
	JSR		L_Dis_TimeMin
	JSR		L_DisCol_Prog
	RTS
;===============================================================
;===============================================================
L_1Hz_Flash_Prog:
	BBS1	Sys_Flag_B,L_MS_Flash	;;是否开始状态
	BBS7	Sys_Flag_B,L_STW_Stop	;;是否结束倒计时
	BBS0	Sys_Flag_C,?RTS			;;判断bit0=1? =1:快加/快减标志,不执行闪烁
	LDA		R_Set_Flag
	CLC
	ROL
	TAX
	LDA		T_Flash_Table+1,X
	PHA
	LDA		T_Flash_Table,X
	PHA
?RTS:
	RTS

T_Flash_Table:
	DW		L_Flash_Set0-1		;;R_Set_Flag=0
	DW		L_Flash_Set1-1		;;R_Set_Flag=1
	DW		L_Flash_Set2-1		;;R_Set_Flag=2
	DW		L_Flash_Set3-1		;;R_Set_Flag=3

L_Flash_Set0:
	BBS0	Sys_Flag_B,?RTS		;;判断时间/计时模式
	JSR		F_ClrCol
?RTS:
	rts
L_Flash_Set1:
	JSR		F_Clr12
	JSR		F_Clr34
	rts
L_Flash_Set2:
	JSR		F_Clr12
	rts
L_Flash_Set3:
	JSR		F_Clr34
	rts

L_MS_Flash:
	JSR		F_ClrMs
	RTS

L_STW_Stop:
	JSR		F_ClrMs
	JSR		F_Clr12
	JSR		F_Clr34
	RTS
; ;=======================================================	
L_Set_Flag_Prog:
	LDA		R_Set_Flag
	CLC
	ROL
	TAX
	LDA		T_Set_Table+1,X
	PHA
	LDA		T_Set_Table,X
	PHA
	RTS

T_Set_Table:
	DW		L_Flag_Set0-1		;;R_Set_Flag=0
	DW		L_Flag_Set1-1		;;R_Set_Flag=1
	DW		L_Flag_Set2-1		;;R_Set_Flag=2
	DW		L_Flag_Set3-1		;;R_Set_Flag=3

L_Flag_Set0:
	BBR1	R_Key_Flag, L_REALSE_CTW7KEY_SecFlag  ;;判断bit1=0?  =0：不是5key，跳转
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		R_CtwInc_Min				;;"分"加
	LDA		R_Stw_Min
	JSR		L_Dis_Digit12
	RTS
L_REALSE_CTW7KEY_SecFlag:
	BBR2	R_Key_Flag,?RTS  ;;判断bit2=0?  =0：不是7key，跳转
	RMB2	R_Key_Flag			;;bit2=1时，清除-->bit2=0
	JSR		R_CtwInc_Sec				;;"秒"加
	LDA		R_Stw_Sec
	JSR		L_Dis_Digit34
	RTS
?RTS:
	rts


L_Flag_Set1:					;;12/24HR
	BBR1	R_Key_Flag, L_REALSE_7KEY_12or24Flag  ;;判断bit1=0?  =0：不是5key，跳转
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		L_REALSE_12or24Flag
	RTS
L_REALSE_7KEY_12or24Flag:
	BBR2	R_Key_Flag,?RTS  	;;判断bit2=0?  =0：不是7key，跳转
	RMB2	R_Key_Flag			;;bit2=1时，清除-->bit2=0
	JSR		L_REALSE_12or24Flag
	RTS
?RTS:
	rts

L_REALSE_12or24Flag:
	LDA		Sys_Flag_B
	EOR		#BIT5
	STA		Sys_Flag_B			;;改变bit5位
	RTS


L_Flag_Set2:
	BBR1	R_Key_Flag, L_REALSE_7KEY_HrFlag  ;;判断bit1=0?  =0：不是5key，跳转
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		F_HrInc				;;"时"加
	JSR		L_Dis_TimeHr
	RTS
L_REALSE_7KEY_HrFlag:
	BBR2	R_Key_Flag,?RTS  ;;判断bit2=0?  =0：不是7key，跳转
	RMB2	R_Key_Flag			;;bit2=1时，清除-->bit2=0
	JSR		F_HrDec				;;"时"减
	JSR		L_Dis_TimeHr
	RTS
?RTS:
	rts

L_Flag_Set3:
	BBR1	R_Key_Flag, L_REALSE_7KEY_MinFlag  ;;判断bit1=0?  =0：不是5key，跳转
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		F_MinInc				;;"分"加
	JSR		L_Dis_TimeHr
	RTS
L_REALSE_7KEY_MinFlag:
	BBR2	R_Key_Flag,?RTS	 ;;判断bit2=0?  =0：不是7key，跳转
	RMB2	R_Key_Flag			;;bit2=1时，清除-->bit2=0
	JSR		F_MinDec				;;"分"减
	JSR		L_Dis_TimeHr
	RTS
?RTS:
	rts
; ;=======================================================	
L_FastAdd_Prog:
	SMB0	Sys_Flag_C			;;标记快加
	LDA		R_Set_Flag
	CLC
	ROL
	TAX
	LDA		T_FastAdd_Table+1,X
	PHA
	LDA		T_FastAdd_Table,X
	PHA
	RTS

T_FastAdd_Table:
	DW		L_FastAdd_Set0-1		;;R_Set_Flag=0
	DW		L_FastAdd_Set1-1		;;R_Set_Flag=1
	DW		L_FastAdd_Set2-1		;;R_Set_Flag=2
	DW		L_FastAdd_Set3-1		;;R_Set_Flag=3

L_FastAdd_Set0:
	BBR1	R_Key_Flag, L_FsatAdd_CTW7KEY_SecFlag  ;;判断bit1=0?  =0：不是5key，跳转
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		R_CtwInc_Min				;;"分"加
	LDA		R_Stw_Min
	JSR		L_Dis_Digit12
	RTS
L_FsatAdd_CTW7KEY_SecFlag:
	BBR2	R_Key_Flag,?RTS  ;;判断bit1=0?  =0：不是7key，跳转
	RMB2	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		R_CtwInc_Sec				;;"秒"加
	LDA		R_Stw_Sec
	JSR		L_Dis_Digit34
	rts
?RTS:
	RTS	
L_FastAdd_Set1:
	rts
L_FastAdd_Set2:
	JSR		F_HrInc				;;"时"加
	JSR		L_Dis_TimeHr
	RTS

L_FastAdd_Set3:
	JSR		F_MinInc				;;"分"加
	JSR		L_Dis_TimeMin
	RTS
; ;=======================================================	
L_FastDec_Prog:
	SMB0	Sys_Flag_C		;;标记快减
	LDA		R_Set_Flag
	CLC
	ROL
	TAX
	LDA		T_FastDec_Table+1,X
	PHA
	LDA		T_FastDec_Table,X
	PHA
	RTS

T_FastDec_Table:
	DW		L_FastDec_Set0-1		;;R_Set_Flag=0
	DW		L_FastDec_Set1-1		;;R_Set_Flag=1
	DW		L_FastDec_Set2-1		;;R_Set_Flag=2
	DW		L_FastDec_Set3-1		;;R_Set_Flag=3

L_FastDec_Set0:
	BBR1	R_Key_Flag, L_FsatAdd_STW7KEY_SecFlag  ;;判断bit1=0?  =0：不是5key，跳转
	RMB1	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		R_CtwInc_Min				;;"分"加
	LDA		R_Stw_Min
	JSR		L_Dis_Digit12
	RTS
L_FsatAdd_STW7KEY_SecFlag:
	BBR2	R_Key_Flag,?RTS  ;;判断bit1=0?  =0：不是7key，跳转
	RMB2	R_Key_Flag			;;bit1=1时，清除-->bit1=0
	JSR		R_CtwInc_Sec				;;"秒"加
	LDA		R_Stw_Sec
	JSR		L_Dis_Digit34
	rts
?RTS:
	RTS

L_FastDec_Set1:
	rts
L_FastDec_Set2:
	JSR		F_HrDec				;;"时"减
	JSR		L_Dis_TimeHr
	RTS

L_FastDec_Set3:
	JSR		F_MinDec				;;"分"减
	JSR		L_Dis_TimeMin
	RTS


;============================================================
Stz_Fast_Hold_Key:
	LDA		#0
	STA		R_Fast_Time
	STA		R_KeyHold_Time
	RTS
;============================================================
;===============================================================
; F_KeyUpdateDis:	
; 	JSR		F_ClearScreen
; 	; JMP		L_Display_Prog
	

; L_Beep_Control_Prog:			;控制声音频率
; 	LDA		Sys_Flag_B	
; 	AND		#BIT2				;静音状态不发出声音
; 	BNE		L_StzVoice
	
; 	LDA     Sys_Flag_B  
;     AND     #BIT3
;     BEQ     L_Set16HzBIT

; 	LDA		Sys_Flag_B
; 	AND		#BIT3_
; 	STA		Sys_Flag_B

	

; 	LDA		R_Voice_Unit
; 	BEQ		L_End_OpenBeep
; 	DEC		R_Voice_Unit
; 	BNE		L_ContinueJudge	
; 	;JSR		L_LightOff
; 	BRA		L_CloseBeep	
; L_ContinueJudge:	
; 	LDA		R_Voice_Unit
; 	AND		#BIT0
; 	BEQ		L_JudgeOpenBeep	;L_OpenBeep	
; 	BRA		L_CloseBeep
; ;	JSR		L_LightOn
; L_StzVoice:
; 	LDA		#0
; 	STA		R_Voice_Unit
; L_CloseBeep:
; 	PB2_PB2_NMOS
; 	PB3_PB3_NMOS
; 	LDA	 #$FF
; 	STA	 P_PB
; 	PWM_OFF
; 	RTS

; L_JudgeOpenBeep:	
; ;	JSR		L_LightOff
; L_OpenBeep:
; 	PB2_PWM
;     LDA	 #$FF
; 	STA	 P_PB
; 	PB3_PWM
; 	PWM_ON

; ?3Key:
;     TONE_4KHZ_3_4_Duty
; 	;TONE_2KHZ_3_4_Duty
; 	;PWM_ON			
; 	RTS
; L_End_OpenBeep:	
; 	RTS

; L_Set16HzBIT:
; 	LDA		Sys_Flag_B
; 	ORA		#BIT3
; 	STA		Sys_Flag_B
; 	RTS
;;--------------------------------------------------------------
;;==============================================================
;;==============================================================
; F_KeyIoPCInputLow:
; 	LDA		PCDIR_TEMP
; 	AND		#00000000B
; 	STA		PCDIR_TEMP
; 	STA		PCDIR
; 	LDA		PC_TEMP
; 	AND		#00000000B
; 	STA		PC_TEMP
; 	STA		PC
; 	NOP
; 	LDA		PCDIR_TEMP
; 	ORA		#00111111B
; 	STA		PCDIR_TEMP
; 	STA		PCDIR
; 	LDA		PC_TEMP
; 	ORA		#00111111B
; 	STA		PC_TEMP
; 	STA		PC	
; 	RTS

; F_KeyIoPCOutputLow:
; 	LDA		PCDIR_TEMP
; 	AND		#00000000B
; 	STA		PCDIR_TEMP
; 	STA		PCDIR
; 	LDA		PC_TEMP
; 	AND		#00000000B
; 	STA		PC_TEMP
; 	STA		PC
; 	RTS


; F_KeyIoPAOutputLow:
; 	LDA		PADIR_TEMP
; 	AND		#11111011B
; 	STA		PADIR_TEMP
; 	STA		PADIR
; 	LDA		PA_TEMP
; 	ORA		#00000100B
; 	STA		PA_TEMP 
; 	STA		PA	
; 	RTS

F_KeyIoPAInputHigh:
	LDA		PADIR_TEMP
	ORA		#10100100B
	STA		PADIR_TEMP
	STA		PADIR	
	LDA		PA_TEMP
	AND		#01011011B
	STA		PA_TEMP
	STA		PA
	RTS	


;;===========================
L_ScanKey_Delay_Prog:		;等待功能，循环
	LDA		#$F0			
	STA		P_Temp
L_Loop_ScanKey_Delay:
	INC		P_Temp
	BNE		L_Loop_ScanKey_Delay
	RTS
;;===========================

;;==========================

;===========================

;=================================================
; Judge_Stw_Ending_Voice:
;     LDA     Sys_Flag_B
;     AND     #BIT4
;     BNE     Judge_Stw_Ending_Voice_AlRun

; 	LDA		R_Key_Flag
; 	AND		#BIT7
; 	BNE		Skip_Then

; 	BRA		Judge_Stw_Ending_Voice_End

; Judge_Stw_Ending_Voice_AlRun:
; 	LDA     Sys_Flag_B
;     AND     #BIT4_
; 	STA		Sys_Flag_B

; 	LDA		#0
; 	STA		R_Beep_Time
; ;	JSR		Judge_F_AlarmBeepControl
; 	LDA		R_KeyValue
; 	CMP		#D_Key4
; 	BNE		Skip_Then

; 	LDA		Sys_Flag_B
; 	ORA		#BIT1
; 	STA		Sys_Flag_B


; ;	JSR		Judge_Alarm_Spl

; 	JSR		F_DisZZ		

;     BRA     Skip_Then
; Skip_Then:
; 	LDA     R_Key_Flag
;     ORA     #BIT7
;     STA     R_Key_Flag

;     SEC
;     RTS
; Judge_Stw_Ending_Voice_End:
;     CLC
;     RTS
; ;===============
; Judge_NoVoice:
; 	LDA		Sys_Flag_B
; 	AND		#BIT2
; 	BEQ		Judge_NoVoice_End
; 	JSR		F_DisMute
; 	RTS
; Judge_NoVoice_End:
; 	JSR		F_ClrMute
; 	RTS
