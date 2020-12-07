x=zeros(1,100);
power=zeros(1,100);
step=5;

x(1)=20;
power(1)=P1(2,find(P1(1,:)==x(1)));
x(2)=x(1)+step;
for i=2:100
index = find(round(P1(1,:)*100)/100==round(x(i)*100)/100);
power(i)=P1(2,index(1));
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltap==0
x(i+1)=x(i);
else
if deltap<0
step=-step;
end
x(i+1)=x(i)+step;
end
end
plot(x)
grid on
hold
b=find(P1(2,:)==max(P1(2,:)));
lowmax=b(1);
highmax=b(length(b));
plot(P1(1,lowmax)*ones(1,length(x)))
plot(P1(1,highmax)*ones(1,length(x)))

figure
plot(P1(1,:),P1(2,:))
hold
plot(x(1:length(power)),power,'r-o')