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
0063 if nargin<5
0064     x0='f';
0065     if nargin<4
0066         e=[];
0067         if nargin<3
0068             l=[];
0069         end
0070     end
0071 end
0072 if isempty(e)
0073     e=4;  % default value
0074 end
0075 if isempty(l)
0076     l=50+1e-3; % default value
0077 end
0078 sd=5;       % number of times we must be below threshold
0079 
0080 
0081 % split into chunks if there are lots of data points
0082 
0083 memsize=voicebox('memsize');
0084 [n,p] = size(d);
0085 nb=min(n,max(1,floor(memsize/(8*p*k))));    % block size for testing data points
0086 nl=ceil(n/nb);                  % number of blocks
0087 
0088 % initialize if X0 argument is not supplied
0089 
0090 if ischar(x0)
0091     if k<n
0092         if any(x0=='p')                  % Initialize using a random partition
0093             ix=ceil(rand(1,n)*k);       % allocate to random clusters
0094             ix(rnsubset(k,n))=1:k;      % but force at least one point per cluster
0095             x=zeros(k,p);
0096             for i=1:k
0097                 x(i,:)=mean(d(ix==i,:),1);
0098             end
0099         else                                % Forgy initialization: choose k random points [default]
0100             x=d(rnsubset(k,n),:);         % sample k centres without replacement
0101         end
0102     else
0103         x=d(mod((1:k)-1,n)+1,:);    % just include all points several times
0104     end
0105 else
0106     x=x0;
0107 end
0108 eh=e/2;
0109 th=l-floor(l);
0110 l=floor(l)+(nargout>1);   % extra loop needed to calculate final performance value
0111 if l<=0
0112     l=100;      % max number of iterations ever
0113 end
0114 if th==0
0115     th=-1;      % prevent any stopping if l has no fractional part
0116 end
0117 gg=zeros(l+1,1);
0118 im=repmat(1:k,1,nb); im=im(:);
0119 
0120 % index arrays for replication
0121 
0122 wk=ones(k,1);
0123 wp=ones(1,p);
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
0147 ss=sd+1;        % one extra loop at the start
0148 g=0;                % dummy initial value of g
0149 xn=zeros(n,1);
0150 for j=1:l
0151 
0152     g1=g;                           % save old performance
0153     x1=x;                           % save old centres
0154     % first do partial chunk
0155 
0156     jx=n-(nl-1)*nb;
0157     ii=1:jx;
0158     kx=repmat(ii,k,1);
0159     km=repmat(1:k,1,jx);
0160     py=reshape(sum((d(kx(:),:)-x(km(:),:)).^2,2),k,jx);
0161     [dm,xn(ii)]=min(py,[],1);                 % min value in each column gives nearest centre
0162     dmk=dm(wk,:);                   % expand into a matrix
0163     dq=py>dmk;                      % update only these values
0164     pr=ones(k,jx);                   % leaving others at 1
0165     pr(dq)=dmk(dq)./py(dq);            % ratio of min(py)./py
0166     pe=pr.^eh;
0167     se=sum(pe,1);
0168     xf=dm.^(eh-1)./se;
0169     g=xf*dm.';                     % performance criterion (divided by k)
0170     xg=xf./se;
0171     qik=xg(wk,:).*pe.*pr;           % qik(k,i) is equal to q_ik in [Zhang2000]
0172     qk=sum(qik,2);
0173     xs=qik*d(ii,:);
0174     ix=jx+1;
0175     for il=2:nl
0176         jx=jx+nb;        % increment upper limit
0177         ii=ix:jx;
0178         kx=ii(wk,:);
0179         py=reshape(sum((d(kx(:),:)-x(im,:)).^2,2),k,nb);
0180         [dm,xn(ii)]=min(py,[],1);                 % min value in each column gives nearest centre
0181         dmk=dm(wk,:);                   % expand into a matrix
0182         dq=py>dmk;                      % update only these values
0183         pr=ones(k,nb);                   % leaving others at 1
0184         pr(dq)=dmk(dq)./py(dq);            % ratio of min(py)./py
0185         pe=pr.^eh;
0186         se=sum(pe,1);
0187         xf=dm.^(eh-1)./se;
0188         g=g+xf*dm.';                     % performance criterion (divided by k)
0189         xg=xf./se;
0190         qik=xg(wk,:).*pe.*pr;           % qik(k,i) is equal to q_ik in [Zhang2000]
0191         qk=qk+sum(qik,2);
0192         xs=xs+qik*d(ii,:);
0193         ix=jx+1;
0194     end
0195     gg(j)=g;
0196     x=xs./qk(:,wp);
0197     if g1-g<=th*g1
0198         ss=ss-1;
0199         if ~ss break; end  %  stop if improvement < threshold for sd consecutive iterations
0200     else
0201         ss=sd;
0202     end
0203 end
0204 gg=gg(1:j)*k/n;                       % scale and trim the performance criterion vector
0205 g=g(end);
0206 % gg' % *** DEBUIG ***
0207 if nargout>1
0208     x=x1;                               % go back to the previous x values if G and/or XN value is output
0209 end
0210