%function x=PandO(X0,P)


x=zeros(1,100);% Variable to control (Resistance, voltage..) 
power=zeros(1,100);% variable to track the power associated with each x

x(1)=50;% initial value of x
power(1)=Power(x(1),1);%P1 is the power/x characteristic
x(2)=x(1)+1;% first perturbation is constant bcz we on know the gradient of P 
for i=2:100
power(i)=Power(x(i),1);
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltax==0 % this test can be on deltap but because deltax should never be 0, in variable winf speed we do these 2 tests sepaately
x(i+1)=x(i);% this might be due to deltap = 0 => x(i+1)=x(i) or power cap
else
x(i+1)=x(i)+1*deltap/deltax;% increase x by an amount proportional of the gradient of P
end
end
plot(x)
grid on
hold
b=find(P4(2,:)==max(P4(2,:)));
lowmax=b(1);
highmax=b(length(b));
plot(P4(1,lowmax)*ones(1,length(x)))
plot(P4(1,highmax)*ones(1,length(x)))

figure
plot(P4(1,:),P4(2,:))
hold
plot(x(1:length(power)),power,'r-o')