
_main:

;Circuit 3.c,13 :: 		void main() {
;Circuit 3.c,22 :: 		OSCCON.b6 = 1;
	BSF        OSCCON+0, 6
;Circuit 3.c,23 :: 		OSCCON.b5 = 1;
	BSF        OSCCON+0, 5
;Circuit 3.c,24 :: 		OSCCON.b4 = 0;
	BCF        OSCCON+0, 4
;Circuit 3.c,25 :: 		OSCCON.b3 = 1;
	BSF        OSCCON+0, 3
;Circuit 3.c,29 :: 		CM1CON0.b7 = 0;
	BCF        CM1CON0+0, 7
;Circuit 3.c,30 :: 		CM2CON0.b7 = 0;
	BCF        CM2CON0+0, 7
;Circuit 3.c,31 :: 		CM3CON0.b7 = 0;
	BCF        CM3CON0+0, 7
;Circuit 3.c,32 :: 		CM4CON0.b7 = 0;
	BCF        CM4CON0+0, 7
;Circuit 3.c,37 :: 		FVRCON.b7 = 1;
	BSF        FVRCON+0, 7
;Circuit 3.c,38 :: 		FVRCON.b1 = 1;
	BSF        FVRCON+0, 1
;Circuit 3.c,39 :: 		FVRCON.b0 = 0;
	BCF        FVRCON+0, 0
;Circuit 3.c,41 :: 		ADCON0 = 0b00000001;    //12 bit , channel 0 , enable ADC
	MOVLW      1
	MOVWF      ADCON0+0
;Circuit 3.c,42 :: 		ADCON1 = 0b11010011;    //2's complement result , Fosc/16 , Vref- = Vss , Vref+ = FVR
	MOVLW      211
	MOVWF      ADCON1+0
;Circuit 3.c,43 :: 		ADCON2 = 0b00001111;    //negative differential input is same as Vref-
	MOVLW      15
	MOVWF      ADCON2+0
;Circuit 3.c,44 :: 		delay_us(30);
	MOVLW      9
	MOVWF      R13
L_main0:
	DECFSZ     R13, 1
	GOTO       L_main0
	NOP
	NOP
;Circuit 3.c,49 :: 		ANSELA.b3 = 1;
	BSF        ANSELA+0, 3
;Circuit 3.c,50 :: 		ANSELA.b2 = 1;
	BSF        ANSELA+0, 2
;Circuit 3.c,51 :: 		ANSELA.b1 = 1;
	BSF        ANSELA+0, 1
;Circuit 3.c,52 :: 		ANSELA.b0 = 1;
	BSF        ANSELA+0, 0
;Circuit 3.c,55 :: 		TRISA.b3 = 1;
	BSF        TRISA+0, 3
;Circuit 3.c,56 :: 		TRISA.b2 = 1;
	BSF        TRISA+0, 2
;Circuit 3.c,57 :: 		TRISA.b1 = 1;
	BSF        TRISA+0, 1
;Circuit 3.c,58 :: 		TRISA.b0 = 1;
	BSF        TRISA+0, 0
;Circuit 3.c,59 :: 		TRISB.b0 = 1;
	BSF        TRISB+0, 0
;Circuit 3.c,62 :: 		TRISA.b4 = 0;
	BCF        TRISA+0, 4
;Circuit 3.c,63 :: 		TRISB.b2 = 0;
	BCF        TRISB+0, 2
;Circuit 3.c,64 :: 		TRISC.b1 = 0;
	BCF        TRISC+0, 1
;Circuit 3.c,66 :: 		OPTION_REG.b7 = 1;  // disable weak pullups
	BSF        OPTION_REG+0, 7
;Circuit 3.c,71 :: 		PSMC1CLK = 0b00000000;
	CLRF       PSMC1CLK+0
;Circuit 3.c,74 :: 		PSMC1PRH = 0x01;
	MOVLW      1
	MOVWF      PSMC1PRH+0
;Circuit 3.c,75 :: 		PSMC1PRL = 0x8F;
	MOVLW      143
	MOVWF      PSMC1PRL+0
;Circuit 3.c,78 :: 		PSMC1PHH = 0x00;
	CLRF       PSMC1PHH+0
;Circuit 3.c,79 :: 		PSMC1PHL = 0x00;
	CLRF       PSMC1PHL+0
;Circuit 3.c,82 :: 		PSMC1OEN.b0 = 1;
	BSF        PSMC1OEN+0, 0
;Circuit 3.c,83 :: 		PSMC1STR0.b0 = 1;
	BSF        PSMC1STR0+0, 0
;Circuit 3.c,84 :: 		PSMC1POL = 0b00000000;
	CLRF       PSMC1POL+0
;Circuit 3.c,87 :: 		PSMC1PRS = 0b00000001;
	MOVLW      1
	MOVWF      PSMC1PRS+0
;Circuit 3.c,88 :: 		PSMC1PHS = 0b00000001;
	MOVLW      1
	MOVWF      PSMC1PHS+0
;Circuit 3.c,89 :: 		PSMC1DCS = 0b00000001;
	MOVLW      1
	MOVWF      PSMC1DCS+0
;Circuit 3.c,92 :: 		PSMC1CON = 0b11000000;
	MOVLW      192
	MOVWF      PSMC1CON+0
;Circuit 3.c,95 :: 		TRISC.b0 = 0;
	BCF        TRISC+0, 0
;Circuit 3.c,99 :: 		set_DC(20);
	MOVLW      20
	MOVWF      FARG_set_DC+0
	MOVLW      0
	MOVWF      FARG_set_DC+1
	CALL       _set_DC+0
;Circuit 3.c,117 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:

;Circuit 3.c,122 :: 		void interrupt (void){                       ////
;Circuit 3.c,124 :: 		if(PIR4.b4 && PSMC1INT.b1) {            ////
	BTFSS      PIR4+0, 4
	GOTO       L_interrupt3
	BTFSS      PSMC1INT+0, 1
	GOTO       L_interrupt3
L__interrupt44:
;Circuit 3.c,125 :: 		PSMC1INT.b1 = 0;             ////
	BCF        PSMC1INT+0, 1
;Circuit 3.c,126 :: 		PIR4.b4 = 0;                 ////
	BCF        PIR4+0, 4
;Circuit 3.c,127 :: 		V_RDY = 1;                   ////
	MOVLW      1
	MOVWF      _V_RDY+0
	MOVLW      0
	MOVWF      _V_RDY+1
;Circuit 3.c,128 :: 		}                                       ////
L_interrupt3:
;Circuit 3.c,129 :: 		}                                          ////
L_end_interrupt:
L__interrupt50:
	RETFIE     %s
; end of _interrupt

_set_DC:

;Circuit 3.c,135 :: 		void set_DC(int duty) {
;Circuit 3.c,136 :: 		PSMC1DCL=(char) (duty & 0x00FF);
	MOVLW      255
	ANDWF      FARG_set_DC_duty+0, 0
	MOVWF      PSMC1DCL+0
;Circuit 3.c,137 :: 		PSMC1DCH= (char)((duty & 0xFF00)>>8);
	MOVLW      0
	ANDWF      FARG_set_DC_duty+0, 0
	MOVWF      R3
	MOVF       FARG_set_DC_duty+1, 0
	ANDLW      255
	MOVWF      R4
	MOVF       R4, 0
	MOVWF      R0
	CLRF       R1
	MOVF       R0, 0
	MOVWF      PSMC1DCH+0
;Circuit 3.c,138 :: 		PSMC1CON.b6 = 1;          //load buffer update
	BSF        PSMC1CON+0, 6
;Circuit 3.c,139 :: 		}
L_end_set_DC:
	RETURN
; end of _set_DC

_ResultADC:

;Circuit 3.c,142 :: 		int ResultADC(){
;Circuit 3.c,145 :: 		ms =  ((int)ADRESH)<<8;
	MOVF       ADRESH+0, 0
	MOVWF      R4
	CLRF       R5
	MOVF       R4, 0
	MOVWF      R3
	CLRF       R2
;Circuit 3.c,146 :: 		ls =  (int)ADRESL ;
	MOVF       ADRESL+0, 0
	MOVWF      R0
	CLRF       R1
;Circuit 3.c,147 :: 		return ms +ls;
	MOVF       R2, 0
	ADDWF      R0, 1
	MOVF       R3, 0
	ADDWFC     R1, 1
;Circuit 3.c,148 :: 		}
L_end_ResultADC:
	RETURN
; end of _ResultADC

_ReadVoltage:

;Circuit 3.c,150 :: 		float ReadVoltage(int channel){
;Circuit 3.c,151 :: 		int i, VLT,n=4;
	MOVLW      4
	MOVWF      ReadVoltage_n_L0+0
	MOVLW      0
	MOVWF      ReadVoltage_n_L0+1
	CLRF       ReadVoltage_sum_L0+0
	CLRF       ReadVoltage_sum_L0+1
	CLRF       ReadVoltage_sum_L0+2
	CLRF       ReadVoltage_sum_L0+3
;Circuit 3.c,153 :: 		ChannelSet(channel);
	MOVF       FARG_ReadVoltage_channel+0, 0
	MOVWF      FARG_ChannelSet+0
	MOVF       FARG_ReadVoltage_channel+1, 0
	MOVWF      FARG_ChannelSet+1
	CALL       _ChannelSet+0
;Circuit 3.c,154 :: 		for(i=0;i<n;i++){
	CLRF       ReadVoltage_i_L0+0
	CLRF       ReadVoltage_i_L0+1
L_ReadVoltage4:
	MOVLW      128
	XORWF      ReadVoltage_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      ReadVoltage_n_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ReadVoltage54
	MOVF       ReadVoltage_n_L0+0, 0
	SUBWF      ReadVoltage_i_L0+0, 0
L__ReadVoltage54:
	BTFSC      STATUS+0, 0
	GOTO       L_ReadVoltage5
;Circuit 3.c,156 :: 		V_RDY = 0;
	CLRF       _V_RDY+0
	CLRF       _V_RDY+1
;Circuit 3.c,157 :: 		while(V_RDY==0){}
L_ReadVoltage7:
	MOVLW      0
	XORWF      _V_RDY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ReadVoltage55
	MOVLW      0
	XORWF      _V_RDY+0, 0
L__ReadVoltage55:
	BTFSS      STATUS+0, 2
	GOTO       L_ReadVoltage8
	GOTO       L_ReadVoltage7
L_ReadVoltage8:
;Circuit 3.c,161 :: 		ADCON0.B1 = 1 ;
	BSF        ADCON0+0, 1
;Circuit 3.c,162 :: 		while(ADCON0.B1 == 1){}
L_ReadVoltage9:
	BTFSS      ADCON0+0, 1
	GOTO       L_ReadVoltage10
	GOTO       L_ReadVoltage9
L_ReadVoltage10:
;Circuit 3.c,163 :: 		VLT =  ResultADC();
	CALL       _ResultADC+0
;Circuit 3.c,165 :: 		VLT = (VLT & 0b0000111111111111) - (VLT & 0b0001000000000000);
	MOVLW      255
	ANDWF      R0, 0
	MOVWF      R2
	MOVF       R1, 0
	ANDLW      15
	MOVWF      R3
	MOVLW      0
	ANDWF      R0, 1
	MOVLW      16
	ANDWF      R1, 1
	MOVF       R0, 0
	SUBWF      R2, 0
	MOVWF      R0
	MOVF       R1, 0
	SUBWFB     R3, 0
	MOVWF      R1
;Circuit 3.c,166 :: 		V = (float)VLT;
	CALL       _Int2Double+0
;Circuit 3.c,167 :: 		sum += V;
	MOVF       ReadVoltage_sum_L0+0, 0
	MOVWF      R4
	MOVF       ReadVoltage_sum_L0+1, 0
	MOVWF      R5
	MOVF       ReadVoltage_sum_L0+2, 0
	MOVWF      R6
	MOVF       ReadVoltage_sum_L0+3, 0
	MOVWF      R7
	CALL       _Add_32x32_FP+0
	MOVF       R0, 0
	MOVWF      ReadVoltage_sum_L0+0
	MOVF       R1, 0
	MOVWF      ReadVoltage_sum_L0+1
	MOVF       R2, 0
	MOVWF      ReadVoltage_sum_L0+2
	MOVF       R3, 0
	MOVWF      ReadVoltage_sum_L0+3
;Circuit 3.c,154 :: 		for(i=0;i<n;i++){
	INCF       ReadVoltage_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       ReadVoltage_i_L0+1, 1
;Circuit 3.c,169 :: 		}
	GOTO       L_ReadVoltage4
L_ReadVoltage5:
;Circuit 3.c,171 :: 		sum = V_DIV*sum;
	MOVF       _V_DIV+0, 0
	MOVWF      R0
	MOVF       _V_DIV+1, 0
	MOVWF      R1
	MOVF       _V_DIV+2, 0
	MOVWF      R2
	MOVF       _V_DIV+3, 0
	MOVWF      R3
	MOVF       ReadVoltage_sum_L0+0, 0
	MOVWF      R4
	MOVF       ReadVoltage_sum_L0+1, 0
	MOVWF      R5
	MOVF       ReadVoltage_sum_L0+2, 0
	MOVWF      R6
	MOVF       ReadVoltage_sum_L0+3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVF       R0, 0
	MOVWF      FLOC__ReadVoltage+0
	MOVF       R1, 0
	MOVWF      FLOC__ReadVoltage+1
	MOVF       R2, 0
	MOVWF      FLOC__ReadVoltage+2
	MOVF       R3, 0
	MOVWF      FLOC__ReadVoltage+3
	MOVF       FLOC__ReadVoltage+0, 0
	MOVWF      ReadVoltage_sum_L0+0
	MOVF       FLOC__ReadVoltage+1, 0
	MOVWF      ReadVoltage_sum_L0+1
	MOVF       FLOC__ReadVoltage+2, 0
	MOVWF      ReadVoltage_sum_L0+2
	MOVF       FLOC__ReadVoltage+3, 0
	MOVWF      ReadVoltage_sum_L0+3
;Circuit 3.c,172 :: 		return sum/n/2.0;
	MOVF       ReadVoltage_n_L0+0, 0
	MOVWF      R0
	MOVF       ReadVoltage_n_L0+1, 0
	MOVWF      R1
	CALL       _Int2Double+0
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	MOVF       FLOC__ReadVoltage+0, 0
	MOVWF      R0
	MOVF       FLOC__ReadVoltage+1, 0
	MOVWF      R1
	MOVF       FLOC__ReadVoltage+2, 0
	MOVWF      R2
	MOVF       FLOC__ReadVoltage+3, 0
	MOVWF      R3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      0
	MOVWF      R6
	MOVLW      128
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;Circuit 3.c,174 :: 		}
L_end_ReadVoltage:
	RETURN
; end of _ReadVoltage

_read_AC:

;Circuit 3.c,176 :: 		float read_AC(){
;Circuit 3.c,184 :: 		n_max = (int)(t_max/read_time);
	MOVLW      0
	MOVWF      read_AC_n_max_L0+0
	MOVLW      0
	MOVWF      read_AC_n_max_L0+1
	MOVLW      48
	MOVWF      read_AC_n_max_L0+2
	MOVLW      131
	MOVWF      read_AC_n_max_L0+3
;Circuit 3.c,185 :: 		max=0.0;
	CLRF       read_AC_max_L0+0
	CLRF       read_AC_max_L0+1
	CLRF       read_AC_max_L0+2
	CLRF       read_AC_max_L0+3
;Circuit 3.c,186 :: 		for(i=0;i<n_max;i++){
	CLRF       read_AC_i_L0+0
	CLRF       read_AC_i_L0+1
L_read_AC11:
	MOVF       read_AC_i_L0+0, 0
	MOVWF      R0
	MOVF       read_AC_i_L0+1, 0
	MOVWF      R1
	CALL       _Int2Double+0
	MOVF       read_AC_n_max_L0+0, 0
	MOVWF      R4
	MOVF       read_AC_n_max_L0+1, 0
	MOVWF      R5
	MOVF       read_AC_n_max_L0+2, 0
	MOVWF      R6
	MOVF       read_AC_n_max_L0+3, 0
	MOVWF      R7
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_AC12
;Circuit 3.c,188 :: 		V=ReadVoltage(0);
	CLRF       FARG_ReadVoltage_channel+0
	CLRF       FARG_ReadVoltage_channel+1
	CALL       _ReadVoltage+0
	MOVF       R0, 0
	MOVWF      read_AC_V_L0+0
	MOVF       R1, 0
	MOVWF      read_AC_V_L0+1
	MOVF       R2, 0
	MOVWF      read_AC_V_L0+2
	MOVF       R3, 0
	MOVWF      read_AC_V_L0+3
;Circuit 3.c,189 :: 		if(V>max)
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	MOVF       read_AC_max_L0+0, 0
	MOVWF      R0
	MOVF       read_AC_max_L0+1, 0
	MOVWF      R1
	MOVF       read_AC_max_L0+2, 0
	MOVWF      R2
	MOVF       read_AC_max_L0+3, 0
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_AC14
;Circuit 3.c,190 :: 		max = V;
	MOVF       read_AC_V_L0+0, 0
	MOVWF      read_AC_max_L0+0
	MOVF       read_AC_V_L0+1, 0
	MOVWF      read_AC_max_L0+1
	MOVF       read_AC_V_L0+2, 0
	MOVWF      read_AC_max_L0+2
	MOVF       read_AC_V_L0+3, 0
	MOVWF      read_AC_max_L0+3
L_read_AC14:
;Circuit 3.c,186 :: 		for(i=0;i<n_max;i++){
	INCF       read_AC_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       read_AC_i_L0+1, 1
;Circuit 3.c,191 :: 		}
	GOTO       L_read_AC11
L_read_AC12:
;Circuit 3.c,192 :: 		return max;
	MOVF       read_AC_max_L0+0, 0
	MOVWF      R0
	MOVF       read_AC_max_L0+1, 0
	MOVWF      R1
	MOVF       read_AC_max_L0+2, 0
	MOVWF      R2
	MOVF       read_AC_max_L0+3, 0
	MOVWF      R3
;Circuit 3.c,193 :: 		}
L_end_read_AC:
	RETURN
; end of _read_AC

_ChannelSet:

;Circuit 3.c,195 :: 		void ChannelSet(int channel){
;Circuit 3.c,197 :: 		char c = (char)channel & 0x0F ;
	MOVLW      15
	ANDWF      FARG_ChannelSet_channel+0, 0
	MOVWF      R0+0
;Circuit 3.c,198 :: 		ADCON0.b5 = c.b3;
	BTFSC      R0+0, 3
	GOTO       L__ChannelSet58
	BCF        ADCON0+0, 5
	GOTO       L__ChannelSet59
L__ChannelSet58:
	BSF        ADCON0+0, 5
L__ChannelSet59:
;Circuit 3.c,199 :: 		ADCON0.b4 = c.b2;
	BTFSC      R0+0, 2
	GOTO       L__ChannelSet60
	BCF        ADCON0+0, 4
	GOTO       L__ChannelSet61
L__ChannelSet60:
	BSF        ADCON0+0, 4
L__ChannelSet61:
;Circuit 3.c,200 :: 		ADCON0.b3 = c.b1;
	BTFSC      R0+0, 1
	GOTO       L__ChannelSet62
	BCF        ADCON0+0, 3
	GOTO       L__ChannelSet63
L__ChannelSet62:
	BSF        ADCON0+0, 3
L__ChannelSet63:
;Circuit 3.c,201 :: 		ADCON0.b2 = c.b0;
	BTFSC      R0+0, 0
	GOTO       L__ChannelSet64
	BCF        ADCON0+0, 2
	GOTO       L__ChannelSet65
L__ChannelSet64:
	BSF        ADCON0+0, 2
L__ChannelSet65:
;Circuit 3.c,202 :: 		delay_us(30);
	MOVLW      9
	MOVWF      R13
L_ChannelSet15:
	DECFSZ     R13, 1
	GOTO       L_ChannelSet15
	NOP
	NOP
;Circuit 3.c,203 :: 		}
L_end_ChannelSet:
	RETURN
; end of _ChannelSet

_maximize:

;Circuit 3.c,206 :: 		void maximize(){
;Circuit 3.c,213 :: 		int D[2],dD,m,i,step,Low=0,reset=0;
	CLRF       maximize_Low_L0+0
	CLRF       maximize_Low_L0+1
	CLRF       maximize_reset_L0+0
	CLRF       maximize_reset_L0+1
;Circuit 3.c,218 :: 		D[0] = 25;        //25 to 150 for 4MHz,   10KHz PWM
	MOVLW      25
	MOVWF      maximize_D_L0+0
	MOVLW      0
	MOVWF      maximize_D_L0+1
;Circuit 3.c,219 :: 		step = 5;
	MOVLW      5
	MOVWF      maximize_step_L0+0
	MOVLW      0
	MOVWF      maximize_step_L0+1
;Circuit 3.c,220 :: 		thr = 5.0;
	MOVLW      0
	MOVWF      maximize_thr_L0+0
	MOVLW      0
	MOVWF      maximize_thr_L0+1
	MOVLW      32
	MOVWF      maximize_thr_L0+2
	MOVLW      129
	MOVWF      maximize_thr_L0+3
;Circuit 3.c,221 :: 		dD = step;
	MOVLW      5
	MOVWF      maximize_dD_L0+0
	MOVLW      0
	MOVWF      maximize_dD_L0+1
;Circuit 3.c,222 :: 		m=2;
	MOVLW      2
	MOVWF      maximize_m_L0+0
	MOVLW      0
	MOVWF      maximize_m_L0+1
;Circuit 3.c,227 :: 		set_DC(D[0]);
	MOVLW      25
	MOVWF      FARG_set_DC_duty+0
	MOVLW      0
	MOVWF      FARG_set_DC_duty+1
	CALL       _set_DC+0
;Circuit 3.c,229 :: 		V = read_AC()/1000.0;
	CALL       _read_AC+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      122
	MOVWF      R6
	MOVLW      136
	MOVWF      R7
	CALL       _Div_32x32_FP+0
	MOVF       R0, 0
	MOVWF      FLOC__maximize+0
	MOVF       R1, 0
	MOVWF      FLOC__maximize+1
	MOVF       R2, 0
	MOVWF      FLOC__maximize+2
	MOVF       R3, 0
	MOVWF      FLOC__maximize+3
	MOVF       maximize_D_L0+0, 0
	MOVWF      R0
	MOVF       maximize_D_L0+1, 0
	MOVWF      R1
	CALL       _Int2Double+0
;Circuit 3.c,230 :: 		P[0] =  1000.0*pow((V*(float)D[0]/400.0),2);
	MOVF       FLOC__maximize+0, 0
	MOVWF      R4
	MOVF       FLOC__maximize+1, 0
	MOVWF      R5
	MOVF       FLOC__maximize+2, 0
	MOVWF      R6
	MOVF       FLOC__maximize+3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      72
	MOVWF      R6
	MOVLW      135
	MOVWF      R7
	CALL       _Div_32x32_FP+0
	MOVF       R0, 0
	MOVWF      FARG_pow_x+0
	MOVF       R1, 0
	MOVWF      FARG_pow_x+1
	MOVF       R2, 0
	MOVWF      FARG_pow_x+2
	MOVF       R3, 0
	MOVWF      FARG_pow_x+3
	MOVLW      0
	MOVWF      FARG_pow_y+0
	MOVLW      0
	MOVWF      FARG_pow_y+1
	MOVLW      0
	MOVWF      FARG_pow_y+2
	MOVLW      128
	MOVWF      FARG_pow_y+3
	CALL       _pow+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      122
	MOVWF      R6
	MOVLW      136
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVF       R0, 0
	MOVWF      maximize_P_L0+0
	MOVF       R1, 0
	MOVWF      maximize_P_L0+1
	MOVF       R2, 0
	MOVWF      maximize_P_L0+2
	MOVF       R3, 0
	MOVWF      maximize_P_L0+3
;Circuit 3.c,232 :: 		mainloop:
___maximize_mainloop:
;Circuit 3.c,234 :: 		inttostr((int)D[1], text);
	MOVF       maximize_D_L0+2, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       maximize_D_L0+3, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      maximize_text_L0+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(maximize_text_L0+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;Circuit 3.c,235 :: 		uart1_write_text(text);
	MOVLW      maximize_text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(maximize_text_L0+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;Circuit 3.c,236 :: 		uart1_write_text(" , ");
	MOVLW      ?lstr1_Circuit_323+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(?lstr1_Circuit_323+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;Circuit 3.c,237 :: 		floattostr(P[1], text);
	MOVF       maximize_P_L0+4, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       maximize_P_L0+5, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       maximize_P_L0+6, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       maximize_P_L0+7, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      maximize_text_L0+0
	MOVWF      FARG_FloatToStr_str+0
	MOVLW      hi_addr(maximize_text_L0+0)
	MOVWF      FARG_FloatToStr_str+1
	CALL       _FloatToStr+0
;Circuit 3.c,238 :: 		uart1_write_text(text);
	MOVLW      maximize_text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(maximize_text_L0+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;Circuit 3.c,239 :: 		uart1_write_text("\n");
	MOVLW      ?lstr2_Circuit_323+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(?lstr2_Circuit_323+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;Circuit 3.c,241 :: 		D[1] = D[0] + dD;
	MOVF       maximize_dD_L0+0, 0
	ADDWF      maximize_D_L0+0, 0
	MOVWF      R0
	MOVF       maximize_dD_L0+1, 0
	ADDWFC     maximize_D_L0+1, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      maximize_D_L0+2
	MOVF       R1, 0
	MOVWF      maximize_D_L0+3
;Circuit 3.c,242 :: 		set_DC(D[1]);
	MOVF       R0, 0
	MOVWF      FARG_set_DC_duty+0
	MOVF       R1, 0
	MOVWF      FARG_set_DC_duty+1
	CALL       _set_DC+0
;Circuit 3.c,245 :: 		V_core=ReadVoltage(1);
	MOVLW      1
	MOVWF      FARG_ReadVoltage_channel+0
	MOVLW      0
	MOVWF      FARG_ReadVoltage_channel+1
	CALL       _ReadVoltage+0
	MOVF       R0, 0
	MOVWF      maximize_V_core_L0+0
	MOVF       R1, 0
	MOVWF      maximize_V_core_L0+1
	MOVF       R2, 0
	MOVWF      maximize_V_core_L0+2
	MOVF       R3, 0
	MOVWF      maximize_V_core_L0+3
;Circuit 3.c,246 :: 		reset=0;
	CLRF       maximize_reset_L0+0
	CLRF       maximize_reset_L0+1
;Circuit 3.c,249 :: 		if(V_core<2000.0){
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      122
	MOVWF      R6
	MOVLW      137
	MOVWF      R7
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize16
;Circuit 3.c,250 :: 		uart1_write_text("Low \n");
	MOVLW      ?lstr3_Circuit_323+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(?lstr3_Circuit_323+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;Circuit 3.c,251 :: 		dD=0;
	CLRF       maximize_dD_L0+0
	CLRF       maximize_dD_L0+1
;Circuit 3.c,252 :: 		Low=1;}
	MOVLW      1
	MOVWF      maximize_Low_L0+0
	MOVLW      0
	MOVWF      maximize_Low_L0+1
	GOTO       L_maximize17
L_maximize16:
;Circuit 3.c,254 :: 		if(V_core>2200.0)
	MOVF       maximize_V_core_L0+0, 0
	MOVWF      R4
	MOVF       maximize_V_core_L0+1, 0
	MOVWF      R5
	MOVF       maximize_V_core_L0+2, 0
	MOVWF      R6
	MOVF       maximize_V_core_L0+3, 0
	MOVWF      R7
	MOVLW      0
	MOVWF      R0
	MOVLW      128
	MOVWF      R1
	MOVLW      9
	MOVWF      R2
	MOVLW      138
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize18
;Circuit 3.c,255 :: 		Low=0;
	CLRF       maximize_Low_L0+0
	CLRF       maximize_Low_L0+1
L_maximize18:
L_maximize17:
;Circuit 3.c,259 :: 		while(V_core<1800.0){
L_maximize19:
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      97
	MOVWF      R6
	MOVLW      137
	MOVWF      R7
	MOVF       maximize_V_core_L0+0, 0
	MOVWF      R0
	MOVF       maximize_V_core_L0+1, 0
	MOVWF      R1
	MOVF       maximize_V_core_L0+2, 0
	MOVWF      R2
	MOVF       maximize_V_core_L0+3, 0
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize20
;Circuit 3.c,260 :: 		set_DC(25);
	MOVLW      25
	MOVWF      FARG_set_DC_duty+0
	MOVLW      0
	MOVWF      FARG_set_DC_duty+1
	CALL       _set_DC+0
;Circuit 3.c,261 :: 		delay_ms(5);
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_maximize21:
	DECFSZ     R13, 1
	GOTO       L_maximize21
	DECFSZ     R12, 1
	GOTO       L_maximize21
;Circuit 3.c,262 :: 		V_core=ReadVoltage(1);
	MOVLW      1
	MOVWF      FARG_ReadVoltage_channel+0
	MOVLW      0
	MOVWF      FARG_ReadVoltage_channel+1
	CALL       _ReadVoltage+0
	MOVF       R0, 0
	MOVWF      maximize_V_core_L0+0
	MOVF       R1, 0
	MOVWF      maximize_V_core_L0+1
	MOVF       R2, 0
	MOVWF      maximize_V_core_L0+2
	MOVF       R3, 0
	MOVWF      maximize_V_core_L0+3
;Circuit 3.c,263 :: 		reset=1;
	MOVLW      1
	MOVWF      maximize_reset_L0+0
	MOVLW      0
	MOVWF      maximize_reset_L0+1
;Circuit 3.c,264 :: 		}
	GOTO       L_maximize19
L_maximize20:
;Circuit 3.c,267 :: 		P[1]=0.0;
	CLRF       maximize_P_L0+4
	CLRF       maximize_P_L0+5
	CLRF       maximize_P_L0+6
	CLRF       maximize_P_L0+7
;Circuit 3.c,270 :: 		for (i=0;i<m;i++){
	CLRF       maximize_i_L0+0
	CLRF       maximize_i_L0+1
L_maximize22:
	MOVLW      128
	XORWF      maximize_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      maximize_m_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__maximize67
	MOVF       maximize_m_L0+0, 0
	SUBWF      maximize_i_L0+0, 0
L__maximize67:
	BTFSC      STATUS+0, 0
	GOTO       L_maximize23
;Circuit 3.c,271 :: 		V = read_AC()/1000.0;
	CALL       _read_AC+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      122
	MOVWF      R6
	MOVLW      136
	MOVWF      R7
	CALL       _Div_32x32_FP+0
	MOVF       R0, 0
	MOVWF      FLOC__maximize+0
	MOVF       R1, 0
	MOVWF      FLOC__maximize+1
	MOVF       R2, 0
	MOVWF      FLOC__maximize+2
	MOVF       R3, 0
	MOVWF      FLOC__maximize+3
	MOVF       maximize_D_L0+2, 0
	MOVWF      R0
	MOVF       maximize_D_L0+3, 0
	MOVWF      R1
	CALL       _Int2Double+0
;Circuit 3.c,272 :: 		P[1] += 1000.0*pow((V*(float)D[1]/400.0),2);
	MOVF       FLOC__maximize+0, 0
	MOVWF      R4
	MOVF       FLOC__maximize+1, 0
	MOVWF      R5
	MOVF       FLOC__maximize+2, 0
	MOVWF      R6
	MOVF       FLOC__maximize+3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      72
	MOVWF      R6
	MOVLW      135
	MOVWF      R7
	CALL       _Div_32x32_FP+0
	MOVF       R0, 0
	MOVWF      FARG_pow_x+0
	MOVF       R1, 0
	MOVWF      FARG_pow_x+1
	MOVF       R2, 0
	MOVWF      FARG_pow_x+2
	MOVF       R3, 0
	MOVWF      FARG_pow_x+3
	MOVLW      0
	MOVWF      FARG_pow_y+0
	MOVLW      0
	MOVWF      FARG_pow_y+1
	MOVLW      0
	MOVWF      FARG_pow_y+2
	MOVLW      128
	MOVWF      FARG_pow_y+3
	CALL       _pow+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      122
	MOVWF      R6
	MOVLW      136
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVF       maximize_P_L0+4, 0
	MOVWF      R4
	MOVF       maximize_P_L0+5, 0
	MOVWF      R5
	MOVF       maximize_P_L0+6, 0
	MOVWF      R6
	MOVF       maximize_P_L0+7, 0
	MOVWF      R7
	CALL       _Add_32x32_FP+0
	MOVF       R0, 0
	MOVWF      maximize_P_L0+4
	MOVF       R1, 0
	MOVWF      maximize_P_L0+5
	MOVF       R2, 0
	MOVWF      maximize_P_L0+6
	MOVF       R3, 0
	MOVWF      maximize_P_L0+7
;Circuit 3.c,270 :: 		for (i=0;i<m;i++){
	INCF       maximize_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       maximize_i_L0+1, 1
;Circuit 3.c,273 :: 		}
	GOTO       L_maximize22
L_maximize23:
;Circuit 3.c,274 :: 		P[1] = P[1]/(float)m;
	MOVF       maximize_m_L0+0, 0
	MOVWF      R0
	MOVF       maximize_m_L0+1, 0
	MOVWF      R1
	CALL       _Int2Double+0
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	MOVF       maximize_P_L0+4, 0
	MOVWF      R0
	MOVF       maximize_P_L0+5, 0
	MOVWF      R1
	MOVF       maximize_P_L0+6, 0
	MOVWF      R2
	MOVF       maximize_P_L0+7, 0
	MOVWF      R3
	CALL       _Div_32x32_FP+0
	MOVF       R0, 0
	MOVWF      maximize_P_L0+4
	MOVF       R1, 0
	MOVWF      maximize_P_L0+5
	MOVF       R2, 0
	MOVWF      maximize_P_L0+6
	MOVF       R3, 0
	MOVWF      maximize_P_L0+7
;Circuit 3.c,276 :: 		if(reset==0){                      //if we want to reset we skip the next lines unti the else statment
	MOVLW      0
	XORWF      maximize_reset_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__maximize68
	MOVLW      0
	XORWF      maximize_reset_L0+0, 0
L__maximize68:
	BTFSS      STATUS+0, 2
	GOTO       L_maximize25
;Circuit 3.c,278 :: 		dP = P[1] - P[0];
	MOVF       maximize_P_L0+0, 0
	MOVWF      R4
	MOVF       maximize_P_L0+1, 0
	MOVWF      R5
	MOVF       maximize_P_L0+2, 0
	MOVWF      R6
	MOVF       maximize_P_L0+3, 0
	MOVWF      R7
	MOVF       maximize_P_L0+4, 0
	MOVWF      R0
	MOVF       maximize_P_L0+5, 0
	MOVWF      R1
	MOVF       maximize_P_L0+6, 0
	MOVWF      R2
	MOVF       maximize_P_L0+7, 0
	MOVWF      R3
	CALL       _Sub_32x32_FP+0
	MOVF       R0, 0
	MOVWF      maximize_dP_L0+0
	MOVF       R1, 0
	MOVWF      maximize_dP_L0+1
	MOVF       R2, 0
	MOVWF      maximize_dP_L0+2
	MOVF       R3, 0
	MOVWF      maximize_dP_L0+3
;Circuit 3.c,281 :: 		if(dD==0){
	MOVLW      0
	XORWF      maximize_dD_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__maximize69
	MOVLW      0
	XORWF      maximize_dD_L0+0, 0
L__maximize69:
	BTFSS      STATUS+0, 2
	GOTO       L_maximize26
;Circuit 3.c,282 :: 		if((dP>thr)&&(Low==0))      //case when we have a change in power but not from the duty cycle step
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R4
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R5
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R6
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R7
	MOVF       maximize_thr_L0+0, 0
	MOVWF      R0
	MOVF       maximize_thr_L0+1, 0
	MOVWF      R1
	MOVF       maximize_thr_L0+2, 0
	MOVWF      R2
	MOVF       maximize_thr_L0+3, 0
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize29
	MOVLW      0
	XORWF      maximize_Low_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__maximize70
	MOVLW      0
	XORWF      maximize_Low_L0+0, 0
L__maximize70:
	BTFSS      STATUS+0, 2
	GOTO       L_maximize29
L__maximize47:
;Circuit 3.c,283 :: 		dD = step;             //we start stepping the duty cycle again but only if we are not in low power state
	MOVF       maximize_step_L0+0, 0
	MOVWF      maximize_dD_L0+0
	MOVF       maximize_step_L0+1, 0
	MOVWF      maximize_dD_L0+1
L_maximize29:
;Circuit 3.c,284 :: 		if(dP<-thr)
	MOVLW      0
	XORWF      maximize_thr_L0+0, 0
	MOVWF      R4
	MOVLW      0
	XORWF      maximize_thr_L0+1, 0
	MOVWF      R5
	MOVLW      128
	XORWF      maximize_thr_L0+2, 0
	MOVWF      R6
	MOVLW      0
	XORWF      maximize_thr_L0+3, 0
	MOVWF      R7
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R0
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R1
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R2
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize30
;Circuit 3.c,285 :: 		dD =-step;
	MOVF       maximize_step_L0+0, 0
	SUBLW      0
	MOVWF      maximize_dD_L0+0
	MOVF       maximize_step_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       maximize_dD_L0+1
	SUBWF      maximize_dD_L0+1, 1
L_maximize30:
;Circuit 3.c,286 :: 		}
	GOTO       L_maximize31
L_maximize26:
;Circuit 3.c,288 :: 		if((dP<thr)&&(dP>0.0))
	MOVF       maximize_thr_L0+0, 0
	MOVWF      R4
	MOVF       maximize_thr_L0+1, 0
	MOVWF      R5
	MOVF       maximize_thr_L0+2, 0
	MOVWF      R6
	MOVF       maximize_thr_L0+3, 0
	MOVWF      R7
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R0
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R1
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R2
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize34
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R4
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R5
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R6
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R7
	CLRF       R0
	CLRF       R1
	CLRF       R2
	CLRF       R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize34
L__maximize46:
;Circuit 3.c,289 :: 		dD=0;
	CLRF       maximize_dD_L0+0
	CLRF       maximize_dD_L0+1
	GOTO       L_maximize35
L_maximize34:
;Circuit 3.c,291 :: 		if((dP>-thr)&&(dP<=0.0)){
	MOVLW      0
	XORWF      maximize_thr_L0+0, 0
	MOVWF      R0
	MOVLW      0
	XORWF      maximize_thr_L0+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      maximize_thr_L0+2, 0
	MOVWF      R2
	MOVLW      0
	XORWF      maximize_thr_L0+3, 0
	MOVWF      R3
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R4
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R5
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R6
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R7
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize38
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R4
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R5
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R6
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R7
	CLRF       R0
	CLRF       R1
	CLRF       R2
	CLRF       R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize38
L__maximize45:
;Circuit 3.c,292 :: 		D[1] = D[0];
	MOVF       maximize_D_L0+0, 0
	MOVWF      maximize_D_L0+2
	MOVF       maximize_D_L0+1, 0
	MOVWF      maximize_D_L0+3
;Circuit 3.c,293 :: 		dD=0;}
	CLRF       maximize_dD_L0+0
	CLRF       maximize_dD_L0+1
	GOTO       L_maximize39
L_maximize38:
;Circuit 3.c,295 :: 		if(dP<0.0)              //normal case reverse the step if dP is negative
	CLRF       R4
	CLRF       R5
	CLRF       R6
	CLRF       R7
	MOVF       maximize_dP_L0+0, 0
	MOVWF      R0
	MOVF       maximize_dP_L0+1, 0
	MOVWF      R1
	MOVF       maximize_dP_L0+2, 0
	MOVWF      R2
	MOVF       maximize_dP_L0+3, 0
	MOVWF      R3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_maximize40
;Circuit 3.c,296 :: 		dD = -dD;
	MOVF       maximize_dD_L0+0, 0
	SUBLW      0
	MOVWF      maximize_dD_L0+0
	MOVF       maximize_dD_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       maximize_dD_L0+1
	SUBWF      maximize_dD_L0+1, 1
L_maximize40:
L_maximize39:
L_maximize35:
L_maximize31:
;Circuit 3.c,298 :: 		if(D[1] + dD > 150)              //keep the duty cycle values inside the limits
	MOVF       maximize_dD_L0+0, 0
	ADDWF      maximize_D_L0+2, 0
	MOVWF      R1
	MOVF       maximize_dD_L0+1, 0
	ADDWFC     maximize_D_L0+3, 0
	MOVWF      R2
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__maximize71
	MOVF       R1, 0
	SUBLW      150
L__maximize71:
	BTFSC      STATUS+0, 0
	GOTO       L_maximize41
;Circuit 3.c,299 :: 		dD = -step;
	MOVF       maximize_step_L0+0, 0
	SUBLW      0
	MOVWF      maximize_dD_L0+0
	MOVF       maximize_step_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       maximize_dD_L0+1
	SUBWF      maximize_dD_L0+1, 1
L_maximize41:
;Circuit 3.c,300 :: 		if(D[1] + dD < 25)
	MOVF       maximize_dD_L0+0, 0
	ADDWF      maximize_D_L0+2, 0
	MOVWF      R1
	MOVF       maximize_dD_L0+1, 0
	ADDWFC     maximize_D_L0+3, 0
	MOVWF      R2
	MOVLW      128
	XORWF      R2, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__maximize72
	MOVLW      25
	SUBWF      R1, 0
L__maximize72:
	BTFSC      STATUS+0, 0
	GOTO       L_maximize42
;Circuit 3.c,301 :: 		dD = step;
	MOVF       maximize_step_L0+0, 0
	MOVWF      maximize_dD_L0+0
	MOVF       maximize_step_L0+1, 0
	MOVWF      maximize_dD_L0+1
L_maximize42:
;Circuit 3.c,302 :: 		}
	GOTO       L_maximize43
L_maximize25:
;Circuit 3.c,304 :: 		D[1] = 25;                       //resetting the algorithm
	MOVLW      25
	MOVWF      maximize_D_L0+2
	MOVLW      0
	MOVWF      maximize_D_L0+3
;Circuit 3.c,305 :: 		dD = step;
	MOVF       maximize_step_L0+0, 0
	MOVWF      maximize_dD_L0+0
	MOVF       maximize_step_L0+1, 0
	MOVWF      maximize_dD_L0+1
;Circuit 3.c,306 :: 		}
L_maximize43:
;Circuit 3.c,310 :: 		D[0] = D[1];
	MOVF       maximize_D_L0+2, 0
	MOVWF      maximize_D_L0+0
	MOVF       maximize_D_L0+3, 0
	MOVWF      maximize_D_L0+1
;Circuit 3.c,311 :: 		P[0] = P[1];
	MOVF       maximize_P_L0+4, 0
	MOVWF      maximize_P_L0+0
	MOVF       maximize_P_L0+5, 0
	MOVWF      maximize_P_L0+1
	MOVF       maximize_P_L0+6, 0
	MOVWF      maximize_P_L0+2
	MOVF       maximize_P_L0+7, 0
	MOVWF      maximize_P_L0+3
;Circuit 3.c,313 :: 		goto mainloop;
	GOTO       ___maximize_mainloop
;Circuit 3.c,315 :: 		}
L_end_maximize:
	RETURN
; end of _maximize
