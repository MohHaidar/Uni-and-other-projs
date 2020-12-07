function [fr,amp]=OptimD(Af,Fs)
N=length(Af);
stop=0;
cont=0;
for Dist=450:-50:50
  for H=1000:-50:50
    [fr,amp]=findmaxD(Af,Fs,H,Dist);
    if(length(fr)>1)
      for i=1:29
         if(fr(i)==(N+2-fr(i+1)))
            cont=1;
            break;
         end
      end
      if(cont~=1)
         stop=1;
         break;
      end
      cont=0;
    end
  end
  if(stop==1)
    break;  
  end
end