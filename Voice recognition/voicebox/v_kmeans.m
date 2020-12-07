function [x,g,j,gg] = v_kmeans(d,k,x0,l)
0002 %V_KMEANS Vector quantisation using K-means algorithm [X,ESQ,J]=(D,K,X0,L)
0003 %
0004 %  Inputs:
0005 %
0006 %    D(N,P)  contains N data vectors of dimension P
0007 %    K       is number of centres required
0008 %    X0(K,P) are the initial centres (optional)
0009 %
0010 %      or alternatively
0011 %
0012 %    X0      gives the initialization method
0013 %            'f'   pick K random elements of D as the initial centres [default]
0014 %            'p'   randomly divide D into K sets and choose the centroids
0015 %    L       gives max number of iterations (use 0 if you just want to calculate G and J)
0016 %
0017 %  Outputs:
0018 %
0019 %    X(K,P)  is output row vectors (omitted if L=0)
0020 %    G       is mean square error
0021 %    J(N)    indicates which centre each data vector belongs to
0022 %    GG(L)   gives the mean square error at the start of each iteration (omitted if L=0)
0023 %
0024 % It is often a good idea to scale the input data so that it has equal variance in each
0025 % dimension before calling V_KMEANS.
0026 
0027 %  Originally based on a routine by Chuck Anderson, anderson@cs.colostate.edu, 1996
0028 
0029 
0030 %      Copyright (C) Mike Brookes 1998
0031 %      Version: $Id: v_kmeans.m 4497 2014-04-23 10:28:55Z dmb $
0032 %
0033 %   VOICEBOX is a MATLAB toolbox for speech processing.
0034 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0035 %
0036 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0037 %   This program is free software; you can redistribute it and/or modify
0038 %   it under the terms of the GNU General Public License as published by
0039 %   the Free Software Foundation; either version 2 of the License, or
0040 %   (at your option) any later version.
0041 %
0042 %   This program is distributed in the hope that it will be useful,
0043 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0044 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0045 %   GNU General Public License for more details.
0046 %
0047 %   You can obtain a copy of the GNU General Public License from
0048 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0049 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0050 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 memsize=voicebox('memsize'); 
 [n,p] = size(d);
 nb=min(n,max(1,floor(memsize/(8*p*k))));    % block size for testing data points
 nl=ceil(n/nb);                  % number of blocks
 if nargin<4
     l=300;                  % very large max iteration count
     if nargin<3
         x0='f';             % use 'f' initialization mode
     end
 end
 if ischar(x0)
     if k<n
         if any(x0)=='p'                  % Initialize using a random partition
             ix=ceil(rand(1,n)*k);       % allocate to random clusters
             ix(rnsubset(k,n))=1:k;      % but force at least one point per cluster
             x=zeros(k,p);
             for i=1:k
                 x(i,:)=mean(d(ix==i,:),1);
             end
         else                                % Forgy initialization: choose k random points [default]
             x=d(rnsubset(k,n),:);         % sample k centres without replacement
         end
     else
         x=d(mod((1:k)-1,n)+1,:);    % just include all points several times
     end
 else
     x=x0;
 end
 m=zeros(n,1);           % minimum distance to a centre
 j=zeros(n,1);           % index of closest centre
 gg=zeros(l,1);
 wp=ones(1,p);
 kk=1:p;
 kk=kk(ones(n,1),:);
 kk=kk(:);
 
 if l>0
     for ll=1:l                 % loop until x==y causes a break
         
         % find closest centre to each data point [m(:),j(:)] = distance, index
         
         ix=1;
         jx=n-nl*nb;
         for il=1:nl
             jx=jx+nb;        % increment upper limit
             ii=ix:jx;
             z = disteusq(d(ii,:),x,'x');
             [m(ii),j(ii)] = min(z,[],2);
             ix=jx+1;
         end
         y = x;              % save old centre list
         
         % calculate new centres as the mean of their assigned data values (or zero for unused centres)
         
         nd=full(sparse(j,1,1,k,1));         % number of points allocated to each centre
         md=max(nd,1);                       % remove zeros
         jj=j(:,wp);
         x=full(sparse(jj(:),kk,d(:),k,p))./md(:,wp);    % calculate the new means
         fx=find(nd==0);
         
         % if any centres are unused, assign them to data values that are not exactly on centres
         % choose randomly if there are more such points than needed
         
         if ~isempty(fx)
             q=find(m~=0);
             if length(q)<=length(fx)
                 x(fx(1:length(q)),:)=d(q,:);
             else
                 if length(fx)>1
                     [rr,ri]=sort(rand(length(q),1));
                     x(fx,:)=d(q(ri(1:length(fx))),:);
                 else
                     x(fx,:) = d(q(ceil(rand(1)*length(q))),:);
                 end
             end
         end
         
         % quit if the centres are unchanged
         
         gg(ll)=sum(m,1);
         if x==y
             break
         end
     end
     gg=gg(1:ll)/n;
 %     ll % *** DEBUG ***
 %     gg' % *** DEBUG ***
     g=gg(end);
 else            % if l==0 then just calculate G and J (but rename as X and G)
     ix=1;
     jx=n-nl*nb;
     for il=1:nl
         jx=jx+nb;        % increment upper limit
         ii=ix:jx;
         z = disteusq(d(ii,:),x,'x');
         [m(ii),j(ii)] = min(z,[],2);
         ix=jx+1;
     end
     x=sum(m,1)/n;
     g=j;
 end