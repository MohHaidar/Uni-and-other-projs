%% Initialization
global ylt;
global tl;
Ts = tl(2);%sampling 
dylt=diff(ylt);

fmin = 15;
fmax = 23;

Tmin = 1/fmax;
Tmax = 1/fmin;
w = Tmax-Tmin;

threshold = 0.3;
avrg = zeros(1,55);
time = zeros(1,55);
period=zeros(1,55);
freq = zeros(1,55);

buff=[0 0 0 0];%buffer to calculate the average of 3 consecutive power values
m4_avg = zeros(1,55);
m3_avg = zeros(1,55);
j=1;

%% Find the peak value
idx = round(Tmax/Ts);
peak = max(ylt(1:idx));%find the maximum during the first theoretical period (correspnding to the max period)

n = idx +1;% small delay 

%scale=0.75*cos(pi/3*tl).^2+0.25;
%ylt=ylt.*scale;
%% Loop

%search for the first peak in a threshold
while(ylt(n)< (peak-threshold))
     n = n+1;
end

%Go throught the signal until no sufficient data
while(length(ylt(n:length(ylt)))>= round(Tmax/Ts))
    
    count = 0;
    Sum=0;
    
    %Add the voltage square for all smaples until t=Tmin
    for i = n:n+round(Tmin/Ts)
         Sum = Sum + ylt(i)*ylt(i);
         count = count+1;
    end
    n=i;
    %continue adding but looking for the peak to break, if not stop at
    %t=Tmax=Tmin+w
    for i = n:n+round(w/Ts)
         Sum = Sum + ylt(i)*ylt(i);
         count = count+1;
         if ylt(i)>(peak-threshold)
             while(round(100*dylt(i))~=0)
                 Sum = Sum + ylt(i)*ylt(i);
                 count = count+1;
                 i = i+1;
             end
             peak=ylt(i);
             break;
         end
    end
    %after finishing we calculate the average and store it
    n = i;%peak index
    %for i=n+1:n+61
    %    Sum = Sum + ylt(i)*ylt(i);
    %     count = count+1;
    %end
    time(j) = n;
    avrg(j) = Sum/count/430;
    period(j) = count*Ts;
    freq(j) = 1./count/Ts;
    
    buff(1)=buff(2);%shift the buffer to the left
    buff(2)=buff(3);
    buff(3)=buff(4);
    buff(4)=avrg(j);
    
    m4_avg(j) = sum(buff)/sum(buff>0); %calculate the average for the non zero elements of the buffer
    m3_avg(j) = sum(buff(2:4))/sum(buff(2:4)>0); %calculate the average on the non zero element of first 3 buffer cases
    j=j+1;
end


%% Plot 

time=time-1;
time = time*Ts;

plot(time,m4_avg)
hold
%plot(time,m3_avg)
plot(time,avrg)

figure
subplot(2,1,1)
stem(time,avrg)
hold
plot(time,mean(avrg)*ones(1,length(time)))
%plot(tl(1:idx),mean(avrg)*ones(1,idx))
subplot(2,1,2)
plot(tl,ylt)

figure
subplot(2,1,1)
plot(time,period)
subplot(2,1,2)
plot(time,freq)