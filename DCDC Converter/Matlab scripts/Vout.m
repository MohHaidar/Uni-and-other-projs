L = 470e-6; % 470 uH
C=10e-3;  %10 mF
Vd=300e-3;  % 300 mV
Vi = 9;
Vo = 0; % Vo initial =0
Ton = 25e-6;  %25 us
Tck = 200e-6;  %200 us
N=1000;  %t = N*T = 1000*200us = 200 ms
t = Tck*(1:N); %Horizontal axis scale
Eo=0;

Ip = Vi*Ton/L;
Td = (L*Ip)/Vd;
V=Vo;
E=Eo;
DeltaT = 0;

for i = 1:N-1  % t = n*Tck = 1000*200us = 200 ms
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
title('Delta Td');
xlabel('time (sec)')
grid on
figure
plot(t,V)
xlabel('time (sec)')
title('Vout')
grid on
figure
plot(t,E)
title('Ec')
xlabel('time (sec)')
grid on