global yl2;
global tl2;
global threshold;
Ts = tl2(2);

fmin = 15;
fmax = 20;

Tmin = 1/fmax;
Tmax = 1/fmin;
w = Tmax-Tmin;

threshold = 0.3;
avrg = 0;
time = 0;
period=0;
freq=0;

idx = round(Tmax/Ts);
peak = max(yl2(1:idx));

n = idx + 10;

while(yl2(n)< (peak-threshold))
     n = n+1;
end

while(length(yl2(n:length(yl2)))>= round(Tmax/Ts))
    
    count = 0;
    sum=0;
    for i = n+60:n+round(Tmin/Ts)
         sum = sum + yl2(i)*yl2(i);
         count = count+1;
    end
    n=i;
    for i = n:n+round(w/Ts)
         sum = sum + yl2(i)*yl2(i);
         count = count+1;
         if yl2(i)>(peak-threshold)
             peak=yl2(i);
             break;
         end
    end
    n = i;
    for i=n:n+60
        sum = sum + yl2(i)*yl2(i);
         count = count+1;
    end
    time = [time n];
    avrg = [avrg sum/count/430];
    period = [period count*Ts];
    freq = [freq 1./count/Ts];
end

time=time-1;
time=time(2:length(time));
time = time*Ts;

avrg = avrg(2:length(avrg));
period = period(2:length(period));
freq = freq(2:length(freq));

subplot(2,1,1)
stem(time,avrg)
hold
plot(time,mean(avrg)*ones(1,length(time)))
%plot(tl2(1:idx),mean(avrg)*ones(1,idx))
subplot(2,1,2)
plot(tl2,yl2)

figure
subplot(2,1,1)
plot(time,period)
subplot(2,1,2)
plot(time,freq)