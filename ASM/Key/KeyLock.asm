Judge_Lock_Key6:   ;6号键 模式键  
;    LDA     R_Al_Flag
;    AND     #(BIT4+BIT5)    
;    BNE     Stop_Alarm      ;有闹钟时按键关闭闹钟 不行使功能

    JSR     Change_Key_BIT3 ;行使功能即解除锁定状态
    BRA     Judge_Lock_Key_End
;============================================================
Judge_Lock_Key5:    ;5号键 清除键
;    LDA     R_Al_Flag
;    AND     #(BIT4+BIT5)    
;    BNE     Stop_Alarm      ;有闹钟时按键关闭闹钟 不行使功能

    ;LDA     R_Key_Flag                  ;锁定状态下行使功能但不解除锁定
    ;AND     #BIT3
    ;BEQ     Judge_Lock_Key_End
    JSR     Judge_Key5_Lock_Stw  ;
    BCS     Lock_Key_Bit3
    
    JSR     Change_Key_BIT3
    BRA     Judge_Lock_Key_End 

;============================================================
Judge_Lock_Key4:       ;4号键 开始/停止键
;    LDA     R_Al_Flag
;    AND     #(BIT4+BIT5)    
;    BNE     Stop_Alarm      ;有闹钟时按键关闭闹钟 不行使功能

    LDA     R_Key_Flag
    AND     #BIT3
    BEQ     Judge_Lock_Key_End         ;锁定状态下行使功能但不解除锁定

    JSR     Change_Key_BIT3
    BRA     Judge_Lock_Key_End 
;============================================================
Judge_Lock_Key3:        ;3号键 秒键
;    LDA     R_Al_Flag
;    AND     #(BIT4+BIT5)    
;    BNE     Stop_Alarm      ;有闹钟时按键关闭闹钟 不行使功能


    LDA     Sys_Flag_A
    AND     #BIT6
    BNE     Lock_Key_Bit3       ;15秒锁定时不行使功能

    BRA     Judge_Lock_Key_End         

;============================================================
Judge_Lock_Key2:               ;2号键 分键
;    LDA     R_Al_Flag
;    AND     #(BIT4+BIT5)    
;    BNE     Stop_Alarm      ;有闹钟时按键关闭闹钟 不行使功能
    LDA     Sys_Flag_A
    AND     #BIT6
    BNE     Lock_Key_Bit3       ;15秒锁定时不行使功能

    BRA     Judge_Lock_Key_End         

;============================================================
Judge_Lock_Key1:             ;1号键 时键
;    LDA     R_Al_Flag
;    AND     #(BIT4+BIT5)    
;    BNE     Stop_Alarm      ;有闹钟时按键关闭闹钟 不行使功能
    
    LDA     Sys_Flag_A
    AND     #BIT6
    BNE     Lock_Key_Bit3       ;15秒锁定时不行使功能
    
    BRA     Judge_Lock_Key_End
;====================================================
Stop_Alarm:                 ;stop alarm
;    JSR     Stop_Alarm_Beep
Lock_Key_Bit3:
    SEC             ;设置进位标志用于 跳过功能 
    RTS
Judge_Lock_Key_End:
    CLC
    RTS             ;清除进位标志用于 行使功能

;============================================================
Change_Key_BIT3:            ;开启锁计时
	LDA		R_Key_Flag
	ORA		#BIT3
	STA		R_Key_Flag		;KeyFlag BIT3设为1
    LDA     #0
	STA		R_Num
Change_Key_BIT3_End:
	RTS
;====================================================
Judge_Key_Lock_StwStar:         ;倒计时开始后，计时模式时分秒键不能用
    LDA     R_Mode
    CMP     #D_Stw_Mode
    BNE     Judge_Key_Lock_StwStar_End

    LDA     R_Stw_Flag
    AND     #BIT3
    BEQ     Judge_Key_Lock_StwStar_End   

    SEC
    RTS
Judge_Key_Lock_StwStar_End:
    CLC
    RTS
;====================================================
Judge_Key_Lock_Alarm:


Judge_Key_Lock_Alarm_End:
    CLC
    RTS
;====================================================

