0001 function [m,v,w]=gaussmixt(m1,v1,w1,m2,v2,w2)
0002 %GAUSSMIXT Multiply two GMM pdfs
0003 %
0004 % Inputs: Input mixtures: k1,k2 mixtures, p dimensions
0005 %
0006 %   M(k1,p) = mixture means for mixture 1
0007 %   V(k1,p) or V(p,p,k1) variances (diagonal or full)
0008 %   W(k1,1) = mixture weights
0009 %   M(k2,p) = mixture means for mixture 2
0010 %   V(k2,p) or V(p,p,k2) variances (diagonal or full)
0011 %   W(k2,1) = mixture weights
0012 %
0013 % Outputs:
0014 %
0015 %   M(k1*k2,p) = mixture means
0016 %   V(k1*k2,p) or V(p,p,k1*k2) if p>1 and at least one input has full covariance matrix
0017 %   W(k1*k2,1) = mixture weights
0018 %
0019 % See also: gaussmix, gaussmixg, gaussmixp, randvec
0020 
0021 %      Copyright (C) Mike Brookes 2000-2012
0022 %      Version: $Id: gaussmixt.m 5453 2014-11-19 13:10:51Z dmb $
0023 %
0024 %   VOICEBOX is a MATLAB toolbox for speech processing.
0025 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0026 %
0027 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0028 %   This program is free software; you can redistribute it and/or modify
0029 %   it under the terms of the GNU General Public License as published by
0030 %   the Free Software Foundation; either version 2 of the License, or
0031 %   (at your option) any later version.
0032 %
0033 %   This program is distributed in the hope that it will be useful,
0034 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0035 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0036 %   GNU General Public License for more details.
0037 %
0038 %   You can obtain a copy of the GNU General Public License from
0039 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0040 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0041 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0042 persistent r13 r21 r22 r31 r312 r112 r1223 r321 ch1h r122 r124
0043 if isempty(r21)
0044     r13=[1 3];
0045     r21=[2 1];
0046     r22=[2 2];
0047     r31=[3 1];
0048     r112=[1 1 2];
0049     r122=[1 2 2];
0050     r124=[1 2 4];
0051     r312=[3 1 2];
0052     r321=[3 2 1];
0053     r1223=[1 2 2 3];
0054     ch1h=[-0.5; 1; -0.5];
0055 end
0056 [k1,p]=size(m1);
0057 [k2,p2]=size(m2);
0058 f1=ndims(v1)>2 || size(v1,1)>k1; % full covariance matrix is supplied
0059 f2=ndims(v2)>2 || size(v2,1)>k2; % full covariance matrix is supplied
0060 % ff=f1+2*f2;
0061 if p~=p2
0062     error('mixtures must have the same vector dimension');
0063 end
0064 k=k1*k2;
0065 j1=repmat((1:k1)',k2,1);
0066 j2=reshape(repmat(1:k2,k1,1),k,1);
0067 if p==1
0068     % display('1D vectors');
0069     p1=1./v1(:);
0070     p2=1./v2(:);
0071     v=1./(p1(j1)+p2(j2));
0072     s1=p1.*m1;
0073     s2=p2.*m2;
0074     m=v.*(s1(j1)+s2(j2));
0075     v12=v1(j1)+v2(j2);
0076     wx=-0.5*(m1(j1)-m2(j2)).^2./v12(:);
0077     wx=wx-max(wx); % normalize to avoid underflow
0078     w=w1(j1).*w2(j2).*exp(wx)./sqrt(v12(:));
0079     w=w/sum(w);
0080 else
0081     if ~f1 && ~f2 % both diagonal covariances
0082         % display('both diagonal');
0083         p1=1./v1;
0084         p2=1./v2;
0085         v=1./(p1(j1,:)+p2(j2,:));
0086         s1=p1.*m1;
0087         s2=p2.*m2;
0088         m=v.*(s1(j1,:)+s2(j2,:));
0089         v12=v1(j1,:)+v2(j2,:);
0090         wx=-0.5*sum((m1(j1,:)-m2(j2,:)).^2./v12,2);
0091         wx=wx-max(wx); % normalize to avoid underflow
0092         w=w1(j1).*w2(j2).*exp(wx)./sqrt(prod(v12,2));
0093         w=w/sum(w);
0094     else % at least one full covariances
0095         m=zeros(k,p);
0096         v=zeros(p,p,k);
0097         w=zeros(k,1);
0098         wx=w;
0099         idp=1:p+1:p*p; % diagonal elements of p x p matrix
0100         if p==2                 % special code for 2D vectors
0101             if ~f2  % GMM 2 is diagonal
0102                 % display('2D GMM 2 diagonal');
0103                 p2=1./v2;
0104                 pm2=p2.*m2;
0105                 vx1=permute(v1,r312);
0106                 vx1=vx1(:,r124);
0107                 px1=vx1./repmat((vx1(:,1).*vx1(:,3)-vx1(:,2).^2),1,3); % [a b; b c] -> [c -b a]
0108                 pm1=m1.*px1(:,r31)-m1(:,r21).*px1(:,r22);
0109                 px=px1(j1,:);
0110                 px(:,r31)=px(:,r31)+p2(j2,:);  % add onto diagonal elements
0111                 vijx=vx1(j1,:);
0112                 vijx(:,r13)=vijx(:,r13)+v2(j2,:);  % add onto diagonal elements
0113             elseif ~f1 % GMM 1 is diagonal
0114                 % display('2D GMM 1 diagonal');
0115                 p1=1./v1;
0116                 pm1=p1.*m1;
0117                 vx2=permute(v2,r312);
0118                 vx2=vx2(:,r124);
0119                 px2=vx2./repmat((vx2(:,1).*vx2(:,3)-vx2(:,2).^2),1,3); % [a b; b c] -> [c -b a]
0120                 pm2=m2.*px2(:,r31)-m2(:,r21).*px2(:,r22);
0121                 px=px2(j2,:);
0122                 px(:,r31)=px(:,r31)+p1(j1,:);  % add onto diagonal elements
0123                 vijx=vx2(j2,:);
0124                 vijx(:,r13)=vijx(:,r13)+v1(j1,:);  % add onto diagonal elements
0125             else % both full covariances
0126                 % display('2D both full');
0127                 vx1=permute(v1,r312);
0128                 vx1=vx1(:,r124); % make each 2 x 2 matrix into a row [a b; b c] -> [a b c]
0129                 px1=vx1./repmat((vx1(:,1).*vx1(:,3)-vx1(:,2).^2),1,3); % [a b; b c] -> [c -b a]
0130                 vx2=permute(v2,r312);
0131                 vx2=vx2(:,r124);
0132                 px2=vx2./repmat((vx2(:,1).*vx2(:,3)-vx2(:,2).^2),1,3); % [a b; b c] -> [c -b a]
0133                 pm1=m1.*px1(:,r31)-m1(:,r21).*px1(:,r22);
0134                 pm2=m2.*px2(:,r31)-m2(:,r21).*px2(:,r22);
0135                 px=px1(j1,:)+px2(j2,:);
0136                 vijx=vx1(j1,:)+vx2(j2,:);
0137             end
0138             vx=px./repmat((px(:,1).*px(:,3)-px(:,2).^2),1,3);   % divide by determinant to get inverse
0139             m=pm1(j1,:)+pm2(j2,:);
0140             m=m.*vx(:,r13)+m(:,r21).*vx(:,r22);                 % multiple by 2 x 2 matrix vx
0141             v=reshape(vx(:,r1223)',[2 2 k]);                    % convert vx to a 3D array of 2 x 2 matrices
0142             m12=m1(j1,:)-m2(j2,:);                              % subtract means to calculate weight exponent
0143             dij=vijx(:,1).*vijx(:,3)-vijx(:,2).^2;              % determinant of V1+V2
0144             wx=m12(:,r112).*m12(:,r122).*vijx(:,r321)*ch1h./dij;% exponent of weight
0145             w=w1(j1).*w2(j2)./sqrt(dij);                        % weight is w*exp(wx)
0146         else
0147             if ~f2  % GMM 2 is diagonal
0148                 % display('GMM 2 diagonal');
0149                 p2=1./v2;
0150                 pm2=p2.*m2;
0151                 for i=1:k1
0152                     v1i=v1(:,:,i);
0153                     p1i=inv(v1i);
0154                     m1i=m1(i,:);
0155                     pm1i=m1i*p1i;
0156                     w1i=w1(i);
0157                     ix=i;
0158                     for j=1:k2
0159                         pij=p1i;
0160                         pij(idp)=pij(idp)+p2(j,:);
0161                         vix=inv(pij);
0162                         vij=v1i;
0163                         vij(idp)=vij(idp)+v2(j,:);
0164                         v(:,:,ix)=vix;
0165                         m(ix,:)=(pm2(j,:)+pm1i)*vix;
0166                         m12=m2(j,:)-m1i;
0167                         wx(ix)=-0.5*m12/vij*m12';           % exponent of weight
0168                         w(ix)=w2(j)*w1i/sqrt(det(vij));     % weight is w*exp(wx)
0169                         ix=ix+k1;
0170                     end
0171                 end
0172             elseif ~f1 % GMM 1 is diagonal
0173                 % display('GMM 1 diagonal');
0174                 p1=1./v1;
0175                 pm1=p1.*m1;
0176                 ix=1;
0177                 for j=1:k2
0178                     v2j=v2(:,:,j);
0179                     p2j=inv(v2j);
0180                     m2j=m2(j,:);
0181                     pm2j=m2j*p2j;
0182                     w2j=w2(j);
0183                     for i=1:k1
0184                         pij=p2j;
0185                         pij(idp)=pij(idp)+p1(i,:);
0186                         vix=inv(pij);
0187                         vij=v2j;
0188                         vij(idp)=vij(idp)+v1(i,:);
0189                         v(:,:,ix)=vix;
0190                         m(ix,:)=(pm1(i,:)+pm2j)*vix;
0191                         m12=m1(i,:)-m2j;
0192                         wx(ix)=-0.5*m12/vij*m12';           % exponent of weight
0193                         w(ix)=w1(i)*w2j/sqrt(det(vij));     % weight is w*exp(wx)
0194                         ix=ix+1;
0195                     end
0196                 end
0197             else % both full covariances
0198                 % display('both full');
0199                 p1=zeros(p,p,k1);
0200                 pm1=zeros(k1,p);
0201                 for i=1:k1
0202                     p1i=inv(v1(:,:,i));
0203                     p1(:,:,i)=p1i;
0204                     pm1(i,:)=m1(i,:)*p1i;
0205                 end
0206                 ix=1;
0207                 for j=1:k2
0208                     v2j=v2(:,:,j);
0209                     p2j=inv(v2j);
0210                     m2j=m2(j,:);
0211                     pm2j=m2j*p2j;
0212                     w2j=w2(j);
0213                     for i=1:k1
0214                         pij=p1(:,:,i)+p2j;
0215                         vix=inv(pij);
0216                         v(:,:,ix)=vix;
0217                         vij=v1(:,:,i)+v2j;
0218                         m(ix,:)=(pm1(i,:)+pm2j)*vix;
0219                         m12=m1(i,:)-m2j;
0220                         wx(ix)=-0.5*m12/vij*m12';           % exponent of weight
0221                         w(ix)=w1(i)*w2j/sqrt(det(vij));     % weight is w*exp(wx)
0222                         ix=ix+1;
0223                     end
0224                 end
0225             end
0226             
0227         end
0228         wx=wx-max(wx);              % adjust exponents to avoid underflow
0229         w=w.*exp(wx);               % calculate weights
0230         w=w/sum(w);                 % normalize weights to sum to unity
0231         if k==1
0232             v=reshape(v,size(v,1),size(v,2)); % squeeze last dimension of v if possible
0233         end
0234     end
0235 end
0236 if ~nargout
0237     if p==1
0238         nxx=256; % number of points to plot
0239         nsd=3; % number of std deviations
0240         sd=sqrt([v1(:);v2(:);v]);
0241         ma=[m1;m2;m];
0242         xax=linspace(min(ma-nsd*sd),max(ma+nsd*sd),nxx);
0243         plot(xax,gaussmixp(xax(:),m1,v1,w1),'--b');
0244         hold on
0245         plot(xax,gaussmixp(xax(:),m2,v2,w2),':r');
0246         plot(xax,gaussmixp(xax(:),m,v,w),'-k');
0247         hold off
0248         ylabel('Log probability density');
0249         legend('Mix 1','Mix 2','Product','location','best');
0250         axisenlarge([-1 -1 -1 -1.05]);
0251     elseif p==2
0252         nxx=128; % number of points to plot
0253         nsd=3;
0254         if f1
0255             s1=sqrt([v1(1:4:end)' v1(4:4:end)']); % extract diagonal elements only
0256         else
0257             s1=sqrt(v1);
0258         end
0259         if f2
0260             s2=sqrt([v2(1:4:end)' v2(4:4:end)']); % extract diagonal elements only
0261         else
0262             s2=sqrt(v2);
0263         end
0264         if ndims(v)>2 || size(v,1)>k
0265             s3=sqrt([v(1:4:end)' v(4:4:end)']); % extract diagonal elements only
0266         else
0267             s3=sqrt(v);
0268         end
0269         mal=[m1;m2;m];
0270         sal=[s1;s2;s3];
0271         xax=linspace(min(mal(:,1)-nsd*sal(:,1)),max(mal(:,1)+nsd*sal(:,1)),nxx);
0272         yax=linspace(min(mal(:,2)-nsd*sal(:,2)),max(mal(:,2)+nsd*sal(:,2)),nxx);
0273         xx(:,:,1)=repmat(xax',1,nxx);
0274         xx(:,:,2)=repmat(yax,nxx,1);
0275         xx=reshape(xx,nxx^2,2);
0276         subplot(2,2,1);
0277         imagesc(xax,yax,reshape(gaussmixp(xx,m1,v1,w1),nxx,nxx)');
0278         axis 'xy';
0279         title('Input Mix 1');
0280         subplot(2,2,2);
0281         imagesc(xax,yax,reshape(gaussmixp(xx,m2,v2,w2),nxx,nxx)');
0282         axis 'xy';
0283         title('Input Mix 2');
0284         subplot(2,2,3);
0285         imagesc(xax,yax,reshape(gaussmixp(xx,m,v,w),nxx,nxx)');
0286         axis 'xy';
0287         title('Product GMM');
0288     end
0289 end