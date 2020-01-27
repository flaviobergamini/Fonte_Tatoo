#define d1_decimal portc.f3
#define d2_unidade portc.f4
#define mais portc.f0
#define menos portc.f1

int control = 1;
unsigned short duty = 38.7;
float med;

int display(int pos);
void control_veloc();

void interrupt()                  //fun��o de interrup��o, endere�o 0x04 de mem�ria
{
    if(T0IF_bit)                    //Verifica se houve overflow do timer 0
    {
        T0IF_bit = 0x00;               //Limpa registrador para a proxima interrup��o
  
        if(d1_decimal == 0 && control == 1)
        {
            d1_decimal = 0x00;
            d2_unidade = 0x00;
            portb = 0;
            d1_decimal = 0x01;
            portb = display(3);
            control = 0x02;
        }
        else if(d2_unidade == 0 && control == 2)
        {
            d1_decimal = 0x00;
            d2_unidade = 0x00;
            portb = 0;
            d2_unidade = 0x01;
            portb = display(2);
            control = 0x01;
        }
     }
}

void main() 
{
       //cmcon = 0x07;                   //desabilita os comparadores internos da porta B
       ADCON0 = 14;
       intcon = 0xA0;                  //Habilita a interrup��o global e a interrup��o do timer 0
       option_reg = 0x83;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:16
       //GIE_bit = 0x01;                 //Habilita interrup��o global
       //PEIE_bit = 0x01;                //Habilita interrup��o por perif�ricos
       //T0IE_bit = 0x01;                //Habilita interrup��o pelo overfolw do timer 0
       //TMR0 = 0x00;                    //Inicia timer em zero
       porta = 0x00;
       trisa = 0x00;
       portb = 0x00;
       trisb = 0x00;
       portc = 0x00;
       trisc = 0b00000011;
       PWM1_Init(5000);               //Inicializa PWM1 com 18kHz
       portc.f0 = 0;
       PWM1_Start();                   //Inicia PWM1
       PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo

       while(1)
       {
            med = ADC_Read(0);
            med = 12 - ((med*12)/1023);
            if(med > 7.5)
               portb.f7 = 1;
            else
               portb.f7 = 0;
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
   if(mais == 0)
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
   if(menos == 0)
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