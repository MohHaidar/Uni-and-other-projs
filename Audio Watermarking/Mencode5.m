function Aw = Mencode5(Af,M,k,Fs)
N=length(Af);
f=Fs/N*(0:N-1);
[~,p]=findpeaks(abs(Af),'MinPeakHeight',20,'MinPeakDistance',50);
amp=zeros(1,30);
start=find(round(f)==250);
start=start(1);
p=p(find(p>=start));
End=floor(N/2);
p=p(find(p<End));
fr=zeros(1,30);
l=1;
if~(length(p)<15)
for i=1:15;
    
j=p(i);
v=abs(Af(j));
while 1
    if(abs(Af(j))<=v/2)
        break
    end
    j=j+1;
end
amp(l)=abs(Af(j));
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
amp(l)=abs(Af(j));
fr(l)=j;
l=l+1;
end
Aw=Af;
for i=1:16
index=fr(k(i));

if(M(i)==0)
[x,y]=pol2cart(angle(Aw(index)),amp(k(i)));
Aw(index)=x+1i*y;
end
if(M(i)==1)
[x,y]=pol2cart(angle(Aw(index)),amp(k(i))/16); 
Aw(index)=x+1i*y;
end
Aw(N+2-index)=conj(Aw(index));
end
else
     errordlg('The audio is too short');
end




