%% Initialization
global yl;
global tl;
global power_2;

Ts = tl(2);%sampling 

fmin = 15;
fmax = 23;

Tmin = 1/fmax;
Tmax = 1/fmin;
w = Tmax-Tmin;

threshold = 0.5;
avrg = 0;
time = 0;
period=0;
freq=0;

buff=[0 0 0];%buffer to calculate the average of 3 consecutive power values
m_avg = 0;
j=2;

idx = round(Tmax/Ts);
peak = max(ylt(1:idx));%find the maximum during the first theoretical period (correspnding to the max period)

n = idx +1;% small delay 

%% Loop

%search for the first peak in a threshold
while(yl(n)< (peak-threshold))
     n = n+1;
end

%Go throught the signal until no sufficient data
while(length(yl(n:length(yl)))>= round(Tmax/Ts))
    
    count = 0;
    sum=0;
    
    %Add the voltage square for all smaples until t=Tmin
    for i = n:n+round(Tmin/Ts)
         sum = sum + yl(i)*yl(i);
         count = count+1;
    end
    n=i;
    %continue adding but looking for the peak to break, if not stop at
    %t=Tmax=Tmin+w
    for i = n:n+round(w/Ts)
         sum = sum + yl(i)*yl(i);
         count = count+1;
         if yl(i)>(peak-threshold)
             while(round(100*dylt(i))~=0)
                 Sum = Sum + ylt(i)*ylt(i);
                 count = count+1;
                 i = i+1;
             end
             peak=yl(i);
             break;
         end
    end
    %after finishing we calculate the average and store it
    n = i;
    time = [time n];
    avrg = [avrg sum/count/430];
    period = [period count*Ts];
    freq = [freq 1./count/Ts];
    
    buff(1)=buff(2);%shift the buffer to the left
    buff(2)=buff(3);
    buff(3)=avrg(j);
    m_avg=[m_avg mean(buff)];
    %yl(n:length(yl))=yl(n:length(yl))/max(yl(n:length(yl)))*power_2(j)*276.76;
    j=j+1;
end


%% Plot 

time=time-1;
time=time(2:length(time));
time = time*Ts;

avrg = avrg(2:length(avrg));
period = period(2:length(period));
freq = freq(2:length(freq));
m_avg = m_avg(2:length(m_avg));

stem(time,m_avg)
figure
subplot(2,1,1)
stem(time,avrg)
hold
plot(time,mean(avrg)*ones(1,length(time)))
%plot(tl(1:idx),mean(avrg)*ones(1,idx))
subplot(2,1,2)
plot(tl,yl)

figure
subplot(2,1,1)
plot(time,period)
subplot(2,1,2)
plot(time,freq)