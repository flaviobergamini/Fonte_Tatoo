#define d1_decimal portc.f4
#define d2_unidade portc.f3
#define mais portc.f0
#define menos portc.f1

int control = 1, med_d= 0, med_u = 0, mult;
unsigned short duty = 38.7;
float med;

int display(int pos);
void control_veloc();

void interrupt()                  //função de interrupção, endereço 0x04 de memória
{
    if(T0IF_bit)                    //Verifica se houve overflow do timer 0
    {
        T0IF_bit = 0x00;               //Limpa registrador para a proxima interrupção

        if(d2_unidade == 0 && control == 1)
        {
            d1_decimal = 0x00;
            d2_unidade = 0x00;
            portb.f7 = 1;
            portb = 0;
            d2_unidade = 0x01;
            portb = display(med_u);
            control = 0x02;
        }
        else if(d1_decimal == 0 && control == 2)
        {
            d1_decimal = 0x00;
            d2_unidade = 0x00;
            portb.f7 = 1;
            portb = 0;
            d1_decimal = 0x01;
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
       ADCON1 = 14;                    //Habilita a leitura analógica
       intcon = 0xA0;                  //Habilita a interrupção global e a interrupção do timer 0
       option_reg = 0x83;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:16
       porta = 0x00;
       trisa = 0x00;
       portb = 0x00;
       trisb = 0x00;
       trisc = 0b10000011;
       portc = 0x00;
       PWM1_Init(5000);               //Inicializa PWM1 com 18kHz
       PWM1_Start();                   //Inicia PWM1
       PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo
       
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
    //int display[] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};       // Para display Catodo comum
    int display[] = {192, 249, 164,176, 153, 146, 130, 248, 128, 144}; // Para display Anodo comum
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