function M = Mdecode3(Afw,k,Fs)

N=length(Afw);
f=Fs/N*(0:N-1);
M=zeros(1,16);
[~,p]=findpeaks(abs(Afw),'MinPeakHeight',50,'MinPeakDistance',450);
amp=zeros(1,30);
start=find(round(f)==250);
start=start(3);
p=p(find(p>=start));
fr=zeros(1,30);
for i=1:15;
fr(2*i-1)=p(i)-1;
fr(2*i)=p(i)+1;
amp(2*i-1)=abs(Afw(p(i)));
amp(2*i)=amp(2*i-1);
end
for i=1:16
index=fr(k(i));
index
abs(Afw(index))
(amp(k(i))/3)
M(i)=abs(Afw(index))-(amp(k(i))/3);
end
M=M./abs(M);
M=M>0;
