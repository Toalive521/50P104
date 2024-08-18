L_DToHx_Prog:			;十进制转十六进制程序
	STA		P_Temp+6
	AND		#$F0
	STA		P_Temp+7
	LDA		#$0F
	AND		P_Temp+6
	STA		P_Temp+6
L_Loop_DToHx_Prog:
	LDA		P_Temp+7
	BEQ		L_End_DToHx_Prog
	SEC
	SBC		#$10
	STA		P_Temp+7
	CLC
	LDA		#$0A
	ADC		P_Temp+6
	STA		P_Temp+6
	BRA		L_Loop_DToHx_Prog
L_End_DToHx_Prog:
	LDA		P_Temp+6
	RTS



L_HxToD_Prog:			;十六进制转十进制程序
	STA		P_Temp+6
	AND		#$F0
	STA		P_Temp+7
	LDA		#$0F
	AND		P_Temp+6
	STA		P_Temp+6

L_Loop_Low_HxToD:
    LDA     P_Temp+6
    CMP     #10
    BCC     L_Loop_High_HxToD
    CLC
    LDA     #010h
    ADC     P_Temp+6
    STA     P_Temp+6
    BRA     L_Loop_Low_HxToD
L_Loop_High_HxToD:
    LDA		P_Temp+7
	BEQ		L_End_HxToD_Prog
    SEC
    SBC     #010h
    STA     P_Temp+7
    CLC
    SED
    LDA     #016h
    ADC     P_Temp+6
    STA		P_Temp+6
    CLD
    BRA		L_Loop_High_HxToD
L_End_HxToD_Prog:
	LDA		P_Temp+6
	RTS

;=================================================
Table_Example:
	LDA		table1+3
	JSR		L_HxToD_Prog
	Nop
	Nop
	RTS







table1:
	.BYTE	00H
	.BYTE	00H
	.BYTE	09H
	.BYTE	12H
	.BYTE	1BH
	.BYTE	24H
	.BYTE	2DH
	.BYTE	36H
	.BYTE	3FH
	.BYTE	48H



