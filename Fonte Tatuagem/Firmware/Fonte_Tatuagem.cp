#line 1 "C:/Users/fhmbe/Projetos/Fonte_Tatoo/Fonte Tatuagem/Firmware/Fonte_Tatuagem.c"





int control = 1;
unsigned short duty = 39;

int display(int pos);
void control_veloc();

void interrupt()
{
 if(T0IF_bit)
 {
 T0IF_bit = 0x00;

 if( portc.f3  == 0 && control == 1)
 {
  portc.f3  = 0x00;
  portc.f4  = 0x00;
 portb = 0;
  portc.f3  = 0x01;
 portb = display(3);
 control = 0x02;
 }
 else if( portc.f4  == 0 && control == 2)
 {
  portc.f3  = 0x00;
  portc.f4  = 0x00;
 portb = 0;
  portc.f4  = 0x01;
 portb = display(2);
 control = 0x01;
 }
 }
}

void main()
{
 cmcon = 0x07;
 intcon = 0xA0;
 option_reg = 0x83;




 porta = 0x00;
 trisa = 0x03;
 portb = 0x00;
 trisb = 0x00;
 portc = 0x00;
 trisc = 0x00;
 PWM1_Init(5000);


 PWM1_Start();
 PWM1_Set_Duty(duty);

 while(1)
 {
 control_veloc();
 }
}

int display(int pos)
 {
 int number;
 int display[] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
 number = display[pos];
 return(number);
}

void control_veloc()
{
 if( porta.f0  == 0)
 {
 portc.f0 = 1;
 duty = duty + 9;
 delay_ms(100);
 PWM1_Set_Duty(duty);
 if(duty >= 250)
 {
 duty = 250;
 }
 }
 if( porta.f1  == 0)
 {
 portc.f0 = 0;
 duty = duty - 9;
 delay_ms(100);
 PWM1_Set_Duty(duty);
 if(duty <= 39)
 {
 duty = 39;
 }
 }
}
