
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Fonte_Tatuagem.c,16 :: 		void interrupt()                  //função de interrupção, endereço 0x04 de memória
;Fonte_Tatuagem.c,18 :: 		if(T0IF_bit)                    //Verifica se houve overflow do timer 0
	BTFSS      T0IF_bit+0, 2
	GOTO       L_interrupt0
;Fonte_Tatuagem.c,20 :: 		cont++;
	INCF       _cont+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cont+1, 1
;Fonte_Tatuagem.c,21 :: 		TMR0 = 0x00;                   //Reinicia Timer 0
	CLRF       TMR0+0
;Fonte_Tatuagem.c,22 :: 		T0IF_bit = 0x00;               //Limpa registrador para a proxima interrupção
	BCF        T0IF_bit+0, 2
;Fonte_Tatuagem.c,23 :: 		}
L_interrupt0:
;Fonte_Tatuagem.c,24 :: 		}
L_end_interrupt:
L__interrupt5:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Fonte_Tatuagem.c,26 :: 		void main()
;Fonte_Tatuagem.c,28 :: 		option_reg = 0x81;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:4
	MOVLW      129
	MOVWF      OPTION_REG+0
;Fonte_Tatuagem.c,29 :: 		GIE_bit = 0x01;                 //Habilita interrupção global
	BSF        GIE_bit+0, 7
;Fonte_Tatuagem.c,30 :: 		PEIE_bit = 0x01;                //Habilita interrupção por periféricos
	BSF        PEIE_bit+0, 6
;Fonte_Tatuagem.c,31 :: 		T0IE_bit = 0x01;                //Habilita interrupção pelo overfolw do timer 0
	BSF        T0IE_bit+0, 5
;Fonte_Tatuagem.c,32 :: 		TMR0 = 0x00;                    //Inicia timer em zero
	CLRF       TMR0+0
;Fonte_Tatuagem.c,33 :: 		adcon1 = 0x0e;
	MOVLW      14
	MOVWF      ADCON1+0
;Fonte_Tatuagem.c,34 :: 		porta = 0x00;
	CLRF       PORTA+0
;Fonte_Tatuagem.c,35 :: 		trisa = 0x01;
	MOVLW      1
	MOVWF      TRISA+0
;Fonte_Tatuagem.c,36 :: 		portb = 0x00;
	CLRF       PORTB+0
;Fonte_Tatuagem.c,37 :: 		trisb = 0x00;
	CLRF       TRISB+0
;Fonte_Tatuagem.c,38 :: 		portc = 0x00;
	CLRF       PORTC+0
;Fonte_Tatuagem.c,39 :: 		trisc = 0x00;
	CLRF       TRISC+0
;Fonte_Tatuagem.c,40 :: 		PWM1_Init(5000);                //Inicializa PWM1 com 5kHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Fonte_Tatuagem.c,42 :: 		duty = 39;
	MOVLW      39
	MOVWF      _duty+0
;Fonte_Tatuagem.c,43 :: 		PWM1_Start();                   //Inicia PWM1
	CALL       _PWM1_Start+0
;Fonte_Tatuagem.c,44 :: 		PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Fonte_Tatuagem.c,46 :: 		while(1)
L_main1:
;Fonte_Tatuagem.c,54 :: 		if(cont == 2)
	MOVLW      0
	XORWF      _cont+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main7
	MOVLW      2
	XORWF      _cont+0, 0
L__main7:
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;Fonte_Tatuagem.c,58 :: 		cont = 0;
	CLRF       _cont+0
	CLRF       _cont+1
;Fonte_Tatuagem.c,59 :: 		}
L_main3:
;Fonte_Tatuagem.c,60 :: 		}
	GOTO       L_main1
;Fonte_Tatuagem.c,63 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
