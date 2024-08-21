;********************************************************
.CHIP           W65C02S
;.INCLIST        ON
.MACLIST        ON
;********************************************************
;Project Name:  
;CPU            
;Start  Date:   
;Finish Date:
;********************************************************

;********************************************************
CODE_BEG        EQU     0F000H
;********************************************************

;********************************************************
PROG    SECTION OFFSET  CODE_BEG
;********************************************************

;********************************************************
; header include
;********************************************************
;.INCLUDE 50X105.H
.INCLUDE 50P104.H
.INCLUDE RAM.inc
.INCLUDE MACRO.MAC
;.INCLUDE 50X105.MAC
.INCLUDE 50P104.MAC
;********************************************************
STACK_BOT       EQU     FFH
;********************************************************
.PROG
V_RESET:
    NOP
    NOP
    NOP
    SEI
    LDX     #STACK_BOT  
    TXS
    LDA     #$07    
    STA     P_SYSCLK    ;Fcpu=560K, Fext=32768,Strong ,Fosc/1
    ClrAllRam               
    JSR     L_InitSPR_Prog
    JSR     F_FillScreen
    LCD_ON
    TMR1_ON
    EN_TMR1_IRQ 
    LDA     P_FUSE0
    STA     P_MF0
    STA     P_HALT
    NOP
    NOP
    NOP     
    RMB2    P_IFR
    STA     P_HALT
    NOP
    NOP
    NOP     
    RMB2    P_IFR
    STA     P_HALT
    NOP
    NOP
    NOP     
    RMB2    P_IFR   
    WDTC_CLR
    Fsys_Fosc_1
    EN_LCD_IRQ
     ; JSR     Change_Key_BIT3
    
    LDA	    #$FF
	STA	    P_PB
    ; JSR     F_KeyBeep
    ; JSR     F_KeyLight
    ; JSR     L_Beep_Control_Prog

    LDA     #10100100B
    STA     P_PA_WAKE

    LDA     #0
    STA     R_Mode_Flag

    LDA     #0
    STA     R_Set_Flag

    LDA     #$5
    STA     R_Stw_Min
    ; LDA     #$00
    ; STA     R_Stw_Sec

    LDA     #0
    STA     P_Temp+6
    STA     P_Temp+7
    STA     P_Temp+5
    JSR     F_ClearScreen
;    JSR     F_KeyUpdateDis
   
    CLI

;--------------------------------------------------------
Mainloop:

    JSR     L_2Hz_Prog
    JSR     L_32Hz_Prog


;     RMB2    P_WDTC          ;CLR_WDTC
; ;    JSR     L_Mode_Prog
;     ; JSR     L_32Hz_Prog
    
    BBS7    P_TMRC,Mainloop
    ; LDA     R_Light_Unit
    ; BNE     Mainloop
    Fsys_Fosc_2
    STA     P_HALT
    JSR     L_Judge_32hz
    NOP
    NOP
    NOP
    Fsys_Fosc_1
    JMP     Mainloop

L_Judge_32hz:
    LDA     PA
    EOR     #10100100B 
    AND     #10100100B
    BEQ     ?OFF
    EN_LCD_IRQ

?OFF:
    RTS
;--------------------------------------------------------
.INCLUDE    Init.asm
.INCLUDE    Disp.asm
.INCLUDE    Lcdtab.asm
; .include    Key\KeyBeep.asm
.include    Key\KeyScan.asm
; .include    Key\KeyNumb.asm
; .include    Key\KeyLock.asm
; .include    Key\KeyShort.asm
; .include    Key\KeyLong.asm

.include    Half_S.asm  
.include    Display.asm
.include    Time\Dis_number.asm
.include    Time\Time.asm
.include    Time\Dis_time.asm
; .include    stw\Stw.asm
; .include    stw\Dis_stw.asm
; .include    Day_Ctw\Dayctw.asm
; .include    Day_Ctw\Dis_Day.asm
; .include    Alarm\Al.asm
; .include    Alarm\Dis_al.asm
; .include    Test\Test.asm
;.include    Time\Tool.asm


;--------------------------------------------------------
; ISR
;--------------------------------------------------------
V_IRQ:
    PHA
    TXA
    PHA
    LDA     P_IER
    AND     P_IFR           
    STA     R_Int_Backup
;   AND     #$01
;   BNE     L_Div_IRQ_Prog
;   LDA     R_Int_Backup
;   AND     #$02
;   BNE     L_Timer0_IRQ_Prog
;   LDA     R_Int_Backup
    AND     #$04
    BNE     L_Timer1_IRQ_Prog
    LDA     R_Int_Backup
    AND     #$10
    BNE     L_PA_IRQ_Prog
    LDA     R_Int_Backup
    AND     #$40
    BNE     L_LCD_IRQ_Prog
    JMP     L_End_IRQ_Prog
L_Div_IRQ_Prog:
    RMB0    P_IFR           
    JMP     L_End_IRQ_Prog
    
L_Timer0_IRQ_Prog:
    RMB1    P_IFR           
    JMP     L_End_IRQ_Prog
    
L_Timer1_IRQ_Prog:
    RMB2    P_IFR           
;   SMB0    Sys_Flag_A      ;Half Second Flag

    LDA     Sys_Flag_A
    ORA     #BIT0               ;2hz
    STA     Sys_Flag_A
    JMP     L_End_IRQ_Prog
    
L_PA_IRQ_Prog:
    RMB4    P_IFR
    DIS_PA_IRQ   
    EN_LCD_IRQ                  
    JMP     L_End_IRQ_Prog
    
L_LCD_IRQ_Prog:
    RMB6    P_IFR           
;   SMB2    Sys_Flag_A
    LDA     Sys_Flag_A
    ORA     #BIT2
    STA     Sys_Flag_A      ;32HZ
L_End_IRQ_Prog:
    BBS2    P_IFR,L_Timer1_IRQ_Prog
    PLA
    TAX 
    PLA
    RTI
;--------------------------------------------------------
; Interrupt vector
;--------------------------------------------------------
    .BLKB   $FFD5-$,$1A
    .ORG    0FFD5H  
    JMP     V_RESET
    .BLKB   $FFFF-$,$FF
    .ORG    0FFF8H  
    DB      10110111B      ;;bit7=1 bit6=0  bit3=0
    ; DB      10111111B   ;bit6=1:PB23 CMOS L;BIT0=1 Unprotected


    .ORG    0FFFCH
    DW      V_RESET
    DW      V_IRQ
    .ENDS
     END
;--------------------------------------------------------
