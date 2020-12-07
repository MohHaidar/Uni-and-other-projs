void set_DC(int);
void ChannelSet(int);
void maximize(void);
float ReadVoltage(int);
float read_AC(void);
int ResultADC(void);

int V_RDY = 0;
float V_DIV = 5.25;
float V_REF = 2048.0;


void main() {
     char text[8];
 
     //Setting Oscillator frequency OSCCON<6:3>
     //1110 = 8 MHz
     //1101 = 4MHz HF
     //1011 = 1MHz HF
     //1010 = 500 kHz
     
     OSCCON.b6 = 1;
     OSCCON.b5 = 0;
     OSCCON.b4 = 1;
     OSCCON.b3 = 1;
     //If we change Fosc, we change also the PWM period configuration, duty cycle values, ADC clock and voltage measurement time in the ReadVoltage func

     //Disable comparators for no power consuming
     CM1CON0.b7 = 0;
     CM2CON0.b7 = 0;
     CM3CON0.b7 = 0;
     CM4CON0.b7 = 0;

     //ADC configuration

     //FVR (fixed voltage reference) enabled and set to 2.024V
     FVRCON.b7 = 1;
     FVRCON.b1 = 1;
     FVRCON.b0 = 0;
     //ADC 12 bit enable and fixed voltage ref
     ADCON0 = 0b00000001;    //12 bit , channel 0 , enable ADC
     ADCON1 = 0b11010001;    //2's complement result , Fosc/16 , Vref- = Vss , Vref+ = external
     ADCON2 = 0b00001111;    //negative differential input is same as Vref-
     delay_us(30);



     //Analog pins  RA0,1,2,3
     ANSELA.b3 = 1;
     ANSELA.b2 = 1;
     ANSELA.b1 = 1;
     ANSELA.b0 = 1;

     //pins RA0,1,2,3,RB0  inputs /// RA4,RB2,RC1 outputs
     TRISA.b3 = 1;
     TRISA.b2 = 1;
     TRISA.b1 = 1;
     TRISA.b0 = 1;
     TRISB.b0 = 1;


     TRISA.b4 = 0;
     TRISB.b2 = 0;
     TRISC.b1 = 0;

     OPTION_REG.b7 = 1;  // disable weak pullups

     //////// PWM configuration /////////

     //set clock prescale
     PSMC1CLK = 0b00000000;

     //Set period: PSMC1PR = 399 /// period = PSMC1PR + 1 / FPSMC_clk(=FOSC)
     PSMC1PRH = 0x00;
     PSMC1PRL = 0xC7;

     //Set duty cycle
     //100% is equal to period  in register PSMC1PR<15:0> + 1
     set_DC(25);

     //Set phase to 0
     PSMC1PHH = 0x00;
     PSMC1PHL = 0x00;

     //single PWM output on PSMC1A
     PSMC1OEN.b0 = 1;
     PSMC1STR0.b0 = 1;
     PSMC1POL = 0b00000000;

     //config for period and duty cycle function
     PSMC1PRS = 0b00000001;
     PSMC1PHS = 0b00000001;
     PSMC1DCS = 0b00000001;

     //enable and load buffer
     PSMC1CON = 0b11000000;

     //enable output pin
     TRISC.b0 = 0;

     //////Interrupts////////

     PIE4.b4 = 1;      //enable PSMC1 interrupts
     INTCON.b6 = 1;    //enable peripheral interrupts
     INTCON.b7 = 1;    //enable all active interruprs
     PSMC1INT.b5 = 1;  //enable timebase duty cycle interrupts


     ///////////////////**** Main ****/////////////////
     //**********************************************//
     UART1_Init(9600);
     maximize();
     
     //**********************************************//
     //////////////////////////////////////////////////

 }

/////////////////////////////////////////////////
/////////////// Interrupt routine ///////////////
                                             ////
void interrupt (void){                       ////
                                             ////
     if(PIR4.b4 && PSMC1INT.b1) {            ////
                PSMC1INT.b1 = 0;             ////
                PIR4.b4 = 0;                 ////
                V_RDY = 1;                   ////
     }                                       ////
 }                                            ////
/////////////////////////////////////////////////
/////////////////////////////////////////////////


// Setting duty cycle from int
void set_DC(int duty) {
      PSMC1DCL=(char) (duty & 0x00FF);
      PSMC1DCH= (char)((duty & 0xFF00)>>8);
      PSMC1CON.b6 = 1;          //load buffer update
 }

// combining the ADRESH and ADRESL 8bit registers into 1 int
int ResultADC(){
    int ms,ls;
     char text[8];
    ms =  ((int)ADRESH)<<8;
    ls =  (int)ADRESL ;
    return ms +ls;
}

