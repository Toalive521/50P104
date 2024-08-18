

;===========================================================
;LCD_RamAddr		equ		RamStarAddr
;===========================================================
F_FillScreen:
	LDA		#0FFH
	BNE		L_FillLcd
F_ClearScreen:
	LDA		#0
L_FillLcd:
	LDX		#0
L_FillLcd_1:          
   STA		LCD_RamAddr+0*6,X       ;;COM0
   STA		LCD_RamAddr+1*6,X       ;;COM1
   STA		LCD_RamAddr+2*6,X       ;;COM2
   STA		LCD_RamAddr+3*6,X       ;;COM3
;   STA		Lcd_RamAddr+4*6,x       ;;COM4
;   STA		Lcd_RamAddr+5*6,x       ;;COM5
   INX
   CPX    	#6                                      
   BCC    	L_FillLcd_1
	; STA		0200H
	; STA		0201H
	; STA		0208H
	; STA		0209H
	; STA		0210H
	; STA		0211H
	; STA		0218H
	; STA		0219H
	RTS


;===========================================================
;程序功能：	显示8BIT字段
;程序入口：	A =  显示内容
;			X =  ofc	
;影响资源：P_Temp，P_Temp+1，P_Temp+2，P_Temp+3,X，A
;===========================================================
L_Dis_8Bit_DigitDot_Prog:
;	STA		P_Temp
;	LDA		Table_Digit_Add   r_Offset,X
	STX		P_Temp+1
	TAX
	LDA		Table_Digit_DataDot,X
	LDX		P_Temp+1
F_DispPro:	
	STA		P_Temp
	STX		P_Temp+1	;
	LDA		#7
	STA		P_Temp+3	;显示段数
L_Judge_Dis_8Bit_DigitDot:
	LDX		P_Temp+1
	LDA		lcd_bit,X
	STA		P_Temp+2
	LDA		lcd_byte,X
	TAX
	ROR		P_Temp
	BCC		L_CLR
	LDA		LCD_RamAddr,X
	ORA		P_Temp+2
	STA		LCD_RamAddr,X
	BRA		L_Inc_Dis_Index_Prog
L_CLR:	
	LDA		LCD_RamAddr,X
	ORA		P_Temp+2
	EOR		P_Temp+2
	STA		LCD_RamAddr,X
L_Inc_Dis_Index_Prog:
	INC		P_Temp+1
	DEC		P_Temp+3
	BNE		L_Judge_Dis_8Bit_DigitDot
	RTS
	
F_DispPro_8bit:
	STA		P_Temp
	STX		P_Temp+1
	LDA		#8
	STA		P_Temp+3	;显示段数
	BRA		L_Judge_Dis_8Bit_DigitDot
;-----------------------------------------
F_DispSymbol:		;input Xcc -> ofs
;	LDA		Lcd_bit,X
;	STA		P_Temp+2
;	LDA		Lcd_byte,X
;	TAX
;	LDA		LCD_RamAddr,X
;	ORA		P_Temp+2
	JSR		F_DispSymbol_Com
	STA		LCD_RamAddr,X
	RTS
;-----------------------------------------
F_ClrpSymbol:		;input Xcc -> ofs
;	LDA		Lcd_bit,X
;	STA		P_Temp+2
;	LDA		Lcd_byte,X
;	TAX
;	LDA		LCD_RamAddr,X
;	ORA		P_Temp+2
	JSR		F_DispSymbol_Com
	EOR		P_Temp+2
	STA		LCD_RamAddr,X
	RTS

F_DispSymbol_Com:	
	LDA		lcd_bit,X
	STA		P_Temp+2
	LDA		lcd_byte,X
	TAX
	LDA		LCD_RamAddr,X
	ORA		P_Temp+2
	RTS
;============================================================
;==================================== ===========
L_ROR_4Bit_Prog:
L_ROR4Bit_Prog:
L_LSR4Bit_Prog:
F_MSBToLSB:
	ROR		
	ROR		
	ROR		
	ROR		
	AND		#$0F
	RTS
;================================================
;********************************************	
Table_Digit_DataDot:	;显示内容对应显示的段码
	.BYTE 	3fh	;0
	.BYTE	06h	;1
	.BYTE	5bh	;2
	.BYTE	4fh	;3
	.BYTE	66h	;4
Tab_S:	
Char_S  .EQU	Tab_S-Table_Digit_DataDot 	
	.BYTE	6dh	;5
	.BYTE	7dh	;6
	.BYTE	07h	;7			;带钩	27h	;7
	.BYTE	7fh	;8
	.BYTE	6fh	;9
	.BYTE	00h	; 		;A
	.BYTE	40h	;负号	;B
	.BYTE	77h	;A		;C	
	.BYTE	38h	;L		;D
	.BYTE	76h	;H		;E
	.BYTE	50H	;r		;F
	;.BYTE	01H	;test
Tab_C:	
Char_C  .EQU	Tab_C-Table_Digit_DataDot 	
	.BYTE	39h	;C		;10	
	.BYTE	71h	;F		;11
Tab_A:	
Char_A	.EQU	Tab_A-Table_Digit_DataDot
	.BYTE	77h	;A		;12
Tab_P:	
Char_P  .EQU	Tab_P-Table_Digit_DataDot 		
	.BYTE	73h	;P		;13
Tab_o:	
Char_o  .EQU	Tab_o-Table_Digit_DataDot 	
	.BYTE	5Ch	;o		;14
Tab_n:	
Char_n  .EQU	Tab_n-Table_Digit_DataDot 	
	.BYTE	54h	;n		;15
;-----------------------------------------------------------	
