
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Fonte_Tatuagem.c,13 :: 		void interrupt()                  //função de interrupção, endereço 0x04 de memória
;Fonte_Tatuagem.c,15 :: 		if(T0IF_bit)                    //Verifica se houve overflow do timer 0
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L_interrupt0
;Fonte_Tatuagem.c,17 :: 		T0IF_bit = 0x00;               //Limpa registrador para a proxima interrupção
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;Fonte_Tatuagem.c,19 :: 		if(d2_unidade == 0 && control == 1)
	BTFSC      PORTC+0, 3
	GOTO       L_interrupt3
	MOVLW      0
	XORWF      _control+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt24
	MOVLW      1
	XORWF      _control+0, 0
L__interrupt24:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
L__interrupt21:
;Fonte_Tatuagem.c,21 :: 		d1_decimal = 0x00;
	BCF        PORTC+0, 4
;Fonte_Tatuagem.c,22 :: 		d2_unidade = 0x00;
	BCF        PORTC+0, 3
;Fonte_Tatuagem.c,23 :: 		portb.f7 = 1;
	BSF        PORTB+0, 7
;Fonte_Tatuagem.c,24 :: 		portb = 0;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,25 :: 		d2_unidade = 0x01;
	BSF        PORTC+0, 3
;Fonte_Tatuagem.c,26 :: 		portb = display(med_u);
	MOVF       _med_u+0, 0
	MOVWF      FARG_display_pos+0
	MOVF       _med_u+1, 0
	MOVWF      FARG_display_pos+1
	CALL       _display+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;Fonte_Tatuagem.c,27 :: 		control = 0x02;
	MOVLW      2
	MOVWF      _control+0
	MOVLW      0
	MOVWF      _control+1
;Fonte_Tatuagem.c,28 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;Fonte_Tatuagem.c,29 :: 		else if(d1_decimal == 0 && control == 2)
	BTFSC      PORTC+0, 4
	GOTO       L_interrupt7
	MOVLW      0
	XORWF      _control+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt25
	MOVLW      2
	XORWF      _control+0, 0
L__interrupt25:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt20:
;Fonte_Tatuagem.c,31 :: 		d1_decimal = 0x00;
	BCF        PORTC+0, 4
;Fonte_Tatuagem.c,32 :: 		d2_unidade = 0x00;
	BCF        PORTC+0, 3
;Fonte_Tatuagem.c,33 :: 		portb.f7 = 1;
	BSF        PORTB+0, 7
;Fonte_Tatuagem.c,34 :: 		portb = 0;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,35 :: 		d1_decimal = 0x01;
	BSF        PORTC+0, 4
;Fonte_Tatuagem.c,36 :: 		portb = display(med_d);
	MOVF       _med_d+0, 0
	MOVWF      FARG_display_pos+0
	MOVF       _med_d+1, 0
	MOVWF      FARG_display_pos+1
	CALL       _display+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;Fonte_Tatuagem.c,37 :: 		if(med >= 10)
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	MOVF       _med+0, 0
	MOVWF      R0+0
	MOVF       _med+1, 0
	MOVWF      R0+1
	MOVF       _med+2, 0
	MOVWF      R0+2
	MOVF       _med+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt8
;Fonte_Tatuagem.c,38 :: 		portb.f7 = 1;
	BSF        PORTB+0, 7
	GOTO       L_interrupt9
L_interrupt8:
;Fonte_Tatuagem.c,40 :: 		portb.f7 = 0;
	BCF        PORTB+0, 7
L_interrupt9:
;Fonte_Tatuagem.c,41 :: 		control = 0x01;
	MOVLW      1
	MOVWF      _control+0
	MOVLW      0
	MOVWF      _control+1
;Fonte_Tatuagem.c,42 :: 		}
L_interrupt7:
L_interrupt4:
;Fonte_Tatuagem.c,43 :: 		}
L_interrupt0:
;Fonte_Tatuagem.c,44 :: 		}
L_end_interrupt:
L__interrupt23:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Fonte_Tatuagem.c,46 :: 		void main()
;Fonte_Tatuagem.c,48 :: 		ADCON1 = 14;                    //Habilita a leitura analógica
	MOVLW      14
	MOVWF      ADCON1+0
