function Aw = Mencode4(Af,M,k,alpha,Fs)
N=length(Af);
[fr,amp]=Optim(Af,Fs);
fr
Aw=Af;
for i=1:16
index=fr(k(i));
if(M(i)==1)
[x,y]=pol2cart(angle(Aw(index)),amp(k(i)));
Aw(index)=x+1i*y;
end
if(M(i)==0)
[x,y]=pol2cart(angle(Aw(index)),amp(k(i))/alpha); 
Aw(index)=x+1i*y;
end
Aw(N+2-index)=conj(Aw(index));
end






