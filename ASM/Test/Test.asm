L_FillLcd_Com0:
	LDA		#0FFH
	
	STA		LCD_RamAddr+0*6,X      
	INX
   	CPX    	#6                               
   	BCC    	L_FillLcd_Com0
	RTS

L_FillLcd_Com1:
	LDA		#0FFH

	STA		LCD_RamAddr+1*6,X      
	INX
   	CPX    	#6                               
   	BCC    	L_FillLcd_Com1
	RTS

L_FillLcd_Com2:
	LDA		#0FFH

	STA		LCD_RamAddr+2*6,X      
	INX
   	CPX    	#6                               
   	BCC    	L_FillLcd_Com2
	RTS

L_FillLcd_Com3:
	LDA		#0FFH

	STA		LCD_RamAddr+3*6,X      
	INX
   	CPX    	#6                               
   	BCC    	L_FillLcd_Com3
	RTS


;=============================================
TesT_Seg_Lcd:
	LDA		#0
	STA		P_Temp+6

    LDA		P_Temp+7
    CMP		#0
	BEQ		L_FillLcd_Seg7

    CMP		#1
	BEQ		L_FillLcd_Seg8

    CMP		#2
	BEQ		L_FillLcd_Seg9

    CMP		#3
	BEQ		L_FillLcd_Seg10

    CMP		#4
	BEQ		L_FillLcd_Seg11

    CMP		#5
	BEQ		L_FillLcd_Seg12 

    CMP		#6
	BEQ		L_FillLcd_Seg13 

    CMP		#7
	BEQ		L_FillLcd_Seg14 

    CMP		#8
	BEQ		L_FillLcd_Seg15

    CMP		#9
	BEQ		L_FillLcd_Seg40 

    CMP		#10
	BEQ		L_FillLcd_Seg41 

    CMP		#11
	BEQ		L_FillLcd_Seg42

    CMP		#12
	BEQ		L_FillLcd_Seg43  
	
;======================================
Seg_Show:
    STA		LCD_RamAddr+0*6,X      
	STA		LCD_RamAddr+1*6,X      
	STA		LCD_RamAddr+2*6,X      
	STA		LCD_RamAddr+3*6,X      
	RTS

L_FillLcd_Seg7:
	LDA		#080H
	LDX		#0
	BRA     Seg_Show

L_FillLcd_Seg8:
	LDA		#001H
	LDX		#1
	BRA     Seg_Show
     
	RTS

L_FillLcd_Seg9:
	LDA		#002H
	LDX		#1
	BRA     Seg_Show
     
	RTS

L_FillLcd_Seg10:
	LDA		#004H
	LDX		#1
	BRA     Seg_Show
   
	RTS

L_FillLcd_Seg11:
	LDA		#008H
	LDX		#1
	BRA     Seg_Show
    
	RTS

L_FillLcd_Seg12:
	LDA		#010H
	LDX		#1
	BRA     Seg_Show
     
	RTS
L_FillLcd_Seg13:
	LDA		#020H
	LDX		#1
	BRA     Seg_Show
     
	RTS
L_FillLcd_Seg14:
	LDA		#040H
	LDX		#1
	BRA     Seg_Show
     
	RTS

L_FillLcd_Seg15:
	LDA		#080H
	LDX		#1
	BRA     Seg_Show
     
	RTS

L_FillLcd_Seg40:
	LDA		#001H
	LDX		#5
	BRA     Seg_Show
    
	RTS

L_FillLcd_Seg41:
	LDA		#002H
	LDX		#5
	BRA     Seg_Show
     
	RTS

L_FillLcd_Seg42:
	LDA		#004H
	LDX		#5
	BRA     Seg_Show
     
	RTS


L_FillLcd_Seg43:
	LDA		#008H
	LDX		#5
	STA		LCD_RamAddr+0*6,X      
	STA		LCD_RamAddr+1*6,X       
	STA		LCD_RamAddr+2*6,X      
	STA		LCD_RamAddr+3*6,X      
	RTS

;======================================
   

;=============================================
TesT_Com_Lcd:
	LDA		#0
	STA		P_Temp+7

	LDA		P_Temp+6
	CMP		#0
	BEQ		To_L_FillLcd_Com0

	CMP		#1
	BEQ		To_L_FillLcd_Com1

	CMP		#2
	BEQ		To_L_FillLcd_Com2

	CMP		#3
	BEQ		To_L_FillLcd_Com3

To_L_FillLcd_Com0:
	LDX		#0
	JSR		L_FillLcd_Com0
	RTS
To_L_FillLcd_Com1:
	LDX		#0
	JSR		L_FillLcd_Com1
	RTS
To_L_FillLcd_Com2:
	LDX		#0
	JSR		L_FillLcd_Com2
	RTS
To_L_FillLcd_Com3:
	LDX		#0
	JSR		L_FillLcd_Com3
	RTS

