%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                 Initialisation                   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 470e-6; % 470 uH
C=10e-3;  %10 mF
%Vd=100e-3;  % 300 mV
Vip = 9;
f = 10;
T = 1/f;
W = 2*pi*f;
%Vo = 0; % Vo initial =0
Ton = 25e-6;  %25 us
Tck = 200e-6;  %200 us

%% Input the simulation time

N=2500;  %t = N*Tck = 1000*200us = 200 ms


t = Tck*(1:N); %Horizontal axis scale
Vi = Vip*sin(W*t);
Vi = abs(Vi)/2;
%plot(t,Vi)



for Vd=0:100e-3:700e-3

Ip = 0;
Td = zeros(1,N);
V = zeros(1,N);
Ei = zeros(1,N);

DeltaT = zeros(1,N);;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                    For loop                      %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:(N-1) 
Ip = Vi(i)*Ton/L;
Ei(i+1) = (Ton*Vi(i))^2/(2*L)+Ei(i);
v=V(i);
v=(L*Ip^2)/(2*C*(v+Vd))+v;
V(i+1) = v;

Td(i+1) = (L*Ip)/(Vd+v);
DeltaT(i) = Td(i)-Td(i+1);
end

%% Energy and efficiency calculaion
Eo = C/2*V.^2;
eff = 100*Eo./Ei;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                      Plot                        %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Effieciency
plot(t,eff);
xlabel('time (sec)')
ylabel('%')
title('Efficiency');
grid on
hold on
end
