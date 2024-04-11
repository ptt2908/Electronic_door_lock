LCD_E  BIT P3.4
LCD_RS BIT P3.5
LCDADDR EQU 6000H
ORG 2000H
RESET:          SETB P3.2			  ;TAT DONG CO, CLOSE DOOR
                SETB P3.3			  ;TAT COI BUZZER
                MOV SCON,#50H                     ;che do UART 8 bit (MODE 2)
                MOV TMOD,#20H		  	  ;timer 1 mode 2 8 bit tu dong nap lai
                MOV TH1,#(-3)		 	  ;TOC DO BAUND = 9600
                SETB TR1			  ;chay timer 1
                MOV R5,#0		      	  ;DEM SO KY TU MAT KHAU
		MOV R1,#30H		     	  ;ADDR SAVE MAT KHAU NHAP TU BAN PHIM 
		ACALL INIT_LCD		  	  ;KHOI DONG LCD
		ACALL ENTER_PASSWORD  		  ;MOI NHAP MAT KHAU
                ACALL XUONG_HANG                  ;XUONG HANG LCD
                ACALL BAN_PHIM		  	  ;GIAO TIEP BAN PHIM, DUOC LƯU VÀO R2
MAIN:	        MOV A,R2
		INC R5
                CJNE A,#13,TT                     ; #13 LÀ NHẬP ENTER
		SJMP CHECK_ENTER
TT:		MOV @R1,A			 ;LUU MAT KHAU NHAP TU BAN PHIM
                INC R1
		MOV A,R2
		ADD A,#48			 ;MA ASCII SO 0
		ACALL WRITETEXT
		ACALL DL500MS
	        CJNE R5,#5,BAN_PHIM
		SJMP TT2
CHECK_ENTER:    CJNE R5,#5,TT4
                SJMP TT3
TT2:            LCALL VUOT_KY_TU
TT3:            LCALL CHECK_PASSWORD
TT4:            LCALL LOI_ENTER
		SJMP $
;----------------------------------------------;
CHECK_PASSWORD: MOV R6,#0
                MOV R0,#20H
LOOP:		MOV A,R6
		MOV DPTR,#MAT_KHAU_KHOA_CUA_SO
		MOVC A,@A+DPTR
		MOV @R0,A
		INC R0
		INC R6
		CJNE R6,#4,LOOP
		MOV A,20H
		CJNE A,30H,SAI
		MOV A,21H
		CJNE A,31H,SAI
		MOV A,22H
		CJNE A,32H,SAI
		MOV A,23H
		CJNE A,33H,SAI
		LCALL MAT_KHAU_DUNG
SAI:		LCALL MAT_KHAU_SAI
                RET
;-----------------------------------------------;
BAN_PHIM: MOV P1,#01101111B
          JNB P1.0,SO_7
	  JNB P1.1,SO_4
	  JNB P1.2,SO_1
	  JNB P1.3,CHU_EXIT
	  MOV P1,#01011111B
          JNB P1.0,SO_8
	  JNB P1.1,SO_5
	  JNB P1.2,SO_2
	  JNB P1.3,SO_0
          MOV P1,#00111111B
          JNB P1.0,SO_9
	  JNB P1.1,SO_6
	  JNB P1.2,SO_3
	  JNB P1.3,CHU_ENTER
	  LJMP BAN_PHIM
SO_0:   MOV R2,#0
        LJMP MAIN
SO_1:   MOV R2,#1
        LJMP MAIN
SO_2:   MOV R2,#2
        LJMP MAIN
SO_3:   MOV R2,#3
        LJMP MAIN
SO_4:   MOV R2,#4
        LJMP MAIN
SO_5:   MOV R2,#5
        LJMP MAIN
SO_6:   MOV R2,#6
        LJMP MAIN
SO_7:   MOV R2,#7
        LJMP MAIN
SO_8:   MOV R2,#8
        LJMP MAIN
SO_9:   MOV R2,#9
        LJMP MAIN
CHU_EXIT:  LJMP RESET
CHU_ENTER: MOV R2,#13
           LJMP MAIN
           RET
;-----------------------------------;
ENTER_PASSWORD:   MOV R3,#0
RETURN:           MOV DPTR,#MA_ENTER_PASSWORD
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
		  JZ THOAT
		  INC R3
		  LJMP RETURN
THOAT:		  RET
;------------------------------------;
LOI_ENTER:  	  POP 03H
                  LCALL CLEAR
		  MOV DPTR,#LCDADDR
		  MOV A,#085H
		  ACALL WRITECOM
		  LCALL QUA_KY_TU
                  MOV DPTR,#LCDADDR
		  MOV A,#0C2H
		  ACALL WRITECOM
                  MOV R3,#0
RETURN2:          MOV DPTR,#PLEASE_ENTER
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
	          JZ THOAT2
		  INC R3
		  SJMP RETURN2
THOAT2:		  LCALL DL1S
                  LJMP RESET
                  RET
;----------------------------------------------;
QUA_KY_TU:  	  MOV R3,#0
RETURN3:          MOV DPTR,#MA_QUA_KY_TU
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
		  JZ THOAT3
		  INC R3
		  SJMP RETURN3
