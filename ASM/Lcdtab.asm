;4 COM*8 SEG

;--------COM------------
C1  .equ    0
C2  .equ    1
C3  .equ    2
C4  .equ    3
;;--------SEG------------
S3      .EQU    43
S4      .EQU    42
S5      .EQU    41
S6      .EQU    40
S7      .EQU    15
S8      .EQU    14
S9      .EQU    13
S10     .EQU    12

db_c_s:      .macro  com,seg
            db com*6+seg/8
              .endm

db_c_y:       .macro  com,seg
            db 1.shl.(seg-seg/8*8)
            .endm

lcd_byte:
lcd_table1:
lcd_d1 .equ $-lcd_table1
    db_c_s  C1,S3   ;;1A
    db_c_s  C1,S4   ;;1B
    db_c_s  C3,S4   ;;1C
    db_c_s  C4,S4   ;;1D
    db_c_s  C3,S3   ;;1E
    db_c_s  C2,S3   ;;1F
    db_c_s  C2,S4   ;;1G

lcd_d2 .equ $-lcd_table1
    db_c_s  C1,S5   ;;2A
    db_c_s  C1,S6   ;;2B
    db_c_s  C3,S6   ;;2C
    db_c_s  C4,S6   ;;2D
    db_c_s  C3,S5   ;;2E
    db_c_s  C2,S5   ;;2F
    db_c_s  C2,S6   ;;2G

lcd_d3 equ $-lcd_table1
    db_c_s  C1,S7   ;;3A
    db_c_s  C1,S8   ;;3B
    db_c_s  C3,S8   ;;3C
    db_c_s  C4,S8   ;;3D
    db_c_s  C3,S7   ;;3E
    db_c_s  C2,S7   ;;3F
    db_c_s  C2,S8   ;;3G

lcd_d4 equ $-lcd_table1
    db_c_s  C1,S9   ;;4A
    db_c_s  C1,S10  ;;4B
    db_c_s  C3,S10  ;;4C
    db_c_s  C4,S10  ;;4D
    db_c_s  C3,S9   ;;4E
    db_c_s  C2,S9   ;;4F
    db_c_s  C2,S10  ;;4G 
    
lcd_dot:
lcd_col equ $-lcd_table1
    db_c_s  C4,S7  ;;COL 
lcd_am equ $-lcd_table1
    db_c_s  C4,S3  ;;AM
lcd_pm equ $-lcd_table1
    db_c_s  C4,S5  ;;PM
lcd_ms equ $-lcd_table1
    db_c_s  C4,S9  ;;M,S

;=========================================
lcd_bit:
    db_c_y  C1,S3   ;;1A
    db_c_y  C1,S4   ;;1B
    db_c_y  C3,S4   ;;1C
    db_c_y  C4,S4   ;;1D
    db_c_y  C3,S3   ;;1E
    db_c_y  C2,S3   ;;1F
    db_c_y  C2,S4   ;;1G

    db_c_y  C1,S5   ;;2A
    db_c_y  C1,S6   ;;2B
    db_c_y  C3,S6   ;;2C
    db_c_y  C4,S6   ;;2D
    db_c_y  C3,S5   ;;2E
    db_c_y  C2,S5   ;;2F
    db_c_y  C2,S6   ;;2G

    db_c_y  C1,S7   ;;3A
    db_c_y  C1,S8   ;;3B
    db_c_y  C3,S8   ;;3C
    db_c_y  C4,S8   ;;3D
    db_c_y  C3,S7   ;;3E
    db_c_y  C2,S7   ;;3F
    db_c_y  C2,S8   ;;3G

    db_c_y  C1,S9   ;;4A
    db_c_y  C1,S10  ;;4B
    db_c_y  C3,S10  ;;4C
    db_c_y  C4,S10  ;;4D
    db_c_y  C3,S9   ;;4E
    db_c_y  C2,S9   ;;4F
    db_c_y  C2,S10  ;;4G 
    
    db_c_y  C4,S7  ;;COL 
    db_c_y  C4,S3  ;;AM
    db_c_y  C4,S5  ;;PM
    db_c_y  C4,S9  ;;M,S
;=========================================