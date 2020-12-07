function Aw = Mencode2(Af,M,k,Fs)
N=length(Af);
f=Fs/N*(0:N-1);
[~,p]=findpeaks(abs(Af),'MinPeakHeight',50,'MinPeakDistance',450);
ang=zeros(1,30);
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
ang(l)=angle(Af(p(i)));
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
ang(l)=angle(Af(p(i)));
fr(l)=j;
l=l+1;
end
Aw=Af;
for i=1:16
index=fr(k(i));

if(M(i)==1)
[x,y]=pol2cart(ang(k(i))+pi/2,abs(Aw(index)));
Aw(index)=x+1i*y;
end
if(M(i)==0)
[x,y]=pol2cart(ang(k(i))-pi/2,abs(Aw(index))); 
Aw(index)=x+1i*y;
end
Aw(N+2-index)=conj(Aw(index));
end






