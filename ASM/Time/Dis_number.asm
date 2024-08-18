L_DisCol_Prog:
	JSR		F_DisCol
	RTS

L_Dis_TimeMin:
	LDA		R_Time_Min
	JSR		L_Dis_Digit34
	RTS


L_Key5_DisHR:
	JSR		F_ClrCol
	JSR		F_ClrAm
	JSR		F_ClrPm
	BBS5	Sys_Flag_B,L_Key5_Dis12HR
	BRA		L_Key5_Dis24HR


		
L_Key5_Dis24HR:
	LDA		#2
	LDX		#lcd_d1
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDA		#4
	LDX		#lcd_d2
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDA		#76H
	LDX		#lcd_d3
	JSR		F_DispPro
	LDA		#50H
	LDX		#lcd_d4
	JSR		F_DispPro
	RTS

L_Key5_Dis12HR:
	LDA		#1
	LDX		#lcd_d1
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDA		#2
	LDX		#lcd_d2
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDA		#76H
	LDX		#lcd_d3
	JSR		F_DispPro
	LDA		#50H
	LDX		#lcd_d4
	JSR		F_DispPro
	RTS


