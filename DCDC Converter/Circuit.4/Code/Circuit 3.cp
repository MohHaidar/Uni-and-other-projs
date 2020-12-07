#line 1 "C:/Users/Mohammad.Haidar/Desktop/PhD research/Circuits and Simulations/Circuit ver.3/code/Circuit 3.c"
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







 OSCCON.b6 = 1;
 OSCCON.b5 = 1;
 OSCCON.b4 = 0;
 OSCCON.b3 = 1;



 CM1CON0.b7 = 0;
 CM2CON0.b7 = 0;
 CM3CON0.b7 = 0;
 CM4CON0.b7 = 0;




 FVRCON.b7 = 1;
 FVRCON.b1 = 1;
 FVRCON.b0 = 0;

 ADCON0 = 0b00000001;
 ADCON1 = 0b11010001;
 ADCON2 = 0b00001111;
 delay_us(30);




 ANSELA.b3 = 1;
 ANSELA.b2 = 1;
 ANSELA.b1 = 1;
 ANSELA.b0 = 1;


 TRISA.b3 = 1;
 TRISA.b2 = 1;
 TRISA.b1 = 1;
 TRISA.b0 = 1;
 TRISB.b0 = 1;


 TRISA.b4 = 0;
 TRISB.b2 = 0;
 TRISC.b1 = 0;

 OPTION_REG.b7 = 1;




 PSMC1CLK = 0b00000000;


 PSMC1PRH = 0x01;
 PSMC1PRL = 0x8F;



 set_DC(100);


 PSMC1PHH = 0x00;
 PSMC1PHL = 0x00;


 PSMC1OEN.b0 = 1;
 PSMC1STR0.b0 = 1;
 PSMC1POL = 0b00000000;


 PSMC1PRS = 0b00000001;
 PSMC1PHS = 0b00000001;
 PSMC1DCS = 0b00000001;


 PSMC1CON = 0b11000000;


 TRISC.b0 = 0;



 PIE4.b4 = 1;
 INTCON.b6 = 1;
 INTCON.b7 = 1;
 PSMC1INT.b5 = 1;




 UART1_Init(9600);
 maximize();




 }




void interrupt (void){

 if(PIR4.b4 && PSMC1INT.b1) {
 PSMC1INT.b1 = 0;
 PIR4.b4 = 0;
 V_RDY = 1;
 }
 }





void set_DC(int duty) {
 PSMC1DCL=(char) (duty & 0x00FF);
 PSMC1DCH= (char)((duty & 0xFF00)>>8);
 PSMC1CON.b6 = 1;
 }


int ResultADC(){
 int ms,ls;
 char text[8];
 ms = ((int)ADRESH)<<8;
 ls = (int)ADRESL ;
 return ms +ls;
}

float ReadVoltage(int channel){
 int i, VLT,n=4;
 float sum = 0.0, V;
 ChannelSet(channel);
 for(i=0;i<n;i++){

 V_RDY = 0;
 while(V_RDY==0){}



 ADCON0.B1 = 1 ;
 while(ADCON0.B1 == 1){}
 VLT = ResultADC();

 VLT = (VLT & 0b0000111111111111) - (VLT & 0b0001000000000000);
 V = (float)VLT;
 sum += V;

 }

 sum = V_DIV*sum;
 return sum/n/2.0;

 }

float read_AC(){

 float V,max,read_time,f_min,t_max,n_max;
 int i;

 read_time = 4.48/1000.0;
 f_min = 10.0;
 t_max = 1/f_min;
 n_max = (int)(t_max/read_time);
 max=0.0;
 for(i=0;i<n_max;i++){

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





 float P[2],dP,slope,K,V,V_core,thr;
 int D[2],dD,m,i,step,Low=0,reset=0;
 char text[8];



 D[0] = 25;
 step = 5;
 thr = 5.0;
 dD = step;
 m=2;




 set_DC(D[0]);

 V = read_AC()/1000.0;
 P[0] = 1000.0*pow((V*(float)D[0]/400.0),2);

mainloop:

 inttostr((int)D[1], text);
 uart1_write_text(text);
 uart1_write_text(" , ");
 floattostr(P[1], text);
 uart1_write_text(text);
 uart1_write_text("\n");

 D[1] = D[0] + dD;
 set_DC(D[1]);


 V_core=ReadVoltage(1);
 reset=0;


 if(V_core<2000.0){
 uart1_write_text("Low \n");
 dD=0;
 Low=1;}
 else
 if(V_core>2200.0)
 Low=0;



 while(V_core<1800.0){
 set_DC(25);
 delay_ms(5);
 V_core=ReadVoltage(1);
 reset=1;
 }


 P[1]=0.0;


 for (i=0;i<m;i++){
 V = read_AC()/1000.0;
 P[1] += 1000.0*pow((V*(float)D[1]/400.0),2);
 }
 P[1] = P[1]/(float)m;

 if(reset==0){

 dP = P[1] - P[0];


 if(dD==0){
 if((dP>thr)&&(Low==0))
 dD = step;
 if(dP<-thr)
 dD =-step;
 }
 else
 if((dP<thr)&&(dP>0.0))
 dD=0;
 else
 if((dP>-thr)&&(dP<=0.0)){
 D[1] = D[0];
 dD=0;}
 else
 if(dP<0.0)
 dD = -dD;

 if(D[1] + dD > 150)
 dD = -step;
 if(D[1] + dD < 25)
 dD = step;
 }
 else{
 D[1] = 25;
 dD = step;
 }



 D[0] = D[1];
 P[0] = P[1];

goto mainloop;

}