;Fonte_Tatuagem.c,49 :: 		intcon = 0xA0;                  //Habilita a interrupção global e a interrupção do timer 0
	MOVLW      160
	MOVWF      INTCON+0
;Fonte_Tatuagem.c,50 :: 		option_reg = 0x83;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:16
	MOVLW      131
	MOVWF      OPTION_REG+0
;Fonte_Tatuagem.c,51 :: 		porta = 0x00;
	CLRF       PORTA+0
;Fonte_Tatuagem.c,52 :: 		trisa = 0x00;
	CLRF       TRISA+0
;Fonte_Tatuagem.c,53 :: 		portb = 0x00;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,54 :: 		trisb = 0x00;
	CLRF       TRISB+0
;Fonte_Tatuagem.c,55 :: 		trisc = 0b10000011;
	MOVLW      131
	MOVWF      TRISC+0
;Fonte_Tatuagem.c,56 :: 		portc = 0x00;
	CLRF       PORTC+0
;Fonte_Tatuagem.c,57 :: 		PWM1_Init(5000);               //Inicializa PWM1 com 18kHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Fonte_Tatuagem.c,58 :: 		PWM1_Start();                   //Inicia PWM1
	CALL       _PWM1_Start+0
;Fonte_Tatuagem.c,59 :: 		PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,61 :: 		while(1)
L_main10:
;Fonte_Tatuagem.c,63 :: 		med = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      _med+0
	MOVF       R0+1, 0
	MOVWF      _med+1
	MOVF       R0+2, 0
	MOVWF      _med+2
	MOVF       R0+3, 0
	MOVWF      _med+3
;Fonte_Tatuagem.c,64 :: 		med = (med*12)/1023;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      64
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _med+0
	MOVF       R0+1, 0
	MOVWF      _med+1
	MOVF       R0+2, 0
	MOVWF      _med+2
	MOVF       R0+3, 0
	MOVWF      _med+3
;Fonte_Tatuagem.c,65 :: 		if(med < 10)
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main12
;Fonte_Tatuagem.c,67 :: 		mult = med*10;
	MOVF       _med+0, 0
	MOVWF      R0+0
	MOVF       _med+1, 0
	MOVWF      R0+1
	MOVF       _med+2, 0
	MOVWF      R0+2
	MOVF       _med+3, 0
	MOVWF      R0+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       FLOC__main+0, 0
	MOVWF      _mult+0
	MOVF       FLOC__main+1, 0
	MOVWF      _mult+1
;Fonte_Tatuagem.c,68 :: 		med_d = mult/10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _med_d+0
	MOVF       R0+1, 0
	MOVWF      _med_d+1
;Fonte_Tatuagem.c,69 :: 		med_u = mult%10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _med_u+0
	MOVF       R0+1, 0
	MOVWF      _med_u+1
;Fonte_Tatuagem.c,70 :: 		}
	GOTO       L_main13
L_main12:
;Fonte_Tatuagem.c,73 :: 		mult = med;
	MOVF       _med+0, 0
	MOVWF      R0+0
	MOVF       _med+1, 0
	MOVWF      R0+1
	MOVF       _med+2, 0
	MOVWF      R0+2
	MOVF       _med+3, 0
	MOVWF      R0+3
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       FLOC__main+0, 0
	MOVWF      _mult+0
	MOVF       FLOC__main+1, 0
	MOVWF      _mult+1
;Fonte_Tatuagem.c,74 :: 		med_d = mult/10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _med_d+0
	MOVF       R0+1, 0
	MOVWF      _med_d+1
;Fonte_Tatuagem.c,75 :: 		med_u = mult%10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _med_u+0
	MOVF       R0+1, 0
	MOVWF      _med_u+1
;Fonte_Tatuagem.c,76 :: 		}
L_main13:
;Fonte_Tatuagem.c,77 :: 		control_veloc();
	CALL       _control_veloc+0
;Fonte_Tatuagem.c,78 :: 		}
	GOTO       L_main10
;Fonte_Tatuagem.c,79 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_display:

