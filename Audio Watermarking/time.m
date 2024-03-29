% Hiding Algoritm

global snd1;
global snd2;
global nummod;

[y, fs, nbits]=wavread(snd1);
[y2, fs2, nbits2]=wavread(snd2);

yleft=y(:,1);
y2left=y2(:,1);

% Convert public to filtered bin.

yshift=yleft+1;

yint=yshift.*(2^15);

yfiltered=yint-mod(yint,2^nummod);

% Convert secret to bin.

y2shift=y2left+1;

y2int=y2shift.*(2^15);

y2bin=dec2bin(y2int,nbits2);

% Processing

k = 1;
jmax = nbits2/nummod;

y2div = zeros(size(yfiltered,1),1);

mult = zeros(jmax+1,1);
   
for i=1:size(y2bin,1)
   for j=(1:jmax)
      y2div(k)=bin2dec(y2bin(i,(((j-1)*nummod+1):(j*nummod))));

      k=k+1;
   end
end

out = yfiltered + y2div;

% Convert back to Matlab vectors.

yhidden = (out./2^15)-1;

% Recovery Algorithm

% Convert to Binary

yinthidden = (yhidden+1).*(2^15);

temp = mod(yinthidden,2^nummod);

jmax = nbits2/nummod;

% Processing

k = 1;

y2rec=zeros(((size(yinthidden,1))/jmax),1);

for i=1:(size(yinthidden,1)/jmax)
      tempdecode=[];
   for j=1:jmax
      tempdecodeamt=[dec2bin(temp(k),nummod)];
      tempdecode=[tempdecode tempdecodeamt];
      k=k+1;
   end
   y2rec(i)=bin2dec(tempdecode);
end

% Convert back to Matlab Vectors

   alldone=(y2rec./(2^15))-1;    
   
 