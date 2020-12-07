%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                 Initialisation                   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 470e-6; % 470 uH
C=10e-3;  %10 mF
Rsw = 0.5;
%Vd=300e-3;  % 300 mV
Vt = 25.4e-3; % thermal voltage
Is = 2e-6; %leakeage current
Vip = 9;
f = 10;
T = 1/f;
W = 2*pi*f;
Vo = 0; % Vo initial =0
Ton = 25e-6;  %25 us
Tck = 200e-6;  %200 us

%% Input the simulation time

prompt = {'Enter simulation time in sec:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0.2'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
time = str2num(cell2mat(answer));
N=time/200e-6;  %t = N*Tck = 1000*200us = 200 ms


t = Tck*(1:N); %Horizontal axis scale
Vi = Vip*sin(W*t);
Vi = abs(Vi)/2;
%Vi = ones(1,N)*9;
%plot(t,Vi)
Ip = 0;
Irms = 0;
Vsw = 0;
Td = zeros(1,N);
V = zeros(1,N);
Ei = zeros(1,N);
Ed = zeros(1,N);
Esw = zeros(1,N);
DeltaT = zeros(1,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                    For loop                      %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:(N-1) 
Ip = Vi(i)*Ton/L;
Irms = Ip/sqrt(3);
Vsw = Irms*Rsw;
Vd = Vt*log(1+(Irms/Is));
Ei(i+1) = (Ton*Vi(i))^2/(2*L)+Ei(i);
v=V(i);
v=(L*Ip^2)/(2*C*(v+Vd+Vsw))+v;
V(i+1) = v;
Td(i+1) = (L*Ip)/(Vd+v+Vsw);
Ed(i+1)=(Vd*Irms)*Td(i+1)+Ed(i);
Esw(i+1) = Rsw*Irms^2*Td(i+1)+Esw(i);
DeltaT(i) = Td(i)-Td(i+1);
end

%% Energy and efficiency calculaion
Eo = C/2*V.^2;
eff = 100*Eo./Ei;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                      Plot                        %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Discharge time
figure
subplot(2, 1, 1);
plot(t,Td)
title('Td');
xlabel('time (sec)')
ylabel('sec')
grid on
subplot(2, 1, 2);
plot(t,DeltaT);
xlabel('time (sec)')
ylabel('sec')
title('Delta Td');
grid on

%% Voltage
figure
plot(t,V)
title('Vin // Vout')
xlabel('time (sec)')
ylabel('V')
grid on
hold
plot(t,Vi)

%% Energy
figure
plot(t,Ei)
title('Ein  ;  Ed  ;  Eo  ;  Er  ;  Er+Esw+Eo')
xlabel('time (sec)')
ylabel('J')
grid on
hold
plot(t,Ed)
plot(t,Eo)
plot(t,Esw)
plot(t,Eo+Ed+Esw)

%% Power
figure
plot(t,Ei./t)
title('Pin  ;  Pd  ;  Po  ;  Pr  ;  Pr+Psw+Po')
xlabel('time (sec)')
ylabel('W')
grid on
hold
plot(t,Ed./t)
plot(t,Eo./t)
plot(t,Esw./t)
plot(t,(Eo+Ed+Esw)./t)




%% Effieciency
figure
plot(t,eff);
xlabel('time (sec)')
ylabel('%')
title('Efficiency');
grid on

