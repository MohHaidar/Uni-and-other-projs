%% Initialization
A=500; %factor between reverse current and induced force/mvt
K=0.1; %wind to mvt factor
r1=300; %internal resistance

U=[1 2 4 6 8 10];% wind speed
R=100:100000;
%MPPT=zeros(2,6);

for i=1:length(U)
    
V=(sqrt(K*sqrt(U(i))+A^2./(4*(R+r1).^2))-A./(2*(R+r1)))./(R+r1).*R;
I=(sqrt(K*sqrt(U(i))+A^2./(4*(R+r1).^2))-A./(2*(R+r1)))./(R+r1);
P=V.*I;
plot(R,P);
hold on
[mx,idx]=max(P);
MPPT(1,i)=R(idx);
MPPT(2,i)=mx;

end

 plot(MPPT(1,:),MPPT(2,:))