float ReadVoltage(int channel){
      int i, VLT,n=4;
      float sum = 0.0, V;
      char text[8];
      LATB.b2=0xFF;
      ChannelSet(channel);
      for(i=0;i<n;i++){
               //reset the flag and wait for the interrupt
               V_RDY = 0;
               while(V_RDY==0){}
               //V_RDY = 0;

          //start the conversion
          ADCON0.B1 = 1 ;
          while(ADCON0.B1 == 1){}
          VLT =  ResultADC();
          // 2's complement
          VLT = (VLT & 0b0000111111111111) - (VLT & 0b0001000000000000);
          V = (float)VLT;
          sum += V;

      }

      sum = V_DIV*sum;
      LATB.b2=0x00;
      return sum/n/4.096;

 }

float read_AC(){

  float V,max,read_time,f_min,t_max,n_max;
  int i;

    read_time = 11.3/1000.0;  // max read time in s
    f_min = 10.0;
    t_max = 1/f_min;
    n_max = (int)(t_max/read_time);
    max=0.0;
    for(i=0;i<n_max;i++){
                            //detect maximum in first period      fmin=10Hz
        V=ReadVoltage(0);
        if(V>max)
            max = V;
        }
     return max;
 }
  
void ChannelSet(int channel){
  
       char c = (char)channel & 0x0F ;
       ADCON0.b5 = c.b3;
       ADCON0.b4 = c.b2;
       ADCON0.b3 = c.b1;
       ADCON0.b2 = c.b0;
       delay_us(30);
 }
  
  
void maximize(){

     // We keep track of successive power and resistance values in P[0],P[1] and R[0],R[1]
     //the resistance is changed according to dP/dR
     //we set the resistance using set_R() that changes the duty cycle of PWM

     float P[2],dP,slope,K,V,V_core,thr;
     int D[2],dD,m,i,step,Low=0,reset=0;
     char text[8];

//// ******************** All tunable variables ******************** ////

     D[0] = 12;        //25 to 150 for 4MHz,   10KHz PWM
     step = 2;
     thr = 1.0;
     dD = step;
     m=2;

//// *************************************************************** ////

// Setting and measuring the first power
     set_DC(D[0]);
     
     V = read_AC()/1000.0;
     P[0] =  1000.0*pow((V*(float)D[0]/400.0),2);

mainloop:

      /*inttostr((int)D[1], text);
      uart1_write_text(text);
      uart1_write_text(",");
      floattostr(P[1], text);
      uart1_write_text(text);
      uart1_write_text("\n");     */
      
// stepping and measuring the power
     D[1] = D[0] + dD;
     set_DC(D[1]);
     
//Read the voltage from V_core
     V_core=ReadVoltage(1);
     reset=0;
//When V_Core is below the first threshold 2.2V we keep the current duty cycle and we stop the algorithm (low state)
//When V_Core is above the first threshold we exit the low state
     if(V_core<1800.0){
          dD=0;
          Low=1;}
     else
         if(V_core>2000.0)
             Low=0;
          
//When V_Core is below the swcond threshold 1.8V we reset the duty cycle and enter the critical state
//When V_Core goes above the second threshold we exit the critical state and reset the algorithm
     while(V_core<1800.0){
          set_DC(25);
          delay_ms(5);
          V_core=ReadVoltage(1);
          reset=1;
     }

     
     P[1]=0.0;
     
//Average power measurment
     for (i=0;i<m;i++){
          V = read_AC()/1000.0;
          P[1] += 1000.0*pow((V*(float)D[1]/400.0),2);
     }
     P[1] = P[1]/(float)m;

     if(reset==0){                      //if we want to reset we skip the next lines unti the else statment
//calculating dP
          dP = P[1] - P[0];

// Algo start (we can make it a separate function with its variables but we have to deal with D changes) :
          if(dD==0){
               if((dP>thr)&&(Low==0))      //case when we have a change in power but not from the duty cycle step
                    dD = step;             //we start stepping the duty cycle again but only if we are not in low power state
               if(dP<-thr)
                    dD =-step;
         }
         else                              //case where the dP becomes under the threshold
              if((dP<thr)&&(dP>0.0))
                   dD=0;
              else
                  if((dP>-thr)&&(dP<=0.0)){
                      D[1] = D[0];
                      dD=0;}
                  else
                      if(dP<0.0)              //normal case reverse the step if dP is negative
                          dD = -dD;
// End algo
          if(D[1] + dD > 75)              //keep the duty cycle values inside the limits
               dD = -step;
          if(D[1] + dD < 12)
               dD = step;
     }
     else{
          D[1] = 12;                       //resetting the algorithm
          dD = step;
     }


     // saving the previous values
     D[0] = D[1];
     P[0] = P[1];

goto mainloop;

}