THOAT3:		  RET
;-----------------------------------------------------;
NHAP_LAI:  	  MOV R3,#0
RETURN4:          MOV DPTR,#PLEASE_ENTER
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
		  JZ THOAT4
		  INC R3
		  SJMP RETURN4
THOAT4:		      RET
;--------------------------------------------------;
DUNG_MAT_KHAU:    MOV R3,#0
RETURN5:          MOV DPTR,#MA_DUNG_MAT_KHAU
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
		  JZ THOAT5
		  INC R3
		  SJMP RETURN5
THOAT5:		  RET
;--------------------------------------------------;
LENH_MO_CUA:      MOV R3,#0
RETURN6:          MOV DPTR,#MA_LENH_MO_CUA
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
		  JZ THOAT6
		  INC R3
		  SJMP RETURN6
THOAT6:		  RET
;--------------------------------------------------;
SAI_MAT_KHAU:     MOV R3,#0
RETURN7:          MOV DPTR,#MA_SAI_MAT_KHAU
		  MOV A,R3
		  MOVC A,@A+DPTR
		  ACALL WRITETEXT
		  JZ THOAT7
		  INC R3
		  SJMP RETURN7
THOAT7:		  RET
;--------------------------------------------------;
INIT_LCD: MOV A,#01H
          ACALL WRITECOM
          MOV A, #38H
          ACALL WRITECOM
          MOV A, #0EH
          ACALL WRITECOM 
          MOV A, #06H
          ACALL WRITECOM
          RET
CLEAR:    MOV DPTR,#LCDADDR
          MOV A, #01H
          ACALL WRITECOM
          RET
XUONG_HANG: MOV DPTR,#LCDADDR
            MOV A,#0C5H
	    ACALL WRITECOM
	    RET
WRITECOM:   MOV DPTR, #LCDADDR 
            SETB LCD_E
            CLR LCD_RS				;truy xuat lenh
            MOVX @DPTR, A
            CLR LCD_E
            ACALL WAIT_LCD
            RET
WRITETEXT:  MOV DPTR,#LCDADDR
            MOVX @DPTR,A
            SETB LCD_E
            SETB LCD_RS				 ;truy xuat data
            CLR LCD_E
            ACALL WAIT_LCD
            RET
WAIT_LCD:   PUSH 07H
            PUSH 06H
	     MOV R6,#10 
DL1:        MOV R7,#250
            DJNZ R7, $
	    DJNZ R6,DL1
	    POP 06H
	    POP 07H
	    RET
;---------------------------------------;
DL500MS:      PUSH 07H
              PUSH 06H
	      PUSH 05H
	      MOV R7,#5
LAP2_DL500MS: MOV R6,#250
LAP1_DL500MS: MOV R5,#250
	      DJNZ R5,$
	      DJNZ R6,LAP1_DL500MS
	      DJNZ R7,LAP2_DL500MS
	      POP 05H
	      POP 06H
	      POP 07H
	      RET
;------------------------------------;
DL1S:             PUSH 04H
                  MOV R4,#2
LAP_DL1S:	  ACALL DL500MS
		  DJNZ R4,LAP_DL1S
		  POP 04H
		  RET
DL10S:            PUSH 04H
                  MOV R4,#10
LAP_DL10S:	  ACALL DL1S
		  DJNZ R4,LAP_DL10S
		  POP 04H
		  RET
;--------------------------------------;
VUOT_KY_TU:       LCALL CLEAR
                  MOV DPTR,#LCDADDR
                  MOV A,#84H
		  ACALL WRITECOM
		  ACALL QUA_KY_TU
		  MOV DPTR,#LCDADDR
                  MOV A,#0C1H
		  ACALL WRITECOM
		  ACALL	NHAP_LAI
		  LCALL DL1S
		  LJMP RESET
		  RET
;-------------------------------------;
MAT_KHAU_DUNG:   LCALL CLEAR
                 MOV DPTR,#LCDADDR
		 MOV A,#84H
		 ACALL WRITECOM
		 ACALL DUNG_MAT_KHAU
		 MOV DPTR,#LCDADDR
		 MOV A,#0C3H
		 ACALL WRITECOM
		 ACALL LENH_MO_CUA
		 LCALL DL1S
		 CLR P3.2		  ;dong co xoay
		 LCALL DL10S
		 LJMP RESET
		 RET
;-------------------------------------;
MAT_KHAU_SAI:    LCALL CLEAR
                 MOV DPTR,#LCDADDR
		 MOV A,#80H
		 ACALL WRITECOM
		 ACALL SAI_MAT_KHAU
		 MOV DPTR,#LCDADDR
                 LCALL DL500MS
		 CLR P3.3			   ;coi buzzer kêu
		 LCALL DL10S
		 LJMP RESET
		 RET
;---------------------------------------;                 
MAT_KHAU_KHOA_CUA_SO: DB  8,0,5,1                 
MA_ENTER_PASSWORD:    DB 'ENTER PASSWORD:',0H
PLEASE_ENTER:         DB 'PLEASE ENTER!',0H
MA_QUA_KY_TU:         DB 'ERROR!',0H
MA_DUNG_MAT_KHAU:     DB 'CORRECT!',0H
MA_SAI_MAT_KHAU:      DB 'WRONG PASSWORD!',0H
MA_LENH_MO_CUA:       DB 'OPEN DOOR!',0H
END
