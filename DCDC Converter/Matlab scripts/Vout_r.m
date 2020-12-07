L = 470e-6; % 470 uH
C=10e-3;  %10 mF
Vd=300e-3;  % 300 mV
Vip = 9;
f = 10;
T = 1/f;
W = 2*pi*f;
Vo = 0; % Vo initial =0
Ton = 25e-6;  %25 us
Tck = 200e-6;  %200 us
Eo = 0;

N=1000;  %t = N*Tck = 1000*200us = 200 ms
t = Tck*(1:N); %Horizontal axis scale

Vi = Vip*sin(W*t);
Vi = abs(Vi)/2;
%plot(t,Vi)
Ip = 0;
Td = 0;
V=Vo;
E=Eo;
DeltaT = 0;

for i = 1:(N-1) 
Ip = Vi(i)*Ton/L;
v=V(i);
e=E(i);
e=(L^2*Ip^4)/(8*C*(v+Vd)^2)+e;
E=[E e];
v=(L*Ip^2)/(2*C*(v+Vd))+v;
V=[V v];
Td = [Td (L*Ip)/(Vd+v)];
DeltaT = [DeltaT Td(i)-Td(i+1)];
end


figure
subplot(2, 1, 1);
plot(t,Td)
title('Td');
xlabel('time (sec)')
grid on
subplot(2, 1, 2);
plot(t,DeltaT);
xlabel('time (sec)')
title('Delta Td');
grid on
figure
plot(t,V)
title('Vin//Vout')
xlabel('time (sec)')
grid on
hold
plot(t,Vi)
figure
plot(t,E)
title('Ec')
xlabel('time (sec)')
grid on
