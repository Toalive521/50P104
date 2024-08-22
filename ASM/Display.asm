;===========================================================
 ;;;;;;;;;;;;;;;;;;;;Display Program;;;;;;;;;;;;;;;;;;;;;;;;
;===========================================================
; To_Timer:
; 	JSR		L_Dis_Time
; 	BRA		L_End_Mode_Prog
; To_Stw:
; 	JSR		L_Dis_Stw_Mode
; 	BRA		L_End_Mode_Prog
; To_AL:
; 	JSR		L_Dis_Al_Mode
; 	BRA		L_End_Mode_Prog



;lcd_alarm
; L_Mode_Prog:
; 	LDA		R_Mode
; 	JSR		Judge_Alarm_Start
; 	JSR		Judge_NoVoice

; 	JSR		Judge_Alarm_T1_Flash

; 	LDA		R_Mode
; 	CMP		#D_Time_Mode
; 	BEQ		To_Timer	
; 	CMP		#D_Stw_Mode
; 	BEQ		To_Stw
; 	CMP		#D_Al_Mode
; 	BEQ		To_AL
	
	
L_End_Mode_Prog:
	RTS


; L_Display_Prog:
; 	JMP		L_Mode_Prog

;========================================

L_STWDisplay_Prog:
	JSR		F_ClrAm
	JSR		F_ClrPm
	JSR		F_DisCol
	JSR		F_DisMs

	LDA		R_Stw_Min
	JSR		L_Dis_Digit12
	LDA		R_Stw_Sec
	JSR		L_Dis_Digit34
	RTS

F_DisCol:
	LDX		#lcd_col
	JMP		F_DispSymbol	;显示 两点
F_ClrCol:
	LDX		#lcd_col
	JMP		F_ClrpSymbol

F_Clr12:
	LDA		#0AH
	LDX		#lcd_d1
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDA		#0AH
	LDX		#lcd_d2
	JMP		L_Dis_8Bit_DigitDot_Prog

F_Clr34:
	LDA		#0AH
	LDX		#lcd_d3
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDA		#0AH
	LDX		#lcd_d4
	JMP		L_Dis_8Bit_DigitDot_Prog

F_DisAm:
	LDX		#lcd_am
	JMP		F_DispSymbol	;显示AM
F_ClrAm:
	LDX		#lcd_am
	JMP		F_ClrpSymbol


F_DisPM:
	LDX		#lcd_pm
	JMP		F_DispSymbol	;显示PM
F_ClrPm:
	LDX		#lcd_pm
	JMP		F_ClrpSymbol

F_DisMs:
	LDX		#lcd_ms
	JMP		F_DispSymbol	;显示MS


F_ClrMs:
	LDX		#lcd_ms
	JMP		F_ClrpSymbol		
; F_DisClock:
; 	LDX		#lcd_clock
; 	JMP		F_DispSymbol	;显示时钟图标

; F_DisMute:
; 	LDX		#lcd_mute
; 	JMP		F_DispSymbol	;显示 静音 图标

; F_DisTime_end:
; 	LDX		#lcd_time_end
; 	JMP		F_DispSymbol	;显示时间到图标

; F_DisTimekeeping:
; 	LDX		#lcd_timekeeping
; 	JMP		F_DispSymbol	;显示计时图标

; F_DisStwOne:
; 	LDX		#lcd_StwOne
; 	JMP		F_DispSymbol

; F_DisStwTwo:
; 	LDX		#lcd_StwTwo
; 	JMP		F_DispSymbol

; F_DisZZ:
; 	LDX		#lcd_ZZ
; 	JMP		F_DispSymbol

; F_DisForward:
; 	LDX		#lcd_forward
; 	JMP		F_DispSymbol	;显示 正 图标

; F_DisT1:
; 	LDX		#lcd_T1
; 	JMP		F_DispSymbol	;显示时间到图标
; ;=========================================
; F_ClrClock:
; 	LDX		#lcd_clock
; 	JMP		F_ClrpSymbol	;清除时钟图标
	
; F_ClrMute:
; 	LDX		#lcd_mute
; 	JMP		F_ClrpSymbol	;清除 静音 图标	

; F_ClrTime_end:
; 	LDX		#lcd_time_end
; 	JMP		F_ClrpSymbol	;清除时间到图标

; F_ClrTimekeeping:
; 	LDX		#lcd_timekeeping
; 	JMP		F_ClrpSymbol	;清除计时图标

; F_ClrStwOne:
; 	LDX		#lcd_StwOne
; 	JMP		F_ClrpSymbol

; F_ClrStwTwo:
; 	LDX		#lcd_StwTwo
; 	JMP		F_ClrpSymbol

; F_ClrZZ:
; 	LDX		#lcd_ZZ
; 	JMP		F_ClrpSymbol

; F_ClrForward:
; 	LDX		#lcd_forward
; 	JMP		F_ClrpSymbol	;清除 正 图标

