function [C,D,Sc] = LBG (S,K)

n = length(S);
m = length(S(:,1));
D0 = 0;

C = zeros(m,K);
for i=1:K
  C(:,i)=S(:,i);
end
Sc = zeros(n,m,K);

% Clustering
Nc=zeros(1,K);
for i=1:n
    delta = zeros(1,K);
    for j=1:K;
       delta(j) = sqrt(sum((S(:,i) - C(:,j) ) .^ 2));
    end
    [~,q] = min(delta);
	Nc(q) = Nc(q) + 1 ;
	index = Nc(q);
	Sc(index,:,q) = S(:,i);
	
end  

% Update Cj
for i=1:K
  summ = 0;
  for j=1:Nc(i)
    summ = summ + Sc(j,:,i) ;
  end
  if(~Nc(i)==0)
  C(:,i) = 1/Nc(i) * summ ;
  end
end

% Calculate Distortion
sumI = 0 ;
for i=1:K
  sumJ = 0 ;
  for j=1:Nc(i)
    sumJ = sumJ + sqrt(sum((Sc(j,:,i)' - C(:,i) ) .^ 2));
  end
sumI = sumI + sumJ ;
end
D1 = sumI;
D = [D0 D1];


while (abs((D0-D1)/D1)>0.001)
D0 = D1 ;
Sc = zeros(n,m,K);
% Clustering
Nc=zeros(1,K);
for i=1:n
    delta = zeros(1,K);
    for j=1:K;
       delta(j) = sqrt(sum((S(:,i) - C(:,j) ) .^ 2));
    end
    [~,q] = min(delta);
	Nc(q) = Nc(q) + 1 ;
	index = Nc(q);
	Sc(index,:,q) = S(:,i);
	
end  

% Update Cj
for i=1:K
  summ = 0;
  for j=1:Nc(i)
    summ = summ + Sc(j,:,i) ;
  end
  if(~Nc(i)==0)
  C(:,i) = 1/Nc(i) * summ ;
  end
end

% Calculate Distortion
sumI = 0 ;
for i=1:K
  sumJ = 0 ;
  for j=1:Nc(i)
    sumJ = sumJ + sqrt(sum((Sc(j,:,i)' - C(:,i) ) .^ 2));
  end
sumI = sumI + sumJ ;
end
D1 = sumI;
D = [D D1];

end





















