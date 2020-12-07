0001 function [lp,rp,kh,kp]=gaussmixp(y,m,v,w,a,b)
0002 %GAUSSMIXP calculate probability densities from or plot a Gaussian mixture model
0003 %
0004 % Usage: (1) gaussmixp([],m,v,w) % plot a 1D or 2D gaussian mixture pdf
0005 %
0006 % Inputs: n data values, k mixtures, p parameters, q data vector size
0007 %
0008 %   Y(n,q) = input data (or optional plot range if no out arguments)
0009 %            Row of Y(i,:) represents a single observation of the
0010 %            transformed GMM data point X: Y(i,1:q)=X(i,1:p)*A'+B'. If A and B are
0011 %            omitted and q=p, then Y(i,:)=X(i,:).
0012 %   M(k,p) = mixture means for x(p)
0013 %   V(k,p) or V(p,p,k) variances (diagonal or full)
0014 %   W(k,1) = weights
0015 %   A(q,p) = transformation: y=x*A'+ B' (where y and x are row vectors).
0016 %   B(q,1)   If A is omitted or null, y=x*I(B,:)' where I is the identity matrix.
0017 %            If B is also omitted or null, y=x*I(1:q,:)'.
0018 %   Note that most commonly, q=p and A and B are omitted entirely.
0019 %
0020 % Outputs
0021 %
0022 %  LP(n,1) = log probability of each data point
0023 %  RP(n,k) = relative probability of each mixture
0024 %  KH(n,1) = highest probability mixture
0025 %  KP(n,1) = relative probability of highest probability mixture
0026 %
0027 % See also: gaussmix, gaussmixd, gaussmixg, randvec
0028 
0029 %      Copyright (C) Mike Brookes 2000-2009
0030 %      Version: $Id: gaussmixp.m 7339 2016-01-06 18:05:30Z dmb $
0031 %
0032 %   VOICEBOX is a MATLAB toolbox for speech processing.
0033 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0034 %
0035 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0036 %   This program is free software; you can redistribute it and/or modify
0037 %   it under the terms of the GNU General Public License as published by
0038 %   the Free Software Foundation; either version 2 of the License, or
0039 %   (at your option) any later version.
0040 %
0041 %   This program is distributed in the hope that it will be useful,
0042 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0043 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0044 %   GNU General Public License for more details.
0045 %
0046 %   You can obtain a copy of the GNU General Public License from
0047 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0048 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0049 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0050 [k,p]=size(m);
0051 [n,q]=size(y);
0052 if q==0
0053     if nargin<=4 || (nargin==5 && isempty(a)) || (nargin>=6 && isempty(a) && isempty(b))
0054         q=p;
0055     elseif ~isempty(a)
0056         q=size(a,1);
0057     else
0058         q=size(b,1);
0059     end
0060 end
0061 
0062 if nargin<4
0063     w=repmat(1/k,k,1);
0064     if nargin<3
0065         v=ones(k,p);
0066     end
0067 end
0068 fv=ndims(v)>2 || size(v,1)>k;       % full covariance matrix is supplied
0069 if nargin>4 && ~isempty(a)          % need to transform the data
0070     if nargin<6 || isempty(b)
0071         m=m*a';                     % no offset b specified
0072     else
0073         m=m*a'+repmat(b',k,1);      % offset b is specified
0074     end
0075     v1=v;                   % save the original covariance matrix array
0076     v=zeros(q,q,k);         % create new full covariance matrix array
0077     if fv
0078         for ik=1:k
0079             v(:,:,ik)=a*v1(:,:,ik)*a';
0080         end
0081     else
0082         for ik=1:k
0083             v(:,:,ik)=(a.*repmat(v1(ik,:),q,1))*a';
0084         end
0085         fv=1; % now we definitely have a full covariance matrix
0086     end
0087 elseif q<p || nargin>4    % need to select coefficient subset
0088     if nargin<6 || isempty(b)
0089         b=1:q;
0090     end
0091     m=m(:,b);
0092     if fv
0093         v=v(b,b,:);
0094     else
0095         v=v(:,b);
0096     end
0097 end
0098 
0099 memsize=voicebox('memsize');    % set memory size to use
0100 
0101 lp=zeros(n,1);
0102 rp=zeros(n,k);
0103 wk=ones(k,1);
0104 if n>0
0105     if ~fv          % diagonal covariance
0106         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0107         % Diagonal Covariance matrices  %
0108         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0109         
0110         % If data size is large then do calculations in chunks
0111         
0112         nb=min(n,max(1,floor(memsize/(8*q*k))));    % chunk size for testing data points
0113         nl=ceil(n/nb);                  % number of chunks
0114         jx0=n-(nl-1)*nb;                % size of first chunk
0115         im=repmat((1:k)',nb,1);
0116         wnb=ones(1,nb);
0117         wnj=ones(1,jx0);
0118         vi=-0.5*v.^(-1);                % data-independent scale factor in exponent
0119         lvm=log(w)-0.5*sum(log(v),2);   % log of external scale factor (excluding -0.5*q*log(2pi) term)
0120         
0121         % first do partial chunk
0122         
0123         jx=jx0;
0124         ii=1:jx;
0125         kk=repmat(ii,k,1);
0126         km=repmat(1:k,1,jx);
0127         py=reshape(sum((y(kk(:),:)-m(km(:),:)).^2.*vi(km(:),:),2),k,jx)+lvm(:,wnj);
0128         mx=max(py,[],1);                % find normalizing factor for each data point to prevent underflow when using exp()
0129         px=exp(py-mx(wk,:));            % find normalized probability of each mixture for each datapoint
0130         ps=sum(px,1);                   % total normalized likelihood of each data point
0131         rp(ii,:)=(px./ps(wk,:))';                % relative mixture probabilities for each data point (columns sum to 1)
0132         lp(ii)=log(ps)+mx;
0133         
0134         for il=2:nl
0135             ix=jx+1;
0136             jx=jx+nb;                    % increment upper limit
0137             ii=ix:jx;
0138             kk=repmat(ii,k,1);
0139             py=reshape(sum((y(kk(:),:)-m(im,:)).^2.*vi(im,:),2),k,nb)+lvm(:,wnb);
0140             mx=max(py,[],1);                % find normalizing factor for each data point to prevent underflow when using exp()
0141             px=exp(py-mx(wk,:));            % find normalized probability of each mixture for each datapoint
0142             ps=sum(px,1);                   % total normalized likelihood of each data point
0143             rp(ii,:)=(px./ps(wk,:))';                % relative mixture probabilities for each data point (columns sum to 1)
0144             lp(ii)=log(ps)+mx;
0145         end
0146     else
0147         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0148         % Full Covariance matrices  %
0149         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0150         pl=q*(q+1)/2;
0151         lix=1:q^2;
0152         cix=repmat(1:q,q,1);
0153         rix=cix';
0154         lix(cix>rix)=[];                                        % index of lower triangular elements
0155         lixi=zeros(q,q);
0156         lixi(lix)=1:pl;
0157         lixi=lixi';
0158         lixi(lix)=1:pl;                                        % reverse index to build full matrices
0159         vt=reshape(v,q^2,k);
0160         vt=vt(lix,:)';                                            % lower triangular in rows
0161         
0162         % If data size is large then do calculations in chunks
0163         
0164         nb=min(n,max(1,floor(memsize/(24*q*k))));    % chunk size for testing data points
0165         nl=ceil(n/nb);                  % number of chunks
0166         jx0=n-(nl-1)*nb;                % size of first chunk
0167         wnb=ones(1,nb);
0168         wnj=ones(1,jx0);
0169         
0170         vi=zeros(q*k,q);                    % stack of k inverse cov matrices each size q*q
0171         vim=zeros(q*k,1);                   % stack of k vectors of the form inv(vt)*m
0172         mtk=vim;                             % stack of k vectors of the form m
0173         lvm=zeros(k,1);
0174         wpk=repmat((1:q)',k,1);
0175         
0176         for ik=1:k
0177             
0178             % these lines added for debugging only
0179             %             vk=reshape(vt(k,lixi),q,q);
0180             %             condk(ik)=cond(vk);
0181             %%%%%%%%%%%%%%%%%%%%
0182             [uvk,dvk]=eig(reshape(vt(ik,lixi),q,q));      % convert lower triangular to full and find eigenvalues
0183             dvk=diag(dvk);
0184             if(any(dvk<=0))
0185                 error('Covariance matrix for mixture %d is not positive definite',ik);
0186             end
0187             vik=-0.5*uvk*diag(dvk.^(-1))*uvk';   % calculate inverse
0188             vi((ik-1)*q+(1:q),:)=vik;           % vi contains all mixture inverses stacked on top of each other
0189             vim((ik-1)*q+(1:q))=vik*m(ik,:)';   % vim contains vi*m for all mixtures stacked on top of each other
0190             mtk((ik-1)*q+(1:q))=m(ik,:)';       % mtk contains all mixture means stacked on top of each other
0191             lvm(ik)=log(w(ik))-0.5*sum(log(dvk));       % vm contains the weighted sqrt of det(vi) for each mixture
0192         end
0193         %
0194         %         % first do partial chunk
0195         %
0196         jx=jx0;
0197         ii=1:jx;
0198         xii=y(ii,:).';
0199         py=reshape(sum(reshape((vi*xii-vim(:,wnj)).*(xii(wpk,:)-mtk(:,wnj)),q,jx*k),1),k,jx)+lvm(:,wnj);
0200         mx=max(py,[],1);                % find normalizing factor for each data point to prevent underflow when using exp()
0201         px=exp(py-mx(wk,:));  % find normalized probability of each mixture for each datapoint
0202         ps=sum(px,1);                   % total normalized likelihood of each data point
0203         rp(ii,:)=(px./ps(wk,:))';                % relative mixture probabilities for each data point (columns sum to 1)
0204         lp(ii)=log(ps)+mx;
0205         
0206         for il=2:nl
0207             ix=jx+1;
0208             jx=jx+nb;        % increment upper limit
0209             ii=ix:jx;
0210             xii=y(ii,:).';
0211             py=reshape(sum(reshape((vi*xii-vim(:,wnb)).*(xii(wpk,:)-mtk(:,wnb)),q,nb*k),1),k,nb)+lvm(:,wnb);
0212             mx=max(py,[],1);                % find normalizing factor for each data point to prevent underflow when using exp()
0213             px=exp(py-mx(wk,:));  % find normalized probability of each mixture for each datapoint
0214             ps=sum(px,1);                   % total normalized likelihood of each data point
0215             rp(ii,:)=(px./ps(wk,:))';                % relative mixture probabilities for each data point (columns sum to 1)
0216             lp(ii)=log(ps)+mx;
0217         end
0218     end
0219     lp=lp-0.5*q*log(2*pi);
0220 else
0221 end
0222 if nargout >2
0223     [kp,kh]=max(rp,[],2);
0224 end
0225 if ~nargout
0226     switch q
0227         case 1,
0228             nxx=256; % number of points to plot
0229             if size(y,1)<2
0230                 nsd=2; % number of std deviations
0231                 sd=sqrt(v(:));
0232                 xax=linspace(min(m-nsd*sd),max(m+nsd*sd),nxx);
0233             else
0234                 xax=linspace(min(y),max(y),nxx);
0235             end
0236             plot(xax,gaussmixp(xax(:),m,v,w),'-b');
0237             xlabel('Parameter 1');
0238             ylabel('Log probability density');
0239             if n>0
0240                 hold on
0241                 plot(y,lp,'xr');
0242                 hold off
0243             end
0244         case 2,
0245             nxx=256; % number of points to plot
0246             if size(y,1)<2
0247                 nsd=2; % number of std deviations
0248                 if fv
0249                     sd=sqrt([v(1:4:end)' v(4:4:end)']); % extract diagonal elements only
0250                 else
0251                     sd=sqrt(v);
0252                 end
0253                 xax=linspace(min(m(:,1)-nsd*sd(:,1)),max(m(:,1)+nsd*sd(:,1)),nxx);
0254                 yax=linspace(min(m(:,2)-nsd*sd(:,2)),max(m(:,2)+nsd*sd(:,2)),nxx);
0255             else
0256                 xax=linspace(min(y(:,1)),max(y(:,1)),nxx);
0257                 yax=linspace(min(y(:,2)),max(y(:,2)),nxx);
0258             end
0259             xx(:,:,1)=repmat(xax',1,nxx);
0260             xx(:,:,2)=repmat(yax,nxx,1);
0261             imagesc(xax,yax,reshape(gaussmixp(reshape(xx,nxx^2,2),m,v,w),nxx,nxx)');
0262             axis 'xy';
0263             colorbar;
0264             xlabel('Parameter 1');
0265             ylabel('Parameter 2');
0266             cblabel('Log probability density');
0267             if n>0
0268                 hold on
0269                 cmap=colormap;
0270                 clim=get(gca,'CLim');  % get colourmap limits
0271                 msk=lp>clim*[0.5; 0.5];
0272                 if any(msk)
0273                     plot(y(msk,1),y(msk,2),'x','markeredgecolor',cmap(1,:));
0274                 end
0275                 if any(~msk)
0276                     plot(y(~msk,1),y(~msk,2),'x','markeredgecolor',cmap(64,:));
0277                 end
0278                 hold off
0279             end
0280     end
0281 end