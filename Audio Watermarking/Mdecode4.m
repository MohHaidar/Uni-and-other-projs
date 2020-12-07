function M = Mdecode4(Afw,k,alpha,Fs)
M=zeros(1,16);
[fr,amp]=OptimD(Afw,Fs);
for i=1:16
index=fr(k(i));
M(i)=abs(Afw(index))-(amp(k(i)))/alpha;
end
M=M./abs(M);
M=M>0;
