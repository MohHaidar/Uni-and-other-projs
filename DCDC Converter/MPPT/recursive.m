function [X,counter]=recursive(Xmin,Xmax,thr,N,i,counter)
global x;
global power;
global ep;

ep(counter)=Xmax-Xmin;
prev = [0 0];
new = [Xmin Xmin+ep(counter)/N];


if (Xmax-Xmin)<thr || counter==100 %return condition
X=(Xmax+Xmin)/2;
return
end

x(i)=new(1);
power(i)=Power(x(i),1);
i=i+1;
x(i)=new(2);
power(i)=Power(x(i),1);
deltap = Power(new(2),1)-Power(new(1),1);

while deltap>0
prev=new;
new=new+ep(counter)/N;
i=i+1;
x(i)=new(2);
power(i)=Power(x(i),1);
deltap = Power(new(2),1)-Power(new(1),1);
end

if prev == 0
Xmin=new(1);
Xmax=new(2);
else
Xmin=prev(1);
Xmax=new(2);
end

counter=counter+1;
[X,counter]=recursive(Xmin,Xmax,thr,N,i+1,counter);

end