;Fonte_Tatuagem.c,81 :: 		int display(int pos)
;Fonte_Tatuagem.c,85 :: 		int display[] = {192, 249, 164,176, 153, 146, 130, 248, 128, 144}; // Para display Anodo comum
	MOVLW      192
	MOVWF      display_display_L0+0
	MOVLW      0
	MOVWF      display_display_L0+1
	MOVLW      249
	MOVWF      display_display_L0+2
	MOVLW      0
	MOVWF      display_display_L0+3
	MOVLW      164
	MOVWF      display_display_L0+4
	MOVLW      0
	MOVWF      display_display_L0+5
	MOVLW      176
	MOVWF      display_display_L0+6
	MOVLW      0
	MOVWF      display_display_L0+7
	MOVLW      153
	MOVWF      display_display_L0+8
	MOVLW      0
	MOVWF      display_display_L0+9
	MOVLW      146
	MOVWF      display_display_L0+10
	MOVLW      0
	MOVWF      display_display_L0+11
	MOVLW      130
	MOVWF      display_display_L0+12
	MOVLW      0
	MOVWF      display_display_L0+13
	MOVLW      248
	MOVWF      display_display_L0+14
	MOVLW      0
	MOVWF      display_display_L0+15
	MOVLW      128
	MOVWF      display_display_L0+16
	MOVLW      0
	MOVWF      display_display_L0+17
	MOVLW      144
	MOVWF      display_display_L0+18
	MOVLW      0
	MOVWF      display_display_L0+19
;Fonte_Tatuagem.c,86 :: 		number = display[pos];
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
;Fonte_Tatuagem.c,87 :: 		return(number);
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
;Fonte_Tatuagem.c,88 :: 		}
L_end_display:
	RETURN
; end of _display

_control_veloc:

;Fonte_Tatuagem.c,90 :: 		void control_veloc()
;Fonte_Tatuagem.c,92 :: 		if(mais == 0)
	BTFSC      PORTC+0, 0
	GOTO       L_control_veloc14
;Fonte_Tatuagem.c,94 :: 		portc.f0 = 1;
	BSF        PORTC+0, 0
;Fonte_Tatuagem.c,95 :: 		duty = duty + 1;
	INCF       _duty+0, 1
;Fonte_Tatuagem.c,96 :: 		PWM1_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,97 :: 		if(duty >= 250)
	MOVLW      250
	SUBWF      _duty+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_control_veloc15
;Fonte_Tatuagem.c,99 :: 		duty = 250;
	MOVLW      250
	MOVWF      _duty+0
;Fonte_Tatuagem.c,100 :: 		}
L_control_veloc15:
;Fonte_Tatuagem.c,101 :: 		delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_control_veloc16:
	DECFSZ     R13+0, 1
	GOTO       L_control_veloc16
	DECFSZ     R12+0, 1
	GOTO       L_control_veloc16
	DECFSZ     R11+0, 1
	GOTO       L_control_veloc16
;Fonte_Tatuagem.c,102 :: 		}
L_control_veloc14:
;Fonte_Tatuagem.c,103 :: 		if(menos == 0)
	BTFSC      PORTC+0, 1
	GOTO       L_control_veloc17
;Fonte_Tatuagem.c,105 :: 		portc.f0 = 0;
	BCF        PORTC+0, 0
;Fonte_Tatuagem.c,106 :: 		duty = duty - 1;
	DECF       _duty+0, 1
;Fonte_Tatuagem.c,107 :: 		PWM1_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,108 :: 		if(duty <= 39)
	MOVF       _duty+0, 0
	SUBLW      39
	BTFSS      STATUS+0, 0
	GOTO       L_control_veloc18
;Fonte_Tatuagem.c,110 :: 		duty = 39;
	MOVLW      39
	MOVWF      _duty+0
;Fonte_Tatuagem.c,111 :: 		}
L_control_veloc18:
;Fonte_Tatuagem.c,112 :: 		delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_control_veloc19:
	DECFSZ     R13+0, 1
	GOTO       L_control_veloc19
	DECFSZ     R12+0, 1
	GOTO       L_control_veloc19
	DECFSZ     R11+0, 1
	GOTO       L_control_veloc19
;Fonte_Tatuagem.c,113 :: 		}
L_control_veloc17:
;Fonte_Tatuagem.c,114 :: 		}
L_end_control_veloc:
	RETURN
; end of _control_veloc
