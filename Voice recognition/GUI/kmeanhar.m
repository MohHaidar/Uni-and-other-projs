function [x,g,xn,gg] = kmeanhar(d,k,l,e,x0)
0002 %KMEANS Vector quantisation using K-harmonic means algorithm [X,G,XN,GG]=(D,K,L,E,X0)
0003 %
0004 %  Inputs:
0005 %
0006 %    D(N,P)  contains N data vectors of dimension P
0007 %    K       is number of centres required
0008 %    L       integer portion is max loop count, fractional portion
0009 %            gives stopping threshold as fractional reduction in performance criterion
0010 %    E       is exponent in the cost function. Significantly faster if this is an even integer. [default 4]
0011 %    X0(K,P) are the initial centres (optional)
0012 %            Alternatively, X0 can be a character determining the initialization method:
0013 %                'f'    Initialize with K randomly selected data points [default]
0014 %                'p'    Initialize with centroids and variances of random partitions
0015 %
0016 %  Outputs:
0017 %
0018 %    X(K,P)  is output row vectors
0019 %    G       is the final performance criterion value (normalized by N)
0020 %    XN      nearest centre for each input point
0021 %    GG(L+1) value of performance criterion before each iteration and at end
0022 %
0023 % The k-harmonic means algorithm selects K cluster centres to minimize
0024 %                           sum_n(K/sum_k((d_n-x_k)^-e))
0025 % where sum_n is over the N inputs points d_n and sum_k is over the K cluster centres x_k.
0026 %
0027 % It is often a good idea to scale the input data so that it has equal variance in each
0028 % dimension before calling KMEANHAR so that approximately equal weight is given
0029 % to each dimension in the distance calculation.
0030 
0031 %  [1] Bin Zhang, "Generalized K-Harmonic Means - Boosting in Unsupervised Learning",
0032 %      Hewlett-Packartd Labs, Technical Report HPL-2000-137, 2000 [Zhang2000]
0033 %      http://www.hpl.hp.com/techreports/2000/HPL-2000-137.pdf
0034 
0035 %  Bugs:
0036 %      (1) Could use nested blocking to allow very large data arrays
0037 %      (2) Could then allow incremental calling with partial data arrays (but messy)
0038 
0039 %      Copyright (C) Mike Brookes 1998
0040 %      Version: $Id: kmeanhar.m 713 2011-10-16 14:45:43Z dmb $
0041 %
0042 %   VOICEBOX is a MATLAB toolbox for speech processing.
0043 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0044 %
0045 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0046 %   This program is free software; you can redistribute it and/or modify
0047 %   it under the terms of the GNU General Public License as published by
0048 %   the Free Software Foundation; either version 2 of the License, or
0049 %   (at your option) any later version.
0050 %
0051 %   This program is distributed in the hope that it will be useful,
0052 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0053 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0054 %   GNU General Public License for more details.
0055 %
0056 %   You can obtain a copy of the GNU General Public License from
0057 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0058 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0059 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0060 
0061 % sort out the input arguments
0062 
 if nargin<5
     x0='f';
     if nargin<4
         e=[];
         if nargin<3
             l=[];
         end
     end
 end
 if isempty(e)
     e=4;  % default value
 end
 if isempty(l)
     l=50+1e-3; % default value
 end
 sd=5;       % number of times we must be below threshold
0079 
0080 
0081 % split into chunks if there are lots of data points
0082 
 memsize=voicebox('memsize');
 [n,p] = size(d);
 nb=min(n,max(1,floor(memsize/(8*p*k))));    % block size for testing data points
 nl=ceil(n/nb);                  % number of blocks
0087 
0088 % initialize if X0 argument is not supplied
0089 
 if ischar(x0)
     if k<n
         if any(x0=='p')                  % Initialize using a random partition
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
 eh=e/2;
 th=l-floor(l);
 l=floor(l)+(nargout>1);   % extra loop needed to calculate final performance value
 if l<=0
     l=100;      % max number of iterations ever
 end
 if th==0
     th=-1;      % prevent any stopping if l has no fractional part
 end
 gg=zeros(l+1,1);
 im=repmat(1:k,1,nb); im=im(:);
 