; F_ClrT1:
; 	LDX		#lcd_T1
; 	JMP		F_ClrpSymbol	;显示时间到图标
;==========================================
;L_Judge_ClrAllDis:
;	LDA		R_Bop
;	BEQ		L_5Alarm_ClrAllDis
;	CMP		#D_Num
;	BEQ		L_Numtimer_ClrAllDis
;	CMP		#D_Timer5
;	BCC		L_4Timer_ClrAllDis
;	LDX		#lcd_alarm
;	JSR		F_ClrpSymbol

;	LDX		#lcd_motor
;	JSR		F_ClrpSymbol	
;	RTS
	
;L_5Alarm_ClrAllDis:
;	LDX		#lcd_t1_t
;	JSR		F_ClrpSymbol
;	LDX		#lcd_t2_t
;	JSR		F_ClrpSymbol
;	LDX		#lcd_t3_t
;	JSR		F_ClrpSymbol
;	LDX		#lcd_t4_t
;	JSR		F_ClrpSymbol
;	LDX		#lcd_t5_t
;	JSR		F_ClrpSymbol
;	LDX		#lcd_timer
;	JSR		F_ClrpSymbol
;	LDX		#lcd_up
;	JSR		F_ClrpSymbol
;	LDX		#lcd_down
;	JMP		F_ClrpSymbol
	
;L_4Timer_ClrAllDis:
;	LDX		#lcd_motor
;	JSR		F_ClrpSymbol

;	LDX		#lcd_alarm
;	JSR		F_ClrpSymbol
;	LDX		#lcd_t5_t
;	JSR		F_ClrpSymbol	
;	LDX		#lcd_t5_5
;	JSR		F_ClrpSymbol
;	LDX		#lcd_al5
;	JMP		F_ClrpSymbol

L_Numtimer_ClrAllDis:
	LDA		#0
	STA		0201H	
	STA		0202H
	STA		0209H
	LDA		#$80
	STA		0203H
	LDA		#$FE
	STA		020AH
	STA		0212H
	RTS
;==========================================
L_Dis_Digit_AlHr:
L_Dis_Digit_TimeHr:
L_Dis_Digit_TimeMonth:
L_Dis_Digit_TimerHr:
L_Dis_Digit12:
	LDX		#lcd_d1
	PHA
	JSR		L_ROR_4Bit_Prog
	; TAX
	; LDA		Lcd_1_table,X
	LDX		#lcd_d1
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDX		#lcd_d2
	PLA
	
	AND		#$0F
	JMP		L_Dis_8Bit_DigitDot_Prog
	;BRA		F_Dis_2Digit
;=====================================================
;=====================================================
L_Dis_Digit_AlMin:
L_Dis_Digit_TimeMin:
L_Dis_Digit_TimeDay:
L_Dis_Digit_TimerMin:
L_Dis_Digit34:
	LDX		#lcd_d3
	BRA		F_Dis_2Digit
;===============================================
L_Dis_Digit_AlSec:
L_Dis_Digit_TimeSec:
L_Dis_Digit_TimerSec:
L_Dis_Digit56:
; 	LDX		#lcd_d5
; ;	BRA		F_Dis_2Digit
F_Dis_2Digit:
	PHA
	JSR		L_ROR_4Bit_Prog
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDX		P_Temp+1
	PLA
	AND		#$0F
	JMP		L_Dis_8Bit_DigitDot_Prog
;===========================================================
 ;;;;;;;;;;;;;;;;;;;;Flash Program;;;;;;;;;;;;;;;;;;;;;;;;
;===========================================================		
;F_1Hz_Flash_Prog:
;	LDA		R_Bop
;	BEQ		L_1Hz_Flash_5Alarm
;	CMP		#D_Num
;	BEQ		L_1Hz_Flash_Num
;L_1Hz_Flash_45Timer:
;	JMP		L_Flash_Prog_5Timer
;L_1Hz_Flash_5Alarm:
;	JMP		L_Flash_Prog_5Alarm
;L_1Hz_Flash_Num:
;	JMP		L_Flash_Prog_Number

L_Flash_Digit3:
	LDX		#lcd_d3
L_Flash_Digit:	
	LDA		#$0A
	JMP		L_Dis_8Bit_DigitDot_Prog
L_Flash_Digit4:	
	LDX		#lcd_d4
	BRA		L_Flash_Digit
; L_Flash_Digit5:	
; 	LDX		#lcd_d5
; 	BRA		L_Flash_Digit
; L_Flash_Digit6:	
; 	LDX		#lcd_d6
; 	BRA		L_Flash_Digit	
	
L_Flash_Digit12:
	LDA		#$AA
	JMP		L_Dis_Digit12
L_Flash_Digit34:
	LDA		#$AA
	JMP		L_Dis_Digit34
L_Flash_Digit56:
	LDA		#$AA
	JMP		L_Dis_Digit56	
	
L_Flash_Digit23:
	LDA		#$AA
	LDX		#lcd_d2
	JMP		F_Dis_2Digit
;============================================================
;============================================================
Lcd_1_table:
	.BYTE 	00h	;0
	.BYTE	06h	;1
	.BYTE	03h	;2




;============================================================