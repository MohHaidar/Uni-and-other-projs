function [fr,amp]=findmaxD(Af,Fs,H,Dist)
N=length(Af);
f=Fs/N*(0:N-1);
[~,p]=findpeaks(abs(Af),'MinPeakHeight',H,'MinPeakDistance',Dist);
if(length(p)>=16)
amp=zeros(1,30);
start=find(round(f)==250);
start=start(3);
p=p(find(p>=start));
fr=zeros(1,30);
l=1;
for i=1:15;
    
j=p(i);
v=abs(Af(j));
while 1
    if(abs(Af(j))<=v/2)
        break
    end
    j=j+1;
end
amp(l)=abs(Af(p(i)));
fr(l)=j;
l=l+1;
j=p(i);
v=abs(Af(j));
while 1
    if(abs(Af(j))<=v/2)
        break
    end
    j=j-1;
end
amp(l)=abs(Af(p(i)));
fr(l)=j;
l=l+1;
end
else
    fr=0;
    amp=0;
end