#define d1_decimal portc.f3
#define d2_unidade portc.f4
#define mais porta.f0
#define menos porta.f1

int control = 1;
unsigned short duty = 39;

int display(int pos);
void control_veloc();

void interrupt()                  //função de interrupção, endereço 0x04 de memória
{
 if(T0IF_bit)                    //Verifica se houve overflow do timer 0
 {
  T0IF_bit = 0x00;               //Limpa registrador para a proxima interrupção
  
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
 cmcon = 0x07;                   //desabilita os comparadores internos da porta B
 intcon = 0xA0;                  //Habilita a interrupção global e a interrupção do timer 0
 option_reg = 0x83;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:16
 //GIE_bit = 0x01;                 //Habilita interrupção global
 //PEIE_bit = 0x01;                //Habilita interrupção por periféricos
 //T0IE_bit = 0x01;                //Habilita interrupção pelo overfolw do timer 0
 //TMR0 = 0x00;                    //Inicia timer em zero
 porta = 0x00;
 trisa = 0x03;
 portb = 0x00;
 trisb = 0x00;
 portc = 0x00;
 trisc = 0x00;
 PWM1_Init(5000);                //Inicializa PWM1 com 5kHz
 

 PWM1_Start();                   //Inicia PWM1
 PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo
 
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
   if(mais == 0)
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
   if(menos == 0)
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