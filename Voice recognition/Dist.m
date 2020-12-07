function D = Dist ( Cb1 , Cb2 ) ;

K = length ( Cb1(1,:) ) ;

delta1 = zeros (1,K);
delta2 = zeros (1,K);
dis = zeros (1,K);
temp = Cb2;
for i=1:K    
    for j=1:K
	  if(~isnan(temp(1,j)))
        dis(j) = sqrt(sum((Cb1(:,i) - temp(:,j) ) .^ 2));
	  else
	   dis(j) = NaN;
	  end
    end
	[ m, minIndex ] = min(dis) ;
	delta1(i)= m ;
	temp(:,minIndex(1)) = NaN;
end

dist1 = sum(delta1);
mean(delta1)


temp = Cb1;

for i=1:K    
    for j=1:K
	  if(~isnan(temp(1,j)))
        dis(j) = sqrt(sum((temp(:,j) - Cb2(:,i) ) .^ 2));
	  else
	   dis(j) = NaN;
	  end
    end
	[ m , minIndex ] = min(dis) ;
	delta2(i) = m ;
	temp(:,minIndex(1)) = NaN;
end

dist2 = sum(delta2);
mean(delta2)
D = min (dist1,dist2);






 %find duplicates
 %[~,i,dup] = unique (delta);
 %dup(i) = [];
 %create distance table again for duplicate indexes 
 %for i=1:length(dup)
 %  Dindex = find(delta==dup(i));
 %  delta2 = zeros(length(Dindex),K);
 %  for j=1:length(Dindex)
 %    for k=1:K
 %	    delta2(j,k) = sqrt(sum((Cb1(:,Dindex(j)) - Cb2(:,k) ) .^ 2));
 %		delta2 = sort(delta2(j,:));
 %	 end
 %  end
%try possible permutations 
 % perm = perms(Dindex) ;
 %  summs = zeros(1,length(perm));
 %  for j=1:length(perm)
 %    summ = 0 ;
 %    for k=1:length(Dindex)
 %	     summ = summ + delta2(perm(k),k);
 %   end
 %    summs(j) = summ;
 %  end
 %  minIndex = find(summs==min(summs));
   
%updating delta
   
   
