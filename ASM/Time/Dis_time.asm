;==========================================
L_Dis_Time_Mode:
;T_DisTimeSetTable:
;	.word	L_Dis_TimeOrDate-1
;	.word	L_Dis_Time-1
;	.word	L_Dis_Time-1
;	.word	L_Dis_Time-1
;	.word	L_Dis_Date-1
;	.word	L_Dis_Date-1
;	.word	L_Dis_Date-1	


L_Dis_Time:
	JSR		F_DisCol
L_Dis_TimeHr:
	LDA		R_Time_Hr
	JMP		L_Dis_Hr_Common

L_Dis_Hr_Common:
	STA		P_Temp+4
	LDA		Sys_Flag_B
	AND		#BIT5
	BEQ		L_Dis_TimeHr_24
	SEC
	SED
	LDA		P_Temp+4	
	SBC		#$12
	CLD
	BCC		L_Dis_Hour_12AM
	STA		P_Temp+4
	LDX		#lcd_am
	JSR		F_ClrpSymbol
	LDX		#lcd_pm
	JSR		F_DispSymbol
	BRA		L_TimeHr_0To12	
L_Dis_Hour_12AM:
	LDX		#lcd_am
	JSR		F_DispSymbol
	LDX		#lcd_pm
	JSR		F_ClrpSymbol
L_TimeHr_0To12:	
	LDA		P_Temp+4
	BNE		L_Dis_HourDate_Prog
	LDA		#$12
	STA		P_Temp+4
	BRA		L_Dis_HourDate_Prog
L_Dis_TimeHr_24:
	LDX		#lcd_am
	JSR		F_ClrpSymbol
	LDX		#lcd_pm
	JSR		F_ClrpSymbol
L_Dis_HourDate_Prog:
	JSR		L_HighBitDealWith
	LDX		#lcd_d1
	LDA		P_Temp+4
	JMP		L_Dis_Digit12		

L_HighBitDealWith:
	LDA		P_Temp+4
	AND		#$F0
	BNE		L_Exit_HighBitDealWith

	LDA		P_Temp+4
	ORA		#$A0
	STA		P_Temp+4
L_Exit_HighBitDealWith:
	RTS	
; ;=====================================================
;L_TimeHrDealwith:
;	lda		R_Time_Hr
;	beq		Load12
;	cmp		#$12
;	beq		L_End_TimeHrDealwith
;	bcc		L_End_TimeHrDealwith
;	sec
;	sed
;	sbc		#$12
;	CLD	
;	rts
;Load12:
;	lda		#$12
;L_End_TimeHrDealwith:	
;	rts
; ;=====================================================
; ;L_Dis_TimeOrDate:
; ;	LDA		Sys_Flag_B
; ;	AND		#BIT1
; ;	BEQ		L_Dis_Time
; ;;=====================================================
; ;L_Dis_Date:
; ;	LDX		#lcd_date
; ;	JSR		F_DispSymbol
; ;
; ;	JSR		L_Dis_TimeDay
; ;	JMP		L_Dis_TimeMonth
; ;=====================================================
; L_Dis_TimeSec:
; 	LDA		R_Time_Sec
; 	JMP		L_Dis_Digit_TimeSec
	
; L_Dis_TimeMin:
; 	LDA		R_Time_Min
; 	JMP		L_Dis_Digit_TimeMin
;	
;L_Dis_TimeDay:
;	LDA		R_Day
;	PHA
;	AND		#$F0
;	BNE		L_Skip_Dis_TimeDay
;;	LDA		R_Day
;	PLA
;	ORA		#$A0
;	JMP		L_Dis_Digit_TimeDay
;L_Skip_Dis_TimeDay:
;;	LDA		R_Day
;	PLA
;	JMP		L_Dis_Digit_TimeDay
;	
;L_Dis_TimeMonth:
;	LDA		R_Month
;	JMP		L_Dis_Digit_TimeMonth

;L_Dis_TimeYear:
;	LDA		R_Year
;	JMP		L_Dis_Digit_TimeYear	
;===============================================
;F_JudgeDisWeek:
;;	LDA		R_Mode
;;	BNE		F_DisAllWeek
;;	LDA		R_Set
;;	BEQ		F_DisWeek
;;	CMP		#4
;;	BCC		F_DisAllWeek
;F_DisWeek:
;	LDX		R_Week
;	LDA		TabWeek,X
;L_DisWeek_Com:	
;	LDX		#lcd_Week
;	JMP		F_DispPro
;TabWeek:
;	.BYTE	$01,$02,$04,$08,$10,$20,$40,$01
;	
;;F_DisAllWeek:
;;	LDA		#$7F
;;	LDX		#lcd_Week
;;	JMP		F_DispPro
;
;L_FlashWeek:
;	LDA		#$00
;	BRA		L_DisWeek_Com
;===============================================