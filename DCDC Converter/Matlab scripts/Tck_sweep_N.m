%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                 Initialisation                   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%L = 470e-6;
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
%Tck = 200e-6;


%% Input the simulation time

prompt = {'Enter Number of clocks N:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'5000'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
N = str2num(cell2mat(answer));

%% for sweep 

Tcki=100e-6:10e-6:1000e-6;
eff = zeros(1,length(Tcki));
for j = 1:length(Tcki)
Tck=Tcki(j);

%N=round(time/Tck);  %t = N*Tck = 1000*200us = 200 ms
%Tck = 150*Ton^2/L;
%Ton = sqrt(Tck*L/150);
L = 150*Ton^2/Tck;

t = Tck*(1:N); %Horizontal axis scale
n = 1:N;
Vi = Vip*sin(W*t);
Vi = abs(Vi)/2;
Vi = ones(1,N)*9;
%plot(t,Vi)
Ip = 0;
Irms = 0;
Vsw = 0;
Td = zeros(1,N);
V = zeros(1,N);
Eil = zeros(1,N);
Ei = zeros(1,N);
Ed = zeros(1,N);
Esw = zeros(1,N);
Esw1 = zeros(1,N);
%VD = zeros(1,N);
DeltaT = zeros(1,N);



%L = Li(j);

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
eff(j) = 100*Eo(N)./Eil(N);



end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                      Plot                        %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Effieciency
plot(Tcki,eff);
xlabel('Tck(s)')
ylabel('%')
title('Efficiency');
grid on

figure
plot(Tcki,150*Ton^2./Tcki);
grid on