function [c,tc]=melcepst(s,fs,w,nc,p,n,inc,fl,fh)
0002 %MELCEPST Calculate the mel cepstrum of a signal C=(S,FS,W,NC,P,N,INC,FL,FH)
0003 %
0004 %
0005 % Simple use: (1) c=melcepst(s,fs)          % calculate mel cepstrum with 12 coefs, 256 sample frames
0006 %              (2) c=melcepst(s,fs,'E0dD')   % include log energy, 0th cepstral coef, delta and delta-delta coefs
0007 %
0008 % Inputs:
0009 %     s      speech signal
0010 %     fs  sample rate in Hz (default 11025)
0011 %     w   mode string (see below)
0012 %     nc  number of cepstral coefficients excluding 0'th coefficient [default 12]
0013 %     p   number of filters in filterbank [default: floor(3*log(fs)) =  approx 2.1 per ocatave]
0014 %     n   length of frame in samples [default power of 2 < (0.03*fs)]
0015 %     inc frame increment [default n/2]
0016 %     fl  low end of the lowest filter as a fraction of fs [default = 0]
0017 %     fh  high end of highest filter as a fraction of fs [default = 0.5]
0018 %
0019 %        w   any sensible combination of the following:
0020 %
0021 %               'R'  rectangular window in time domain
0022 %                'N'     Hanning window in time domain
0023 %                'M'     Hamming window in time domain (default)
0024 %
0025 %               't'  triangular shaped filters in mel domain (default)
0026 %               'n'  hanning shaped filters in mel domain
0027 %               'm'  hamming shaped filters in mel domain
0028 %
0029 %                'p'     filters act in the power domain
0030 %                'a'     filters act in the absolute magnitude domain (default)
0031 %
0032 %               '0'  include 0'th order cepstral coefficient
0033 %                'E'  include log energy
0034 %                'd'     include delta coefficients (dc/dt)
0035 %                'D'     include delta-delta coefficients (d^2c/dt^2)
0036 %
0037 %               'z'  highest and lowest filters taper down to zero (default)
0038 %               'y'  lowest filter remains at 1 down to 0 frequency and
0039 %                        highest filter remains at 1 up to nyquist freqency
0040 %
0041 %               If 'ty' or 'ny' is specified, the total power in the fft is preserved.
0042 %
0043 % Outputs:    c     mel cepstrum output: one frame per row. Log energy, if requested, is the
0044 %                 first element of each row followed by the delta and then the delta-delta
0045 %                 coefficients.
0046 %           tc    fractional time in samples at the centre of each frame
0047 %                 with the first sample being 1.
0048 %
0049 
0050 % BUGS: (1) should have power limit as 1e-16 rather than 1e-6 (or possibly a better way of choosing this)
0051 %           and put into VOICEBOX
0052 %       (2) get rdct to change the data length (properly) instead of doing it explicitly (wrongly)
0053 
0054 %      Copyright (C) Mike Brookes 1997
0055 %      Version: $Id: melcepst.m 4914 2014-07-24 08:44:26Z dmb $
0056 %
0057 %   VOICEBOX is a MATLAB toolbox for speech processing.
0058 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0059 %
0060 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0061 %   This program is free software; you can redistribute it and/or modify
0062 %   it under the terms of the GNU General Public License as published by
0063 %   the Free Software Foundation; either version 2 of the License, or
0064 %   (at your option) any later version.
0065 %
0066 %   This program is distributed in the hope that it will be useful,
0067 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0068 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0069 %   GNU General Public License for more details.
0070 %
0071 %   You can obtain a copy of the GNU General Public License from
0072 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0073 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0074 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0075 
0076 if nargin<2 fs=11025; end
0077 if nargin<3 w='M'; end
0078 if nargin<4 nc=12; end
0079 if nargin<5 p=floor(3*log(fs)); end
0080 if nargin<6 n=pow2(floor(log2(0.03*fs))); end
0081 if nargin<9
0082    fh=0.5;   
0083    if nargin<8
0084      fl=0;
0085      if nargin<7
0086         inc=floor(n/2);
0087      end
0088   end
0089 end
0090 
0091 if isempty(w)
0092    w='M';
0093 end
0094 if any(w=='R')
0095    [z,tc]=enframe(s,n,inc);
0096 elseif any (w=='N')
0097    [z,tc]=enframe(s,hanning(n),inc);
0098 else
0099    [z,tc]=enframe(s,hamming(n),inc);
0100 end
0101 f=rfft(z.');
0102 [m,a,b]=melbankm(p,n,fs,fl,fh,w);
0103 pw=f(a:b,:).*conj(f(a:b,:));
0104 pth=max(pw(:))*1E-20;
0105 if any(w=='p')
0106    y=log(max(m*pw,pth));
0107 else
0108    ath=sqrt(pth);
0109    y=log(max(m*abs(f(a:b,:)),ath));
0110 end
0111 c=rdct(y).';
0112 nf=size(c,1);
0113 nc=nc+1;
0114 if p>nc
0115    c(:,nc+1:end)=[];
0116 elseif p<nc
0117    c=[c zeros(nf,nc-p)];
0118 end
0119 if ~any(w=='0')
0120    c(:,1)=[];
0121    nc=nc-1;
0122 end
0123 if any(w=='E')
0124    c=[log(max(sum(pw),pth)).' c];
0125    nc=nc+1;
0126 end
0127 
0128 % calculate derivative
0129 
0130 if any(w=='D')
0131   vf=(4:-1:-4)/60;
0132   af=(1:-1:-1)/2;
0133   ww=ones(5,1);
0134   cx=[c(ww,:); c; c(nf*ww,:)];
0135   vx=reshape(filter(vf,1,cx(:)),nf+10,nc);
0136   vx(1:8,:)=[];
0137   ax=reshape(filter(af,1,vx(:)),nf+2,nc);
0138   ax(1:2,:)=[];
0139   vx([1 nf+2],:)=[];
0140   if any(w=='d')
0141      c=[c vx ax];
0142   else
0143      c=[c ax];
0144   end
0145 elseif any(w=='d')
0146   vf=(4:-1:-4)/60;
0147   ww=ones(4,1);
0148   cx=[c(ww,:); c; c(nf*ww,:)];
0149   vx=reshape(filter(vf,1,cx(:)),nf+8,nc);
0150   vx(1:8,:)=[];
0151   c=[c vx];
0152 end
0153  
0154 if nargout<1
0155    [nf,nc]=size(c);
0156 %    t=((0:nf-1)*inc+(n-1)/2)/fs;
0157    ci=(1:nc)-any(w=='0')-any(w=='E');
0158    imh = imagesc(tc/fs,ci,c.');
0159    axis('xy');
0160    xlabel('Time (s)');
0161    ylabel('Mel-cepstrum coefficient');
0162     map = (0:63)'/63;
0163     colormap([map map map]);
0164     colorbar;
0165 end
0166