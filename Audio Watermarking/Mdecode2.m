function M = Mdecode2(Afw,k,Fs)

N=length(Afw);
f=Fs/N*(0:N-1);
M=zeros(1,16);
[~,p]=findpeaks(abs(Afw),'MinPeakHeight',50,'MinPeakDistance',450);
ang=zeros(1,30);
start=find(round(f)==250);
start=start(3);
p=p(find(p>=start));
fr=zeros(1,30);
l=1;
for i=1:15;
j=p(i);
v=abs(Afw(j));
while 1
    if(abs(Afw(j))<=v/2)
        break
    end
    j=j+1;
end
ang(l)=angle(Afw(p(i)));
fr(l)=j;
l=l+1;
j=p(i);
v=abs(Afw(j));
while 1
    if(abs(Afw(j))<=v/2)
        break
    end
    j=j-1;
end
ang(l)=angle(Afw(p(i)));
fr(l)=j;
l=l+1;
end
for i=1:16
index=fr(k(i));
M(i)=wrapToPi(angle(Afw(index))-(ang(k(i))));
end
M=M./abs(M);
M=M>0;
