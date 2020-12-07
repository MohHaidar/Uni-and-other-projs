function M = Mdecode5(Afw,k,Fs)

N=length(Afw);
f=Fs/N*(0:N-1);
M=zeros(1,16);
[~,p]=findpeaks(abs(Afw),'MinPeakHeight',20,'MinPeakDistance',50);
amp=zeros(1,30);
start=find(round(f)==250);
start=start(1);
p=p(find(p>=start));
End=floor(N/2);
p=p(find(p<End));
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
amp(l)=v;
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
amp(l)=v;
fr(l)=j;
l=l+1;
end
for i=1:16
index=fr(k(i));
M(i)=-abs(Afw(index))+(amp(k(i)))/16;
end
M=M./abs(M);
M=M>0;

