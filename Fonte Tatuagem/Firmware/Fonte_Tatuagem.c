int cont = 0;
int disp1 = 0;
int disp2 = 0;
unsigned short duty;
int display[] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
unsigned Flag=0;
 /*
unsigned char Display(unsigned char no)
    {
    unsigned char Pattern;
    unsigned char display[] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
    Pattern=display[no]; //para retornar o Pattern
    return(Pattern);
}//end função   */

void interrupt()                  //função de interrupção, endereço 0x04 de memória
{
 if(T0IF_bit)                    //Verifica se houve overflow do timer 0
 {
  cont++;
  TMR0 = 0x00;                   //Reinicia Timer 0
  T0IF_bit = 0x00;               //Limpa registrador para a proxima interrupção
 }
}

void main() 
{
 option_reg = 0x81;              //Desabilita os resistores de pull-up da porta B e configura prescaler para 1:4
 GIE_bit = 0x01;                 //Habilita interrupção global
 PEIE_bit = 0x01;                //Habilita interrupção por periféricos
 T0IE_bit = 0x01;                //Habilita interrupção pelo overfolw do timer 0
 TMR0 = 0x00;                    //Inicia timer em zero
 adcon1 = 0x0e;
 porta = 0x00;
 trisa = 0x01;
 portb = 0x00;
 trisb = 0x00;
 portc = 0x00;
 trisc = 0x00;
 PWM1_Init(5000);                //Inicializa PWM1 com 5kHz
 
 duty = 39;
 PWM1_Start();                   //Inicia PWM1
 PWM1_Set_Duty(duty);            //Configura Duty Cicle positivo
 
 while(1)
 {
  /*
  #  1/(16e6/4) = 250nS de ciclo de máquina
  #
  #  ciclo * prescaler * tempo desejado
  #  250e-9 * 4 *256 * 25mS = 6,91 =~ 7           */
  
  if(cont == 2)
  {

      //portc.f0 = !portc.f0;
      cont = 0;
  }
 }

     
}