.Kdata
;***************************************
; RAM Address
;***************************************
BIT0			.EQU	001H
BIT1			.EQU	002H
BIT2			.EQU	004H
BIT3			.EQU	008H
BIT4			.EQU	010H
BIT5			.EQU	020H
BIT6			.EQU	040H
BIT7			.EQU	080H
BIT0_			.EQU	0FEH
BIT1_			.EQU	0FDH
BIT2_			.EQU	0FBH
BIT3_			.EQU	0F7H
BIT4_			.EQU	0EFH
BIT5_			.EQU	0DFH
BIT6_			.EQU	0BFH
BIT7_			.EQU	07FH

RamStarAddr		EQU		1800H
LCD_RamAddr		EQU		RamStarAddr
Time_Addr		EQU     RamStarAddr+Time_str_Addr-Page0RamStarAddr

StwFlag_Addr	EQU		RamStarAddr+Stw_Flag_Addr-Page0RamStarAddr
StwSec_Addr		EQU		RamStarAddr+Stw_Sec_Addr-Page0RamStarAddr
StwMin_Addr		EQU		RamStarAddr+Stw_Min_Addr-Page0RamStarAddr
StwHr_Addr		EQU		RamStarAddr+Stw_Hr_Addr-Page0RamStarAddr
StwSecSpl_Addr	EQU		RamStarAddr+Stw_Sec_Spl_Addr-Page0RamStarAddr
StwMinSpl_Addr	EQU		RamStarAddr+Stw_Min_Spl_Addr-Page0RamStarAddr
StwHrSpl_Addr	EQU		RamStarAddr+Stw_Hr_Spl_Addr-Page0RamStarAddr

DigitStr		EQU		1
Digit1			EQU		DigitStr+0
Digit2			EQU		DigitStr+1
Digit3			EQU		DigitStr+2
Digit4			EQU		DigitStr+3
Digit5			EQU		DigitStr+4
Digit6			EQU		DigitStr+5

2Digit1			EQU		DigitStr+0
2Digit2			EQU		DigitStr+1
2Digit3			EQU		DigitStr+2
2Digit4			EQU		DigitStr+3
2Digit5			EQU		DigitStr+4
2Digit6			EQU		DigitStr+5

3Digit1			EQU		DigitStr+12
3Digit2			EQU		DigitStr+13
3Digit3			EQU		DigitStr+14
3Digit4			EQU		DigitStr+15
3Digit5			EQU		DigitStr+16
3Digit6			EQU		DigitStr+17

D_ExitSetTime	EQU		20
;***************************************
.PAGE0
;***************************************
	ORG	0080H
Page0RamStarAddr	EQU		$		
LCDRAM			DS		4*6	
R_Int_Backup	DS		1
Sys_Flag_A	 DS		1
;bit0 = 2HZ 
;bit1 =	1HZ 
;bit2 = 32HZ 
;bit3 =
;bit4 = 标记PA2按键是否按下
;bit5 =	标记PA5、PA7按键是否按下
;bit6 =	标记PA5按键是否按下
;bit7 =	标记PA7按键是否按下

Sys_Flag_B		DS	1
;bit0 = 时间/计时  0：时间  1：计时
;bit1 = 计时开始/暂停  0：暂停  1：开始
;bit2 =	正计时/倒计时  0:正计时 1：倒计时
;bit3 = 0-正计时未结束   1-正计时结束 
;bit4 = 
;bit5 = 12/24HR	0：24Hr  1:12hr
;bit6 = 
;bit7 = 0-倒计时未结束	1-倒计时结束

Sys_Flag_C		DS	1
;bit0 = 	快加/快减标志
;bit1 = 
;bit2 =	
;bit3 = 
;bit4 =
;bit5 = 
;bit6 = 
;bit7 =	

Sys_Flag_D		DS	1
;bit0 = 
;bit1 = 
;bit2 =	
;bit3 = 
;bit4 =
;bit5 = 
;bit6 = 
;bit7 =	

R_Key_Flag		DS	1
;bit0=	SATART_KEY HOLD
;bit1=	UP_KEY HOLD
;bit2=	DOWN_KEY HOLD
;bit3=	判断是否有任意键按下过
;bit4=
;bit5=
;bit6=
;bit7=


Stw_Flag_Addr 	.EQU  $
R_Stw_Flag		DS	2
;bit0= 
;bit1= 
;bit2= 
;bit3= 
;bit4= 
;bit5= 
;bit6= 
;bit7= 

R_Day_Flag		DS	1	;
;bit0= 
;bit1= 
;bit2= 
;bit3= 
;bit4= 
;bit5= 
;bit6= 
;bit7= 

R_Set_Flag		DS	1	;
;bit0= 
;bit1= 
;bit2= 
;bit3= 
;bit4= 
;bit5= 
;bit6= 
;bit7= 
R_No_Key		DS	1	;
;bit0= 
;bit1= 
;bit2= 
;bit3= 
;bit4= 
;bit5= 
;bit6= 
;bit7= 
R_STW_Key		DS	1
R_Mode_Flag		DS	1
;bit0= 0：正计时/1：倒计时
;bit1= 
;bit2= 
;bit3= 
;bit4= 
;bit5= 
;bit6= 
;bit7= 

;;计时
R_CtwTime_Min	DS	1
R_CtwTime_Sec	DS	1


Time_str_Addr		.EQU  $
R_Time_Min			DS	1
R_Time_Sec			DS	1
R_Time_Hr			DS	1

R_Stw_Mode		DS  1
D_Stw			.EQU  0
D_Stw2		    .EQU  1

Stw_Sec_Addr	.equ	$
R_Stw_Sec		DS	1
Stw_Min_Addr	.equ	$
R_Stw_Min	   	DS	1
Stw_Hr_Addr		.equ	$
R_Stw_Hr		DS	1

R_Mode			DS	1
R_Set			DS	1
D_Time_Mode		.equ	0	
D_Stw_Mode		.equ	1	
D_Al_Mode		.equ	2	
;D_Al2_Mode		.equ	3	
;D_StwDay_Mode	.equ	4	
D_Max_Mode		.equ	2+1

Stw_Sec_Spl_Addr		.equ	$
R_Stw_Sec_Spl   DS	2
Stw_Min_Spl_Addr		.equ	$
R_Stw_Min_Spl   DS	2
Stw_Hr_Spl_Addr		.equ	$
R_Stw_Hr_Spl    DS	2

R_Al_Sec_Spl   	DS	1
R_Al_Min_Spl   	DS	1

R_Al_Sec		DS	1    	
R_Al_Min		DS	1		
R_Al_Hr			DS	1

R_Alarm_Mode	DS	1
R_Beep_Time		DS	1
R_Voice_Unit	DS	1
R_KeyHold_Time	DS	1	
R_Fast_Time		DS	1
C_Fast_Time		.EQU  32/8

R_Key	DS	1

R_Num			DS	1		
;---------------------------------------
;---------------------------------------
P_Temp			DS	8		
R_Temp				.equ	P_Temp
P_Num			DS	1		

PADIR_TEMP		DS	1
PA_TEMP			DS	1
PCDIR_TEMP		DS	1
PC_TEMP			DS	1

R_KeyValue		DS	1
;***************************************
.ENDS
;***************************************
;.Udata
;;---------------------------------------
;	ORG    1800H
;
;;---------------------------------------
;	ORG    1847H
;;---------------------------------------
;.ENDS
