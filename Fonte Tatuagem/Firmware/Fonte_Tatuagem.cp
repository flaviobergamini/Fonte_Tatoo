#line 1 "C:/Users/fhmbe/Projetos/Fonte_Tatoo/Fonte Tatuagem/Firmware/Fonte_Tatuagem.c"
int cont = 0;
int disp1 = 0;
int disp2 = 0;
unsigned short duty;
int display[] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
unsigned Flag=0;
#line 16 "C:/Users/fhmbe/Projetos/Fonte_Tatoo/Fonte Tatuagem/Firmware/Fonte_Tatuagem.c"
void interrupt()
{
 if(T0IF_bit)
 {
 cont++;
 TMR0 = 0x00;
 T0IF_bit = 0x00;
 }
}

void main()
{
 option_reg = 0x81;
 GIE_bit = 0x01;
 PEIE_bit = 0x01;
 T0IE_bit = 0x01;
 TMR0 = 0x00;
 adcon1 = 0x0e;
 porta = 0x00;
 trisa = 0x01;
 portb = 0x00;
 trisb = 0x00;
 portc = 0x00;
 trisc = 0x00;
 PWM1_Init(5000);

 duty = 39;
 PWM1_Start();
 PWM1_Set_Duty(duty);

 while(1)
 {
#line 54 "C:/Users/fhmbe/Projetos/Fonte_Tatoo/Fonte Tatuagem/Firmware/Fonte_Tatuagem.c"
 if(cont == 2)
 {


 cont = 0;
 }
 }


}
