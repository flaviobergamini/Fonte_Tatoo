
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Fonte_Tatuagem.c,12 :: 		void interrupt()                  //função de interrupção, endereço 0x04 de memória
;Fonte_Tatuagem.c,14 :: 		if(T0IF_bit)                    //Verifica se houve overflow do timer 0
	BTFSS      T0IF_bit+0, 2
	GOTO       L_interrupt0
;Fonte_Tatuagem.c,16 :: 		T0IF_bit = 0x00;               //Limpa registrador para a proxima interrupção
	BCF        T0IF_bit+0, 2
;Fonte_Tatuagem.c,18 :: 		if(d1_decimal == 0 && control == 1)
	BTFSC      PORTC+0, 3
	GOTO       L_interrupt3
	MOVLW      0
	XORWF      _control+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt20
	MOVLW      1
	XORWF      _control+0, 0
L__interrupt20:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
L__interrupt17:
;Fonte_Tatuagem.c,20 :: 		d1_decimal = 0x00;
	BCF        PORTC+0, 3
;Fonte_Tatuagem.c,21 :: 		d2_unidade = 0x00;
	BCF        PORTC+0, 4
;Fonte_Tatuagem.c,22 :: 		portb = 0;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,23 :: 		d1_decimal = 0x01;
	BSF        PORTC+0, 3
;Fonte_Tatuagem.c,24 :: 		portb = display(3);
	MOVLW      3
	MOVWF      FARG_display_pos+0
	MOVLW      0
	MOVWF      FARG_display_pos+1
	CALL       _display+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;Fonte_Tatuagem.c,25 :: 		control = 0x02;
	MOVLW      2
	MOVWF      _control+0
	MOVLW      0
	MOVWF      _control+1
;Fonte_Tatuagem.c,26 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;Fonte_Tatuagem.c,27 :: 		else if(d2_unidade == 0 && control == 2)
	BTFSC      PORTC+0, 4
	GOTO       L_interrupt7
	MOVLW      0
	XORWF      _control+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt21
	MOVLW      2
	XORWF      _control+0, 0
L__interrupt21:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt16:
;Fonte_Tatuagem.c,29 :: 		d1_decimal = 0x00;
	BCF        PORTC+0, 3
;Fonte_Tatuagem.c,30 :: 		d2_unidade = 0x00;
	BCF        PORTC+0, 4
;Fonte_Tatuagem.c,31 :: 		portb = 0;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,32 :: 		d2_unidade = 0x01;
	BSF        PORTC+0, 4
;Fonte_Tatuagem.c,33 :: 		portb = display(2);
	MOVLW      2
	MOVWF      FARG_display_pos+0
	MOVLW      0
	MOVWF      FARG_display_pos+1
	CALL       _display+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;Fonte_Tatuagem.c,34 :: 		control = 0x01;
	MOVLW      1
	MOVWF      _control+0
	MOVLW      0
	MOVWF      _control+1
;Fonte_Tatuagem.c,35 :: 		}
L_interrupt7:
L_interrupt4:
;Fonte_Tatuagem.c,36 :: 		}
L_interrupt0:
;Fonte_Tatuagem.c,37 :: 		}
L_end_interrupt:
L__interrupt19:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Fonte_Tatuagem.c,39 :: 		void main()
;Fonte_Tatuagem.c,41 :: 		cmcon = 0x07;                   //desabilita os comparadores internos da porta B
	MOVLW      7
	MOVWF      CMCON+0
;Fonte_Tatuagem.c,42 :: 		intcon = 0xA0;                  //Habilita a interrupção global e a interrupção do timer 0
	MOVLW      160
	MOVWF      INTCON+0
;Fonte_Tatuagem.c,43 :: 		option_reg = 0x83;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:16
	MOVLW      131
	MOVWF      OPTION_REG+0
;Fonte_Tatuagem.c,48 :: 		porta = 0x00;
	CLRF       PORTA+0
;Fonte_Tatuagem.c,49 :: 		trisa = 0x03;
	MOVLW      3
	MOVWF      TRISA+0
;Fonte_Tatuagem.c,50 :: 		portb = 0x00;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,51 :: 		trisb = 0x00;
	CLRF       TRISB+0
;Fonte_Tatuagem.c,52 :: 		portc = 0x00;
	CLRF       PORTC+0
;Fonte_Tatuagem.c,53 :: 		trisc = 0x00;
	CLRF       TRISC+0
;Fonte_Tatuagem.c,54 :: 		PWM1_Init(5000);                //Inicializa PWM1 com 5kHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Fonte_Tatuagem.c,57 :: 		PWM1_Start();                   //Inicia PWM1
	CALL       _PWM1_Start+0