0120 % index arrays for replication
0121 
 wk=ones(k,1);
 wp=ones(1,p);
0124 % wn=ones(1,n);
0125 %
0126 % % Main calculation loop
0127 %
0128 % We have the following relationships to [1] where i and k index
0129 % the data values and cluster centres respectively:
0130 %
0131 %   This program     [Zhang2000]                            Equation
0132 %
0133 %     d(i,:)            x_i                                 input data
0134 %     x(k,:)            m_k                                 cluster centres
0135 %     py(k,i)           (d_ik)^2
0136 %     dm(i)'            d_i,min^2
0137 %     pr(k,i)           (d_i,min/d_ik)^2
0138 %     pe(k,i)           (d_i,min/d_ik)^p                    (7.6)
0139 %     qik(k,i)          q_ik                                (7.2)
0140 %     qk(k)             q_k                                 (7.3)
0141 %     qik(k,i)./qk(k)   p_ik                                (7.4)
0142 %     se(i)'            d_i,min^p * sumk(d_ik^-p)
0143 %     xf(i)'            d_i,min^-2 / sumk(d_ik^-p)
0144 %     xg(i)'            d_i,min^-(p+2) / sumk(d_ik^-p)^2
0145 
0146 
 ss=sd+1;        % one extra loop at the start
 g=0;                % dummy initial value of g
 xn=zeros(n,1);
 for j=1:l
 
     g1=g;                           % save old performance
     x1=x;                           % save old centres
     % first do partial chunk
0155 
     jx=n-(nl-1)*nb;
     ii=1:jx;
     kx=repmat(ii,k,1);
     km=repmat(1:k,1,jx);
     py=reshape(sum((d(kx(:),:)-x(km(:),:)).^2,2),k,jx);
     [dm,xn(ii)]=min(py,[],1);                 % min value in each column gives nearest centre
     dmk=dm(wk,:);                   % expand into a matrix
     dq=py>dmk;                      % update only these values
     pr=ones(k,jx);                   % leaving others at 1
     pr(dq)=dmk(dq)./py(dq);            % ratio of min(py)./py
     pe=pr.^eh;
     se=sum(pe,1);
     xf=dm.^(eh-1)./se;
     g=xf*dm.';                     % performance criterion (divided by k)
     xg=xf./se;
     qik=xg(wk,:).*pe.*pr;           % qik(k,i) is equal to q_ik in [Zhang2000]
     qk=sum(qik,2);
     xs=qik*d(ii,:);
     ix=jx+1;
     for il=2:nl
         jx=jx+nb;        % increment upper limit
         ii=ix:jx;
         kx=ii(wk,:);
         py=reshape(sum((d(kx(:),:)-x(im,:)).^2,2),k,nb);
         [dm,xn(ii)]=min(py,[],1);                 % min value in each column gives nearest centre
         dmk=dm(wk,:);                   % expand into a matrix
         dq=py>dmk;                      % update only these values
         pr=ones(k,nb);                   % leaving others at 1
         pr(dq)=dmk(dq)./py(dq);            % ratio of min(py)./py
         pe=pr.^eh;
         se=sum(pe,1);
         xf=dm.^(eh-1)./se;
         g=g+xf*dm.';                     % performance criterion (divided by k)
         xg=xf./se;
         qik=xg(wk,:).*pe.*pr;           % qik(k,i) is equal to q_ik in [Zhang2000]
         qk=qk+sum(qik,2);
         xs=xs+qik*d(ii,:);
         ix=jx+1;
     end
     gg(j)=g;
     x=xs./qk(:,wp);
     if g1-g<=th*g1
         ss=ss-1;
         if ~ss break; end  %  stop if improvement < threshold for sd consecutive iterations
     else
         ss=sd;
     end
 end
 gg=gg(1:j)*k/n;                       % scale and trim the performance criterion vector
 g=g(end);
 % gg' % *** DEBUIG ***
 if nargout>1
     x=x1;                               % go back to the previous x values if G and/or XN value is output
 end
