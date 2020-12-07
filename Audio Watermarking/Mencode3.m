function [Aw,fr,amp] = Mencode3(Af,M,k,Fs)
N=length(Af);
f=Fs/N*(0:N-1);
[~,p]=findpeaks(abs(Af),'MinPeakHeight',50,'MinPeakDistance',450);
amp=zeros(1,30);
start=find(round(f)==250);
start=start(3);
p=p(find(p>=start));
fr=zeros(1,30);
for i=1:15;
fr(2*i-1)=p(i)-1;
fr(2*i)=p(i)+1;
amp(2*i-1)=abs(Af(p(i)));
amp(2*i)=amp(2*i-1);
end
Aw=Af;
for i=1:16
index=fr(k(i));
if(M(i)==1)
[x,y]=pol2cart(angle(Aw(index)),amp(k(i))/2);
Aw(index)=x+1i*y;
end
if(M(i)==0)
[x,y]=pol2cart(angle(Aw(index)),amp(k(i))/4); 
Aw(index)=x+1i*y;
end
Aw(N+2-index)=conj(Aw(index));
end