;Fonte_Tatuagem.c,58 :: 		PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,60 :: 		while(1)
L_main8:
;Fonte_Tatuagem.c,62 :: 		control_veloc();
	CALL       _control_veloc+0
;Fonte_Tatuagem.c,63 :: 		}
	GOTO       L_main8
;Fonte_Tatuagem.c,64 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_display:

;Fonte_Tatuagem.c,66 :: 		int display(int pos)
;Fonte_Tatuagem.c,69 :: 		int display[] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
	MOVLW      63
	MOVWF      display_display_L0+0
	MOVLW      0
	MOVWF      display_display_L0+1
	MOVLW      6
	MOVWF      display_display_L0+2
	MOVLW      0
	MOVWF      display_display_L0+3
	MOVLW      91
	MOVWF      display_display_L0+4
	MOVLW      0
	MOVWF      display_display_L0+5
	MOVLW      79
	MOVWF      display_display_L0+6
	MOVLW      0
	MOVWF      display_display_L0+7
	MOVLW      102
	MOVWF      display_display_L0+8
	MOVLW      0
	MOVWF      display_display_L0+9
	MOVLW      109
	MOVWF      display_display_L0+10
	MOVLW      0
	MOVWF      display_display_L0+11
	MOVLW      125
	MOVWF      display_display_L0+12
	MOVLW      0
	MOVWF      display_display_L0+13
	MOVLW      7
	MOVWF      display_display_L0+14
	MOVLW      0
	MOVWF      display_display_L0+15
	MOVLW      127
	MOVWF      display_display_L0+16
	MOVLW      0
	MOVWF      display_display_L0+17
	MOVLW      111
	MOVWF      display_display_L0+18
	MOVLW      0
	MOVWF      display_display_L0+19
;Fonte_Tatuagem.c,70 :: 		number = display[pos];
	MOVF       FARG_display_pos+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_pos+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      display_display_L0+0
	MOVWF      FSR
;Fonte_Tatuagem.c,71 :: 		return(number);
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
;Fonte_Tatuagem.c,72 :: 		}
L_end_display:
	RETURN
; end of _display

_control_veloc:

;Fonte_Tatuagem.c,74 :: 		void control_veloc()
;Fonte_Tatuagem.c,76 :: 		if(mais == 0)
	BTFSC      PORTA+0, 0
	GOTO       L_control_veloc10
;Fonte_Tatuagem.c,78 :: 		portc.f0 = 1;
	BSF        PORTC+0, 0
;Fonte_Tatuagem.c,79 :: 		duty = duty + 9;
	MOVLW      9
	ADDWF      _duty+0, 1
;Fonte_Tatuagem.c,80 :: 		delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_control_veloc11:
	DECFSZ     R13+0, 1
	GOTO       L_control_veloc11
	DECFSZ     R12+0, 1
	GOTO       L_control_veloc11
	NOP
	NOP
;Fonte_Tatuagem.c,81 :: 		PWM1_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,82 :: 		if(duty >= 250)
	MOVLW      250
	SUBWF      _duty+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_control_veloc12
;Fonte_Tatuagem.c,84 :: 		duty = 250;
	MOVLW      250
	MOVWF      _duty+0
;Fonte_Tatuagem.c,85 :: 		}
L_control_veloc12:
;Fonte_Tatuagem.c,86 :: 		}
L_control_veloc10:
;Fonte_Tatuagem.c,87 :: 		if(menos == 0)
	BTFSC      PORTA+0, 1
	GOTO       L_control_veloc13
;Fonte_Tatuagem.c,89 :: 		portc.f0 = 0;
	BCF        PORTC+0, 0
;Fonte_Tatuagem.c,90 :: 		duty = duty - 9;
	MOVLW      9
	SUBWF      _duty+0, 1
;Fonte_Tatuagem.c,91 :: 		delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_control_veloc14:
	DECFSZ     R13+0, 1
	GOTO       L_control_veloc14
	DECFSZ     R12+0, 1
	GOTO       L_control_veloc14
	NOP
	NOP
;Fonte_Tatuagem.c,92 :: 		PWM1_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,93 :: 		if(duty <= 39)
	MOVF       _duty+0, 0
	SUBLW      39
	BTFSS      STATUS+0, 0
	GOTO       L_control_veloc15
;Fonte_Tatuagem.c,95 :: 		duty = 39;
	MOVLW      39
	MOVWF      _duty+0
;Fonte_Tatuagem.c,96 :: 		}
L_control_veloc15:
;Fonte_Tatuagem.c,97 :: 		}
L_control_veloc13:
;Fonte_Tatuagem.c,98 :: 		}
L_end_control_veloc:
	RETURN
; end of _control_veloc
