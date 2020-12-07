function [x,mc,mn,mx]=melbankm(p,n,fs,fl,fh,w)
0002 %MELBANKM determine matrix for a mel/erb/bark-spaced filterbank [X,MN,MX]=(P,N,FS,FL,FH,W)
0003 %
0004 % Inputs:
0005 %       p   number of filters in filterbank or the filter spacing in k-mel/bark/erb [ceil(4.6*log10(fs))]
0006 %        n   length of fft
0007 %        fs  sample rate in Hz
0008 %        fl  low end of the lowest filter as a fraction of fs [default = 0]
0009 %        fh  high end of highest filter as a fraction of fs [default = 0.5]
0010 %        w   any sensible combination of the following:
0011 %             'b' = bark scale instead of mel
0012 %             'e' = erb-rate scale
0013 %             'l' = log10 Hz frequency scale
0014 %             'f' = linear frequency scale
0015 %
0016 %             'c' = fl/fh specify centre of low and high filters
0017 %             'h' = fl/fh are in Hz instead of fractions of fs
0018 %             'H' = fl/fh are in mel/erb/bark/log10
0019 %
0020 %              't' = triangular shaped filters in mel/erb/bark domain (default)
0021 %              'n' = hanning shaped filters in mel/erb/bark domain
0022 %              'm' = hamming shaped filters in mel/erb/bark domain
0023 %
0024 %              'z' = highest and lowest filters taper down to zero [default]
0025 %              'y' = lowest filter remains at 1 down to 0 frequency and
0026 %                    highest filter remains at 1 up to nyquist freqency
0027 %
0028 %             'u' = scale filters to sum to unity
0029 %
0030 %             's' = single-sided: do not double filters to account for negative frequencies
0031 %
0032 %             'g' = plot idealized filters [default if no output arguments present]
0033 %
0034 % Note that the filter shape (triangular, hamming etc) is defined in the mel (or erb etc) domain.
0035 % Some people instead define an asymmetric triangular filter in the frequency domain.
0036 %
0037 %               If 'ty' or 'ny' is specified, the total power in the fft is preserved.
0038 %
0039 % Outputs:    x     a sparse matrix containing the filterbank amplitudes
0040 %                  If the mn and mx outputs are given then size(x)=[p,mx-mn+1]
0041 %                 otherwise size(x)=[p,1+floor(n/2)]
0042 %                 Note that the peak filter values equal 2 to account for the power
0043 %                 in the negative FFT frequencies.
0044 %           mc    the filterbank centre frequencies in mel/erb/bark
0045 %            mn    the lowest fft bin with a non-zero coefficient
0046 %            mx    the highest fft bin with a non-zero coefficient
0047 %                 Note: you must specify both or neither of mn and mx.
0048 %
0049 % Examples of use:
0050 %
0051 % (a) Calcuate the Mel-frequency Cepstral Coefficients
0052 %
0053 %       f=rfft(s);                    % rfft() returns only 1+floor(n/2) coefficients
0054 %        x=melbankm(p,n,fs);            % n is the fft length, p is the number of filters wanted
0055 %        z=log(x*abs(f).^2);         % multiply x by the power spectrum
0056 %        c=dct(z);                   % take the DCT
0057 %
0058 % (b) Calcuate the Mel-frequency Cepstral Coefficients efficiently
0059 %
0060 %       f=fft(s);                        % n is the fft length, p is the number of filters wanted
0061 %       [x,mc,na,nb]=melbankm(p,n,fs);   % na:nb gives the fft bins that are needed
0062 %       z=log(x*(f(na:nb)).*conj(f(na:nb)));
0063 %
0064 % (c) Plot the calculated filterbanks
0065 %
0066 %      plot((0:floor(n/2))*fs/n,melbankm(p,n,fs)')   % fs=sample frequency
0067 %
0068 % (d) Plot the idealized filterbanks (without output sampling)
0069 %
0070 %      melbankm(p,n,fs);
0071 %
0072 % References:
0073 %
0074 % [1] S. S. Stevens, J. Volkman, and E. B. Newman. A scale for the measurement
0075 %     of the psychological magnitude of pitch. J. Acoust Soc Amer, 8: 185–19, 1937.
0076 % [2] S. Davis and P. Mermelstein. Comparison of parametric representations for
0077 %     monosyllabic word recognition in continuously spoken sentences.
0078 %     IEEE Trans Acoustics Speech and Signal Processing, 28 (4): 357–366, Aug. 1980.
0079 
0080 
0081 %      Copyright (C) Mike Brookes 1997-2009
0082 %      Version: $Id: melbankm.m 713 2011-10-16 14:45:43Z dmb $
0083 %
0084 %   VOICEBOX is a MATLAB toolbox for speech processing.
0085 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0086 %
0087 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0088 %   This program is free software; you can redistribute it and/or modify
0089 %   it under the terms of the GNU General Public License as published by
0090 %   the Free Software Foundation; either version 2 of the License, or
0091 %   (at your option) any later version.
0092 %
0093 %   This program is distributed in the hope that it will be useful,
0094 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0095 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0096 %   GNU General Public License for more details.
0097 %
0098 %   You can obtain a copy of the GNU General Public License from
0099 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0100 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0101 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0102 
0103 % Note "FFT bin_0" assumes DC = bin 0 whereas "FFT bin_1" means DC = bin 1
0104 
0105 if nargin < 6
0106     w='tz'; % default options
0107     if nargin < 5
0108         fh=0.5; % max freq is the nyquist
0109         if nargin < 4
0110             fl=0; % min freq is DC
0111         end
0112     end
0113 end
0114 sfact=2-any(w=='s');   % 1 if single sided else 2
0115 wr=' ';   % default warping is mel
0116 for i=1:length(w)
0117     if any(w(i)=='lebf');
0118         wr=w(i);
0119     end
0120 end
0121 if any(w=='h') || any(w=='H')
0122     mflh=[fl fh];
0123 else
0124     mflh=[fl fh]*fs;
0125 end
0126 if ~any(w=='H')
0127     switch wr
0128                     case 'f'       % no transformation
0129         case 'l'
0130             if fl<=0
0131                 error('Low frequency limit must be >0 for l option');
0132             end
0133             mflh=log10(mflh);       % convert frequency limits into log10 Hz
0134         case 'e'
0135             mflh=frq2erb(mflh);       % convert frequency limits into erb-rate
0136         case 'b'
0137             mflh=frq2bark(mflh);       % convert frequency limits into bark
0138         otherwise
0139             mflh=frq2mel(mflh);       % convert frequency limits into mel
0140     end
0141 end
0142 melrng=mflh*(-1:2:1)';          % mel range
0143 fn2=floor(n/2);     % bin index of highest positive frequency (Nyquist if n is even)
0144 if isempty(p)
0145     p=ceil(4.6*log10(fs));         % default number of filters
0146 end
0147 if any(w=='c')              % c option: specify fiter centres not edges
0148 if p<1
0149     p=round(melrng/(p*1000))+1;
0150 end
0151 melinc=melrng/(p-1);
0152 mflh=mflh+(-1:2:1)*melinc;
0153 else
0154     if p<1
0155     p=round(melrng/(p*1000))-1;
0156 end
0157 melinc=melrng/(p+1);
0158 end
0159 
0160 %
0161 % Calculate the FFT bins corresponding to [filter#1-low filter#1-mid filter#p-mid filter#p-high]
0162 %
0163 switch wr
0164         case 'f'
0165         blim=(mflh(1)+[0 1 p p+1]*melinc)*n/fs;
0166     case 'l'
0167         blim=10.^(mflh(1)+[0 1 p p+1]*melinc)*n/fs;
0168     case 'e'
0169         blim=erb2frq(mflh(1)+[0 1 p p+1]*melinc)*n/fs;
0170     case 'b'
0171         blim=bark2frq(mflh(1)+[0 1 p p+1]*melinc)*n/fs;
0172     otherwise
0173         blim=mel2frq(mflh(1)+[0 1 p p+1]*melinc)*n/fs;
0174 end
0175 mc=mflh(1)+(1:p)*melinc;    % mel centre frequencies
0176 b1=floor(blim(1))+1;            % lowest FFT bin_0 required might be negative)
0177 b4=min(fn2,ceil(blim(4))-1);    % highest FFT bin_0 required
0178 %
0179 % now map all the useful FFT bins_0 to filter1 centres
0180 %
0181 switch wr
0182         case 'f'
0183         pf=((b1:b4)*fs/n-mflh(1))/melinc;
0184     case 'l'
0185         pf=(log10((b1:b4)*fs/n)-mflh(1))/melinc;
0186     case 'e'
0187         pf=(frq2erb((b1:b4)*fs/n)-mflh(1))/melinc;
0188     case 'b'
0189         pf=(frq2bark((b1:b4)*fs/n)-mflh(1))/melinc;
0190     otherwise
0191         pf=(frq2mel((b1:b4)*fs/n)-mflh(1))/melinc;
0192 end
0193 %
0194 %  remove any incorrect entries in pf due to rounding errors
0195 %
0196 if pf(1)<0
0197     pf(1)=[];
0198     b1=b1+1;
0199 end
0200 if pf(end)>=p+1
0201     pf(end)=[];
0202     b4=b4-1;
0203 end
0204 fp=floor(pf);                  % FFT bin_0 i contributes to filters_1 fp(1+i-b1)+[0 1]
0205 pm=pf-fp;                       % multiplier for upper filter
0206 k2=find(fp>0,1);   % FFT bin_1 k2+b1 is the first to contribute to both upper and lower filters
0207 k3=find(fp<p,1,'last');  % FFT bin_1 k3+b1 is the last to contribute to both upper and lower filters
0208 k4=numel(fp); % FFT bin_1 k4+b1 is the last to contribute to any filters
0209 if isempty(k2)
0210     k2=k4+1;
0211 end
0212 if isempty(k3)
0213     k3=0;
0214 end
0215 if any(w=='y')          % preserve power in FFT
0216     mn=1; % lowest fft bin required (1 = DC)
0217     mx=fn2+1; % highest fft bin required (1 = DC)
0218     r=[ones(1,k2+b1-1) 1+fp(k2:k3) fp(k2:k3) repmat(p,1,fn2-k3-b1+1)]; % filter number_1
0219     c=[1:k2+b1-1 k2+b1:k3+b1 k2+b1:k3+b1 k3+b1+1:fn2+1]; % FFT bin1
0220     v=[ones(1,k2+b1-1) pm(k2:k3) 1-pm(k2:k3) ones(1,fn2-k3-b1+1)];
0221 else
0222     r=[1+fp(1:k3) fp(k2:k4)]; % filter number_1
0223     c=[1:k3 k2:k4]; % FFT bin_1 - b1
0224     v=[pm(1:k3) 1-pm(k2:k4)];
0225     mn=b1+1; % lowest fft bin_1
0226     mx=b4+1;  % highest fft bin_1
0227 end
0228 if b1<0
0229     c=abs(c+b1-1)-b1+1;     % convert negative frequencies into positive
0230 end
0231 % end
0232 if any(w=='n')
0233     v=0.5-0.5*cos(v*pi);      % convert triangles to Hanning
0234 elseif any(w=='m')
0235     v=0.5-0.46/1.08*cos(v*pi);  % convert triangles to Hamming
0236 end
0237 if sfact==2  % double all except the DC and Nyquist (if any) terms
0238     msk=(c+mn>2) & (c+mn<n-fn2+2);  % there is no Nyquist term if n is odd
0239     v(msk)=2*v(msk);
0240 end
0241 %
0242 % sort out the output argument options
0243 %
0244 if nargout > 2
0245     x=sparse(r,c,v);
0246     if nargout == 3     % if exactly three output arguments, then
0247         mc=mn;          % delete mc output for legacy code compatibility
0248         mn=mx;
0249     end
0250 else
0251     x=sparse(r,c+mn-1,v,p,1+fn2);
0252 end
0253 if any(w=='u')
0254     sx=sum(x,2);
0255     x=x./repmat(sx+(sx==0),1,size(x,2));
0256 end
0257 %
0258 % plot results if no output arguments or g option given
0259 %
0260 if ~nargout || any(w=='g') % plot idealized filters
0261     ng=201;     % 201 points
0262     me=mflh(1)+(0:p+1)'*melinc;
0263     switch wr
0264                 case 'f'
0265             fe=me; % defining frequencies
0266             xg=repmat(linspace(0,1,ng),p,1).*repmat(me(3:end)-me(1:end-2),1,ng)+repmat(me(1:end-2),1,ng);
0267         case 'l'
0268             fe=10.^me; % defining frequencies
0269             xg=10.^(repmat(linspace(0,1,ng),p,1).*repmat(me(3:end)-me(1:end-2),1,ng)+repmat(me(1:end-2),1,ng));
0270         case 'e'
0271             fe=erb2frq(me); % defining frequencies
0272             xg=erb2frq(repmat(linspace(0,1,ng),p,1).*repmat(me(3:end)-me(1:end-2),1,ng)+repmat(me(1:end-2),1,ng));
0273         case 'b'
0274             fe=bark2frq(me); % defining frequencies
0275             xg=bark2frq(repmat(linspace(0,1,ng),p,1).*repmat(me(3:end)-me(1:end-2),1,ng)+repmat(me(1:end-2),1,ng));
0276         otherwise
0277             fe=mel2frq(me); % defining frequencies
0278             xg=mel2frq(repmat(linspace(0,1,ng),p,1).*repmat(me(3:end)-me(1:end-2),1,ng)+repmat(me(1:end-2),1,ng));
0279     end
0280 
0281     v=1-abs(linspace(-1,1,ng));
0282     if any(w=='n')
0283         v=0.5-0.5*cos(v*pi);      % convert triangles to Hanning
0284     elseif any(w=='m')
0285         v=0.5-0.46/1.08*cos(v*pi);  % convert triangles to Hamming
0286     end
0287     v=v*sfact;  % multiply by 2 if double sided
0288     v=repmat(v,p,1);
0289     if any(w=='y')  % extend first and last filters
0290         v(1,xg(1,:)<fe(2))=sfact;
0291         v(end,xg(end,:)>fe(p+1))=sfact;
0292     end
0293     if any(w=='u') % scale to unity sum
0294         dx=(xg(:,3:end)-xg(:,1:end-2))/2;
0295         dx=dx(:,[1 1:ng-2 ng-2]);
0296         vs=sum(v.*dx,2);
0297         v=v./repmat(vs+(vs==0),1,ng)*fs/n;
0298     end
0299     plot(xg',v','b');
0300     set(gca,'xlim',[fe(1) fe(end)]);
0301     xlabel(['Frequency (' xticksi 'Hz)']);
0302 end