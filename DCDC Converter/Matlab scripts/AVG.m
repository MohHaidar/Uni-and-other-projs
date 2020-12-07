%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                 Initialisation                   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 470e-6; % 470 uH
C=10e-3;  %10 mF
Rsw = 0.5;%switch ON resistance
%Vd=300e-3;  % 300 mV
Vt = 25.4e-3; % thermal voltage
Is = 2e-6; %leakeage current
Vip = 9;% V input peak
f = 10;% Vin freq
T = 1/f;% period
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
Vi = abs(Vi)/2;%full wave rectificaion
%Vi = ones(1,N)*9;
%plot(t,Vi)
Ip = 0;%initial Ipeak
Irms = 0;%initial Irms
Vsw = 0;%initial Vswitch
Td = zeros(1,N);
V = zeros(1,N);
Eil = zeros(1,N);%Ein delivered to the coil
Ei = zeros(1,N);%Ein delivered to the circuit
Ed = zeros(1,N);
Esw = zeros(1,N);
Esw1 = zeros(1,N);
%VD = zeros(1,N);
DeltaT = zeros(1,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                    For loop                      %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:(N-1) 
Ip = Vi(i)*Ton/(L+Rsw*Ton);
Iavg = Ip/2;
Vsw = Iavg*Rsw;
Vd = Vt*log(1+(Iavg/Is));
%VD(i+1)=Vd;
Ei(i+1) = Vi(i)*Iavg*Ton+Ei(i);
Eil(i+1) = L*(Ton*Vi(i))^2/(2*(L+Rsw*Ton)^2)+Eil(i);
Esw1(i+1) = 2*Rsw*Iavg^2*Ton+Esw1(i);
v=V(i);
v=(L*Ip^2)/(2*C*(v+Vd+Vsw))+v;
V(i+1) = v;
Td(i+1) = (L*Ip)/(Vd+v+Vsw);
Ed(i+1)=(Vd*Iavg)*Td(i+1)+Ed(i);
Esw(i+1) = Rsw*Iavg^2*Td(i+1)+Esw(i);
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
plot(t,Eil)
title('Ein  ;  Eout  ;  Ed  ;  Esw  ;  Eout+Ed+Esw')
xlabel('time (sec)')
ylabel('J')
grid on
hold
plot(t,Eo)
plot(t,Ed)
plot(t,Esw)
plot(t,Eo+Ed+Esw)

figure
plot(t,Ei)
title('Ein  ;  Esw  ;  El  ;  Esw+El')
xlabel('time (sec)')
ylabel('J')
grid on
hold
plot(t,Esw1)
plot(t,Eil)
plot(t,Esw1+Eil)

%% Power
figure
%plot(t,Eil./t)
%title('Pin  ;  Pout  ;  Pd  ;  Psw  ;  Pout+Pd+Psw')
title('Pin  ;  Psw1  ;  Pl   ;  Pd  ;  Psw2 ; Pout ')
xlabel('time (sec)')
ylabel('W')
grid on
hold
plot(t,Ei./t)
plot(t,Esw1./t)
plot(t,Eil./t)
plot(t,Ed./t)
plot(t,Esw./t)
plot(t,Eo./t)
%plot(t,(Eo+Ed+Esw)./t)

%figure

%title('Pin  ;  Psw  ;  Pl  ;  Psw+Pl')
%xlabel('time (sec)')
%ylabel('W')
%grid on
%hold

%plot(t,(Esw1+Eil)./t)

%% Effieciency
figure
plot(t,eff);
xlabel('time (sec)')
ylabel('%')
title('Efficiency');
grid on

V1=V;
eff1=eff;