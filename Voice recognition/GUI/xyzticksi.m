function s=xyzticksi(ax,ah)
0002 %XYZTIXKSI labels an axis of a plot using SI multipliers S=(AX,AH)
0003 %
0004 % This routine is not intended to be called directly. See XTICKSI and YTICKSI.
0005 
0006 %       Copyright (C) Mike Brookes 2009
0007 %      Version: $Id: xyzticksi.m 713 2011-10-16 14:45:43Z dmb $
0008 %
0009 %   VOICEBOX is a MATLAB toolbox for speech processing.
0010 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0011 %
0012 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0013 %   This program is free software; you can redistribute it and/or modify
0014 %   it under the terms of the GNU General Public License as published by
0015 %   the Free Software Foundation; either version 2 of the License, or
0016 %   (at your option) any later version.
0017 %
0018 %   This program is distributed in the hope that it will be useful,
0019 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0020 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0021 %   GNU General Public License for more details.
0022 %
0023 %   You can obtain a copy of the GNU General Public License from
0024 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0025 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0027 
0028 % Note that "mu" = char(181) assumes Western European encoding
0029 % Bugs:
0030 %   (1) ipan=3 or 4 is not really debugged yet:
0031 %   (2) axis lengths incorrect for 3D graphs
0032 %   (3) should take account of axis shortening due to long labels at the ends
0033 %   (4) should calculate axis orentation from CameraPosition, CameraTarget and CameraUpVector
0034 if nargin<2
0035     ah=gca;
0036     if nargin<1
0037         ax=1;
0038     end
0039 end
0040 axfield={'XLim' 'YLim' 'ZLim'; 'XTick' 'YTick' 'ZTick'; 'XMinorTick' 'YMinorTick' 'ZMinorTick'; 'XTickLabel' 'YTickLabel' 'ZTickLabel'; 'XScale' 'YScale' 'ZScale'};
0041 tryglobal=nargout>0;
0042 digith=1;    % height of a digit in font units
0043 digitw=0.5;    % width of a digit in font units
0044 
0045 prefix={'y','z','a','f','p','n','µ','m','','k','M','G','T','P','E','Z','Y'};
0046 marg=[2 0.5 0.25 0.25];     % gap between labels in font units
0047 ntreq=[3 2 2 1];        % minimum number of labelled ticks required as a function of IPAN
0048 % grid template: each pair is [#steps final-value]. Start=10, end=100
0049 lgridtem={1; [1 20 1 50 1]; [1 20 4]; 9; [2 20 8]; [5 20 2 30 7]; [10 20 5 30 4 50 5]};
0050 ngrid=length(lgridtem);
0051 lgrid=cell(ngrid,1);
0052 agrid=zeros(ngrid,1);       % min and max ratio in decades
0053 % build the actual grid layouts
0054 for i=1:ngrid
0055     igridtem=[lgridtem{i} 100];
0056     igrid=zeros(1,sum(igridtem(1:2:end)));
0057     ntem=length(igridtem)/2;
0058     k=0;
0059     tick0=10;
0060     for j=1:ntem
0061         nstep=igridtem(2*j-1);
0062         igrid(k+1:k+nstep)=tick0+(0:nstep-1)*(igridtem(2*j)-tick0)/igridtem(2*j-1);
0063         k=k+nstep;
0064         tick0=igridtem(2*j);
0065     end
0066     agrid(i)=sum(log10([igrid(2:end) 100]./igrid).^2); % average log interval
0067     lgrid{i}=igrid';                 % grid positions
0068 end
0069 minsubsp=1;        % minimum subtick spacing (in font units)
0070 delcheck=[log10(2) log10(5) 2];     % check linear spacing
0071 delval=[1 2 5];
0072 dosubtick=0;         % default is not to allow subticks
0073 
0074 
0075 
0076 ngrid=length(lgrid);
0077 loggrid=cell(ngrid,1);
0078 for i=1:ngrid
0079     loggrid{i}=log10(lgrid{i})-1;
0080 end
0081 
0082 getgca=get(ah);
0083 set(ah,'Units','points','FontUnits','points');
0084 getgcac=get(ah);
0085 set(ah,'Units',getgca.Units,'FontUnits',getgca.FontUnits); % return to original values
0086 if ax==1
0087     widthc=getgcac.Position(3)/getgcac.FontSize;     % x axis length in font units
0088     axdir=[1 0];        % unit vector in axis direction
0089 else
0090     widthc=2*getgcac.Position(4)/getgcac.FontSize;     % y axis length in font units
0091         axdir=[0 1];        % unit vector in axis direction
0092 end
0093 axdir=max(abs(axdir),1e-10);        % avoid infinity problems
0094 a=getgca.(axfield{1,ax})(1);
0095 b=getgca.(axfield{1,ax})(2);
0096 
0097 ntick=0;
0098 tickint=[];                 % integer label
0099 tickdp=[];                  % tick decimal point position
0100 ticksi=[];                  % tick SI multiplier (always a multiple of 3)
0101 subtick=[];                 % sub tick positions
0102 if strcmp(getgca.(axfield{5,ax}),'log')   % log axis
0103     width10=widthc/log10(b/a); % fount units per decade
0104     ai3=3*ceil(log10(a)/3);             % lowest SI multiplier
0105     bi3=3*floor(log10(b)/3);            % highest SI multiplier
0106     if ai3>=-24 && bi3<=24              % do nothing if outside the SI multiplier range
0107         % first sort out if we can use a global SI multiplier
0108         if tryglobal && a>=10^(bi3-1)
0109             gi=bi3;
0110             s=prefix{9+gi/3};
0111 
0112             globalsi=1;                % global multiplier
0113         else
0114             gi=0;
0115             globalsi=0;                % disable global multiplier
0116             s='';
0117 
0118         end
0119         g=10^gi;
0120         ag=a/g;
0121         bg=b/g;
0122         al=log10(ag);
0123         bl=log10(bg);
0124         ai=ceil(al);
0125         bi=floor(bl);
0126         ai3=3*ceil(ai/3);
0127         bi3=3*floor(bi/3);
0128         for ipan=1:4                    % panic level: 1=spacious, 2=cramped, 3=any two labels, 4=any label
0129             % first try labelling only exact SI multiples
0130             margin=marg(ipan);
0131             incsi=3*ceil(min((2*digitw+margin)/axdir(1),(digith+margin)/axdir(2))/(3*width10));   % SI increment
0132             switch ipan
0133                 case {1,2}
0134                     ticksi=incsi*ceil(ai/incsi):incsi:incsi*floor(bi/incsi);
0135                 case {3,4}
0136                     ticksi=ai3:incsi:bi3;
0137             end
0138             ntick=length(ticksi);
0139             tickint=ones(1,ntick);
0140             tickdp=zeros(1,ntick);
0141             if width10>0.25
0142                 ticki=ai:bi;
0143                 subtick=10.^(ticki(ticki~=3*fix(ticki/3)));      % put subticks at all powers of 10;
0144             end
0145             if incsi==3         % no point in trying anything else if incsi>3
0146                 ci=floor(al);   % start of first decade that includes the start of the axis
0147                 cibi=ci:bi;     % ennumerate the decades that cover the entire axis
0148                 ndec=bi-ci+1;   % number of decades
0149                 if globalsi
0150                     siq0=zeros(1,ndec); % no SI multipliers within the labels if using a global multiplier
0151                 else
0152                     siq0=3*floor((cibi)/3); % determine the SI multiplier for each of the decades
0153                 end
0154                 siw0=siq0~=0;                % width of SI multiplier
0155                 dpq0=max(siq0-cibi+1,1);    % number of decimal places
0156                 for jgrid=1:ngrid
0157                     igrid=jgrid-(ipan<=2)*(2*jgrid-ngrid-1);
0158                     lgridi=lgrid{igrid};
0159                     ngridi=length(lgridi);
0160                     intq=reshape(repmat(lgridi,1,ndec).*repmat(10.^(cibi+dpq0-siq0-1),ngridi,1),1,[]);
0161                     dpq=reshape(repmat(dpq0,ngridi,1),1,[]);
0162                     msk=dpq>0 & rem(intq,10)==0;
0163                     intq(msk)=intq(msk)/10;
0164                     dpq(msk)=dpq(msk)-1;
0165                     widq=1+floor(log10(intq));
0166                     widq=digitw*(widq+(dpq>0).*max(1,dpq+2-widq)+reshape(repmat(siw0,ngridi,1),1,[]));
0167                     logvq=reshape(repmat(loggrid{igrid},1,ndec)+repmat(ci:ndec+ci-1,ngridi,1),1,[]);
0168                     % mask out any ticks outside the axis range
0169                     msk=logvq>=al & logvq<=bl;
0170                     widq=widq(msk);
0171                     logvq=logvq(msk);
0172                     % debug1=[intq(msk); -1 min((widq(1:end-1)+widq(2:end)+2*margin)/axdir(1),2*(digith+margin)/axdir(2))<=2*width10*(logvq(2:end)-logvq(1:end-1))];
0173                     if numel(widq)>=ntreq(ipan) && all(min((widq(1:end-1)+widq(2:end)+2*margin)/axdir(1),2*(digith+margin)/axdir(2))<=2*width10*(logvq(2:end)-logvq(1:end-1)))
0174                         % success: we have an acceptable pattern
0175                         ntick=numel(widq);       % number of ticks
0176                         tickint=intq(msk);      % integer label value (i.e. neglecting decimal point)
0177                         tickdp=dpq(msk);        % number of decimal places
0178                         siq=reshape(repmat(siq0,ngridi,1),1,[]);    % SI mltiplier power
0179                         ticksi=siq(msk);        % SI multiplier power masked
0180                         subtick=[];             % recalculate any subticks
0181                         dosubtick=igrid>1;
0182                         break;                  % do not try any more grid patterns
0183                     end
0184                 end % alternative grid patterns
0185                 % finally just try a linear increment
0186                 if ntick<5
0187                     ldeltamin=log10(bg- bg*10^(-min((digitw+margin)/axdir(1),(digith+margin)/axdir(2))/width10));  % smallest conceivable increment
0188                     ildelta=floor(ldeltamin);
0189                     ix=find(ldeltamin-ildelta<=delcheck,1);
0190                     jx=ildelta*3+ix;
0191                     while 1
0192                         deltax=floor(jx/3);
0193                         deltav=delval(jx-3*deltax+1);
0194                         delta=deltav*10^deltax;
0195                         multq=ceil(ag/delta):floor(bg/delta);   % multiples of delta to display
0196                         ntickq=numel(multq);
0197                         if ntickq<=ntick || ntickq<ntreq(ipan)   % give up now
0198                             break;
0199                         end
0200                         intq=deltav*multq;
0201                         lintq=floor(log10(intq));
0202                         siq=3*floor((lintq+deltax)/3);      % SI multiplier
0203                         dpq=siq-deltax;
0204                         msk=dpq<0;
0205                         intq(msk)=intq(msk).*10.^(-dpq(msk));
0206                         dpq(msk)=0;
0207                         msk=rem(intq,10)==0 & dpq>0;
0208                         while any(msk)      % remove unwanted trailing zeros
0209                             dpq(msk)=dpq(msk)-1;
0210                             intq(msk)=intq(msk)/10;
0211                             msk=rem(intq,10)==0 & dpq>0;
0212                         end
0213                         widq=1+floor(log10(intq));
0214                         widq=digitw*(widq+(dpq>0).*max(1,dpq+2-widq)+(siq~=0));
0215                         logvq=log10(multq)+log10(deltav)+deltax;
0216                         % debug2=[intq; widq; -1 (widq(1:end-1)+widq(2:end)+2*margin)<=2*width10*(logvq(2:end)-logvq(1:end-1))];
0217                         if all(min((widq(1:end-1)+widq(2:end)+2*margin)/axdir(1),2*(digith+margin)/axdir(2))<=2*width10*(logvq(2:end)-logvq(1:end-1)))
0218                             ntick=ntickq;
0219                             tickint=intq;
0220                             tickdp=dpq;
0221                             ticksi=siq;
0222                             dosubtick=1;
0223                             break
0224                         end
0225                         jx=jx+1;                            % try next coarser spacing
0226                     end
0227                 end
0228             end % try grid patterns since at most one exact SI multiple
0229             if ntick>=ntreq(ipan)
0230                 break% quit if we have enough labels
0231             end
0232         end% try next panic level
0233     end    % check if within SI range
0234     if ntick
0235         tickexp=gi+ticksi-tickdp;
0236         tickpos=tickint .* 10.^tickexp;
0237         ratthresh=10^(minsubsp/width10);   % min subtick ratio
0238         if dosubtick       % check for subticks
0239             subtick=[];
0240             if ntick>1      % at least two labelled ticks
0241                 stepexp=min(tickexp(1:end-1),tickexp(2:end))-1;
0242                 stepint=round((tickpos(2:end)-tickpos(1:end-1)).*10.^(-stepexp));  % always a multiple of 10
0243                 stepleft=tickint(1:end-1).*10.^(tickexp(1:end-1)-stepexp); % leftmost label in units of 10^stepexp
0244                 subbase=10.^ceil(log10(stepint)-1); % base sub-tick interval in units of 10^stepexp
0245                 substep=[-1 -3 5]*((1+[1; 2; 5]*(subbase./stepleft))>ratthresh); % actual step is 1,2 or 5 times subbase
0246                 substep(stepint~=10*substep)=max(2-substep(stepint~=10*substep),0); % but only >1 if stepint==10
0247                 substep=substep.*subbase; % subtick step in units of 10^stepexp
0248                 for i=1:ntick-1
0249                     ss=substep(i);
0250                     sl=stepleft(i);
0251                     if ss
0252                         subtick=[subtick (sl+(ss:ss:stepint(i)-ss))*10^stepexp(i)];
0253                         if i==1 && sl/(sl-ss)>ratthresh
0254                             subtick=[subtick (sl-(ss:ss:floor((tickpos(1)-a)/(ss*10^stepexp(i)))*ss))*10^stepexp(i)];
0255                         elseif i==ntick-1 && (1+ss/(sl+stepint(1)))>ratthresh
0256                             subtick=[subtick (sl+stepint(i)+(ss:ss:floor((b-tickpos(end))/(ss*10^stepexp(i)))*ss))*10^stepexp(i)];
0257                         end
0258                     end
0259                 end
0260             end
0261         end % if subtick
0262         [tps,ix]=sort([tickpos subtick]);
0263         nticks=length(tps);
0264         ticklab=cell(nticks,1);
0265         for j=1:nticks
0266             i=ix(j);
0267             if i>ntick
0268                 ticklab{j}='';
0269             else
0270                 ticklab{j}=sprintf(sprintf('%%.%df%%s',tickdp(i)),tickint(i)*10^(-tickdp(i)),prefix{ticksi(i)/3+9});
0271             end
0272         end
0273         if width10<2.5
0274             set(ah,axfield{3,ax},'off');
0275         end
0276         set(ah,axfield{2,ax},tps);
0277         set(ah,axfield{4,ax},ticklab);
0278     end
0279 
0280 else                    % linear axis
0281     for ipan=1:4                    % panic level: 1=spacious, 2=cramped, 3=any two labels, 4=any label
0282         margin=marg(ipan);
0283         % select a global multiplier
0284         if tryglobal
0285             gi=3*floor(log10(max(abs(a),abs(b)))/3);
0286             s=prefix{9+gi/3};
0287 
0288         else
0289             gi=0;
0290             s='';
0291         end
0292         g=10^gi;
0293         ag=a/g;
0294         bg=b/g;
0295         width1=widthc/(bg-ag);                  % width of 1 plot unit in font units
0296         ldeltamin=log10(min((digitw+margin)/axdir(1),(digith+margin)/axdir(2))/width1);        % log of smallest conceivable increment
0297         ildelta=floor(ldeltamin);
0298         ix=find(ldeltamin-ildelta<=delcheck,1);
0299         jx=ildelta*3+ix;
0300         while 1 % loop trying increasingly coarse labelling
0301             deltax=floor(jx/3);         % exponent of label increment
0302             deltav=delval(jx-3*deltax+1); % mantissa of label increment
0303             delta=deltav*10^deltax;         % actual label inrement
0304             multq=ceil(ag/delta):floor(bg/delta);   % multiples of delta to display
0305             ntickq=numel(multq);
0306             if ntickq<ntreq(ipan)   % give up now if too few labels
0307                 break;
0308             end
0309             intq=deltav*multq;
0310             lintq=floor(log10(abs(intq)+(intq==0)));
0311             siq=3*floor((lintq+deltax)/3)*~tryglobal;      % SI multiplier, but only if no global multiplier
0312             dpq=siq-deltax;
0313             msk=dpq<0;
0314             intq(msk)=intq(msk).*10.^(-dpq(msk));
0315             dpq(msk)=0;
0316             msk=rem(intq,10)==0 & dpq>0;
0317             while any(msk)      % remove unwanted trailing zeros
0318                 dpq(msk)=dpq(msk)-1;
0319                 intq(msk)=intq(msk)/10;
0320                 msk=rem(intq,10)==0 & dpq>0;
0321             end
0322             widq=1+floor(log10(abs(intq)+(intq==0)));
0323             widq=digitw*(widq+(dpq>0).*max(1,dpq+2-widq)+(siq~=0).*(intq~=0)+(intq<0)); % calculate width of each label
0324             % debug2=[intq; widq; digith+margin<=axdir(2)*width1*delta (widq(1:end-1)+widq(2:end)+2*margin)<=2*width1*delta];
0325             if all((widq(1:end-1)+widq(2:end)+2*margin)<=2*axdir(1)*width1*delta) || (digith+margin<=axdir(2)*width1*delta);
0326                 ntick=ntickq;
0327                 tickint=intq;
0328                 tickdp=dpq;
0329                 ticksi=siq;
0330                 if deltav>1 && width1*delta>0.5*deltav          % put explicit subticks if delta = 2 or 5
0331                     mults=ceil(ag*deltav/delta):floor(bg*deltav/delta);
0332                     subtick=(mults(deltav*fix(mults/deltav)~=mults))*delta/deltav;
0333                 else
0334                     subtick=[];
0335                 end
0336                 break                       % do not try any more coarser spacings
0337             end
0338             jx=jx+1;                            % try next coarser spacing
0339         end
0340         if ntick>=ntreq(ipan)
0341             break% quit if we have enough labels
0342         end
0343     end
0344     if ntick
0345         tickexp=gi+ticksi-tickdp;
0346         tickpos=tickint .* 10.^tickexp;
0347         [tps,ix]=sort([tickpos subtick*10^gi]);
0348         nticks=length(tps);
0349         ticklab=cell(nticks,1);
0350         for j=1:nticks
0351             i=ix(j);
0352             if i>ntick
0353                 ticklab{j}='';
0354             else
0355                 ticklab{j}=sprintf(sprintf('%%.%df%%s',tickdp(i)),tickint(i)*10^(-tickdp(i)),prefix{(ticksi(i)/3)*(tickint(i)~=0)+9});
0356             end
0357         end
0358         set(ah,axfield{2,ax},tps);
0359         set(ah,axfield{4,ax},ticklab);
0360         set(ah,axfield{3,ax},'on');
0361     end
0362 end