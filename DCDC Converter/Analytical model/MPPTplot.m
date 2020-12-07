%% Initialization
A=500; %factor between reverse current and induced force/mvt
K=1; %wind to mvt factor
r1=300; %internal resistance

R=300:3000;
MPPT=zeros(2,10000);

for U=1:10000
    
V=(sqrt(K*U/10+A^2./(4*(R+r1).^2))-A./(2*(R+r1)))./(R+r1).*R;
I=(sqrt(K*U/10+A^2./(4*(R+r1).^2))-A./(2*(R+r1)))./(R+r1);
P=V.*I;
[mx,idx]=max(P);
MPPT(1,U)=R(idx);
MPPT(2,U)=U/10;

end

plot(MPPT(2,:),MPPT(1,:))
%p = polyfit(MPPT(2,:),MPPT(1,:),1)
%f = polyval(p,MPPT(2,:));
%hold
%plot(MPPT(2,:),f)
hold
plot(MPPT(2,:),sqrt(r1^2+(A^2./(4*K*MPPT(2,:))))+A./(2*sqrt(K*MPPT(2,:))))