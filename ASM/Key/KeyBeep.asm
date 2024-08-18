Judge_Key6_Beep:
    LDA     Sys_Flag_B
    AND     #BIT2
    BNE     Judge_Key6_Beep_End     ;静音状态下不响

    LDA     R_Key_Flag
    AND     #BIT6
    BNE		Judge_Key6_Beep_End     ;长按不响

    LDA     R_Stw_Flag
    AND     #BIT7
    BNE     Judge_Key6_Beep_End     ;秒表计时到后不响

    JSR     F_KeyBeep
Judge_Key6_Beep_End:
    RTS
;============================================================

Judge_Key5_Beep:
    LDA     Sys_Flag_B
    AND     #BIT2
    BNE     Judge_Key5_Beep_End     ;静音状态下不响

    LDA     R_Key_Flag
    AND     #BIT6
    BNE		Judge_Key5_Beep_End     ;长按不响

    LDA     R_Stw_Flag
    AND     #BIT7
    BNE     Judge_Key5_Beep_End     ;秒表计时到后不响

    LDA     R_Mode
    CMP     #D_Stw_Mode
    BNE     Key5_Mode1_End

    JSR     Judge_Key5_Lock_Stw   ;
    BCS     Judge_Key5_Beep_End
;    LDA     R_Stw_Flag
;    AND     #BIT0
;    BNE     Judge_Key5_Beep_End     ;Stw模式下计时开始后不响
Key5_Mode1_End:

;     LDA     R_Mode
;     CMP     #D_StwDay_Mode
;     BNE     Key5_Mode4_End
    
    LDA     R_Mode
    CMP     #D_Al_Mode
    BEQ     Judge_Key5_Beep_End
;     LDA     R_Bop
;     CMP     #D_Num
;     BNE     Key5_Mode4_Nor_End     ;天计时模式下常规模式�?
;     BRA     Key5_Beep_Open
; Key5_Mode4_Nor_End: 
;     B RA     Key5_Beep_Open         ;62-71为废代码，供后续开发使�?

; Key5_Mode4_End:

Key5_Beep_Open:
    JSR     F_KeyBeep
Judge_Key5_Beep_End:
    RTS
;============================================================

Judge_Key4_Beep:
    LDA     Sys_Flag_B
    AND     #BIT2
    BNE     Judge_Key4_Beep_End     ;静音状态下不响

    LDA     R_Key_Flag
    AND     #BIT6
    BNE		Judge_Key4_Beep_End     ;长按不响

    ; LDA     R_Key_Flag
    ; AND     #BIT3
    ; BEQ     Judge_Key4_Beep_End     ;锁定时不�?


    LDA     R_Stw_Flag
    AND     #BIT7
    BNE     Judge_Key4_Beep_End     ;秒表计时到后不响
Key4_Mode4_Nor_End: 
    
Key4_Mode4_End:


Key4_Beep_Open:
    JSR     F_KeyBeep
Judge_Key4_Beep_End:
    RTS
;============================================================

Judge_Key3_Beep:
    LDA     Sys_Flag_B
    AND     #BIT2
    BNE     Judge_Key3_Beep_End     ;静音状态下不响

    LDA     R_Key_Flag
    AND     #BIT6
    BNE		Judge_Key3_Beep_End     ;长按不响

    LDA     Sys_Flag_A
    AND     #BIT6
    BNE     Judge_Key3_Beep_End     ;锁定时不�?

    LDA     R_Stw_Flag
    AND     #BIT7
    BNE     Judge_Key3_Beep_End     ;秒表计时到后不响

Key3_Mode1_End:

    
Key3_Mode4_Nor_End: 
    
Key3_Mode4_End:

Key3_Beep_Open:
    JSR     F_KeyBeep
Judge_Key3_Beep_End:
    RTS
;============================================================

Judge_Key2_Beep:
    LDA     Sys_Flag_B
    AND     #BIT2
    BNE     Judge_Key2_Beep_End     ;静音状态下不响

    LDA     R_Key_Flag
    AND     #BIT6
    BNE		Judge_Key2_Beep_End     ;长按不响

    LDA     Sys_Flag_A
    AND     #BIT6
    BNE     Judge_Key2_Beep_End     ;锁定时不�?

    LDA     R_Stw_Flag
    AND     #BIT7
    BNE     Judge_Key2_Beep_End     ;秒表计时到后不响


Key2_Mode1_End:

    

    
Key2_Mode4_Nor_End: 
    
Key2_Mode4_End:

Key2_Beep_Open:
    JSR     F_KeyBeep
Judge_Key2_Beep_End:
    RTS
;============================================================

Judge_Key1_Beep:
    LDA     Sys_Flag_B
    AND     #BIT2
    BNE     Judge_Key1_Beep_End     ;静音状态下不响

    LDA     R_Key_Flag
    AND     #BIT6
    BNE		Judge_Key1_Beep_End     ;长按不响

    LDA     Sys_Flag_A
    AND     #BIT6
    BNE     Judge_Key1_Beep_End     ;锁定时不�?

    LDA     R_Stw_Flag
    AND     #BIT7
    BNE     Judge_Key1_Beep_End     ;秒表计时到后不响

Key1_Mode1_End:
    
    
Key1_Mode4_Nor_End: 

Key1_Mode4_End:

Key1_Beep_Open:
    JSR     F_KeyBeep
Judge_Key1_Beep_End:
    RTS

;============================================================
F_KeyBeep:					;按键�?
	LDA		Sys_Flag_B
	AND		#BIT2
	BNE		L_End_KeyBeep
	LDA		#3
	STA		R_Voice_Unit
L_End_KeyBeep:
	RTS