function Aw = Mencode(Af,M,k,alpha,Fs)
N=length(Af);
f=Fs/N*(0:N-1);
[~,p]=findpeaks(abs(Af),'MinPeakHeight',50,'MinPeakDistance',208);
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
amp(l)=v/2;
fr(l)=round(f(j));
l=l+1;
j=p(i);
v=abs(Af(j));
while 1
    if(abs(Af(j))<=v/2)
        break
    end
    j=j-1;
end
amp(l)=v/2;
fr(l)=round(f(j));
l=l+1;
end
Aw=Af;
for i=1:16
index=find(round(f)==(fr(k(i))));
index=index(3);
Aw(index)=amp(k(i))*M(i);
Aw(N+2-index)=amp(k(i))*M(i);
end


