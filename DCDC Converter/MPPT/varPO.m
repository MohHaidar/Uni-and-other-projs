x=zeros(1,251);
power=zeros(1,250);
optmin=zeros(1,250);
optmax=zeros(1,250); % vectors to draw two lines indicating the boundaries for maximun power point 

factor=3;% factor to increment X with
start=30;

x(1)=start;
power(1)=Power(x(1),1);
x(2)=x(1)+1;


for i=2:50
power(i)=Power(x(i),1);
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltap==0 %case if power isnt changing (min or max) , stop moving x
x(i+1)=x(i);
else
    if deltax==0 % case if power changes for same x (wind speed change), increase by small step to get new gradient
        x(i+1)=x(i)+1;
    else
        if abs(deltap/deltax)>20 %case if power changes greatly with x (mvmt speed change dramatically) make the step small just to get the gradient 
            x(i+1)=x(i)+1;
        else %normal case
x(i+1)=x(i)+factor*deltap/deltax;
        end
    end
end
if x(i+1)>107.66 %Upper limit to calculate P (data)
    x(i+1)=107.66;
else
    if x(i+1)<12.35 %Lower limit to calculate P (data)
        x(i+1)=12.35;
    end
end
end
b=find(P1(2,:)==max(P1(2,:)));
optmin(1:50)=P1(1,b(1));
optmax(1:50)=P1(1,b(length(b)));

for i=51:100
power(i)=Power(x(i),2);
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltap==0 %case if power isnt changing (min or max) , stop moving x
x(i+1)=x(i);
else
    if deltax==0 % case if power changes for same x (wind speed change), increase by small step to get new gradient
        x(i+1)=x(i)+1;
    else
        if abs(deltap/deltax)>20 %case if power changes greatly with x (mvmt speed change dramatically) make the step small just to get the gradient
            x(i+1)=x(i)+1;
        else %normal case
x(i+1)=x(i)+factor*deltap/deltax;
        end
    end
end
if x(i+1)>71.9 %Upper limit to calculate P (data)
    x(i+1)=71.9; 
else
    if x(i+1)<12.35 %Lower limit to calculate P (data)
        x(i+1)=12.35;
    end
end
end
b=find(P2(2,:)==max(P2(2,:)));
optmin(51:100)=P2(1,b(1));
optmax(51:100)=P2(1,b(length(b)));

for i=101:150
power(i)=Power(x(i),3);
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltap==0 %case if power isnt changing (min or max) , stop moving x
x(i+1)=x(i);
else
    if deltax==0 % case if power changes for same x (wind speed change), increase by small step to get new gradient
        x(i+1)=x(i)+1;
    else
        if abs(deltap/deltax)>20 %case if power changes greatly with x (mvmt speed change dramatically) make the step small just to get the gradient 
            x(i+1)=x(i)+1;
        else %normal case
x(i+1)=x(i)+factor*deltap/deltax;
        end
    end
end
if x(i+1)>90.11 %Upper limit to calculate P (data)
    x(i+1)=90.11;
else
    if x(i+1)<12.35 %Lower limit to calculate P (data)
        x(i+1)=12.35;
    end
end
end
b=find(P3(2,:)==max(P3(2,:)));
optmin(101:150)=P3(1,b(1));
optmax(101:150)=P3(1,b(length(b)));

for i=151:200
power(i)=Power(x(i),4);
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltap==0 %case if power isnt changing (min or max) , stop moving x
x(i+1)=x(i);
else
    if deltax==0 % case if power changes for same x (wind speed change), increase by small step to get new gradient
        x(i+1)=x(i)+1;
    else
        if abs(deltap/deltax)>20 %case if power changes greatly with x (mvmt speed change dramatically) make the step small just to get the gradient 
            x(i+1)=x(i)+1;
        else %normal case
x(i+1)=x(i)+factor*deltap/deltax;
        end
    end
end
if x(i+1)>90.11 %Upper limit to calculate P (data)
    x(i+1)=90.11;
else
    if x(i+1)<12.35 %Lower limit to calculate P (data)
        x(i+1)=12.35;
    end
end
end
b=find(P4(2,:)==max(P4(2,:)));
optmin(151:200)=P4(1,b(1));
optmax(151:200)=P4(1,b(length(b)));


for i=201:250
power(i)=Power(x(i),5);
deltap = power(i)-power(i-1);
deltax = x(i)-x(i-1);
if deltap==0 %case if power isnt changing (min or max) , stop moving x
x(i+1)=x(i);
else
    if deltax==0 % case if power changes for same x (wind speed change), increase by small step to get new gradient
        x(i+1)=x(i)+1;
    else
        if abs(deltap/deltax)>20 %case if power changes greatly with x (mvmt speed change dramatically) make the step small just to get the gradient 
            x(i+1)=x(i)+1;
        else %normal case
x(i+1)=x(i)+factor*deltap/deltax;
        end
    end
end
if x(i+1)>90.11 %Upper limit to calculate P (data)
    x(i+1)=90.11;
else
    if x(i+1)<12.35 %Lower limit to calculate P (data)
        x(i+1)=12.35;
    end
end
end
b=find(P5(2,:)==max(P5(2,:)));
optmin(201:250)=P5(1,b(1));
optmax(201:250)=P5(1,b(length(b)));

plot(x)
grid on
hold
%b=find(P1(2,:)==max(P1(2,:)));
%plot(71.9*ones(1,length(x)))
%plot(12.35*ones(1,length(x)))
plot(optmin)
plot(optmax)

figure

plot(P1(1,:),P1(2,:))
hold
plot(P2(1,:),P2(2,:))
plot(P3(1,:),P3(2,:))
plot(P4(1,:),P4(2,:))
plot(P5(1,:),P5(2,:))
plot(x(1:length(power)),power,'r-o')
grid on