#line 1 "C:/Users/fhmbe/Projetos/Fonte_Tatoo/Fonte Tatuagem/Firmware/Fonte_Tatuagem.c"





int control = 1, med_d= 0, med_u = 0, mult;
unsigned short duty = 38.7;
float med;

int display(int pos);
void control_veloc();

void interrupt()
{
 if(T0IF_bit)
 {
 T0IF_bit = 0x00;

 if( portc.f3  == 0 && control == 1)
 {
  portc.f4  = 0x00;
  portc.f3  = 0x00;
 portb.f7 = 1;
 portb = 0;
  portc.f3  = 0x01;
 portb = display(med_u);
 control = 0x02;
 }
 else if( portc.f4  == 0 && control == 2)
 {
  portc.f4  = 0x00;
  portc.f3  = 0x00;
 portb.f7 = 1;
 portb = 0;
  portc.f4  = 0x01;
 portb = display(med_d);
 if(med >= 10)
 portb.f7 = 1;
 else
 portb.f7 = 0;
 control = 0x01;
 }
 }
}

void main()
{
 ADCON1 = 14;
 intcon = 0xA0;
 option_reg = 0x83;
 porta = 0x00;
 trisa = 0x00;
 portb = 0x00;
 trisb = 0x00;
 trisc = 0b10000011;
 portc = 0x00;
 PWM1_Init(5000);
 PWM1_Start();
 PWM1_Set_Duty(duty);

 while(1)
 {
 med = ADC_Read(0);
 med = (med*12)/1023;
 if(med < 10)
 {
 mult = med*10;
 med_d = mult/10;
 med_u = mult%10;
 }
 else
 {
 mult = med;
 med_d = mult/10;
 med_u = mult%10;
 }
 control_veloc();
 }
}

int display(int pos)
{
 int number;

 int display[] = {192, 249, 164,176, 153, 146, 130, 248, 128, 144};
 number = display[pos];
 return(number);
}

void control_veloc()
{
 if( portc.f0  == 0)
 {
 portc.f0 = 1;
 duty = duty + 1;
 PWM1_Set_Duty(duty);
 if(duty >= 250)
 {
 duty = 250;
 }
 delay_ms(200);
 }
 if( portc.f1  == 0)
 {
 portc.f0 = 0;
 duty = duty - 1;
 PWM1_Set_Duty(duty);
 if(duty <= 39)
 {
 duty = 39;
 }
 delay_ms(200);
 }
}
