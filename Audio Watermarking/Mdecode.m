function M = Mdecode(Afw,k,alpha,Fs)

N=length(Afw);
f=Fs/N*(0:N-1);
M=zeros(1,16);
[~,p]=findpeaks(abs(Afw),'MinPeakHeight',50,'MinPeakDistance',208);
amp=zeros(1,30);
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
fr(l)=round(f(j));
l=l+1;
j=p(i);
v=abs(Afw(j));
while 1
    if(abs(Afw(j))<=v/2)
        break
    end
    j=j-1;
end
fr(l)=round(f(j));
l=l+1;
end
for i=1:16
index=find(round(f)==(fr(k(i))));
index=index(3);
M(i)=real(Afw(index));
end
M=M./abs(M);
