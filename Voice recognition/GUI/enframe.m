function [f,t,w]=enframe(x,win,inc,m)
0002 %ENFRAME split signal up into (overlapping) frames: one per row. [F,T]=(X,WIN,INC)
0003 %
0004 % Usage:  (1) f=enframe(x,n)     % split into frames of length n
0005 %         (2) f=enframe(x,hamming(n,'periodic'),n/4)     % use a 75% overlapped Hamming window of length n
0006 %         (3) calculate spectrogram in units of power per Hz
0007 %
0008 %               W=hamming(NW);                      % analysis window (NW = fft length)
0009 %               W=W/sqrt(FS*sum(W.^2));             % normalize to give power per Hz (FS = sample freq)
0010 %               P=rfft(enframe(S,W,INC);,nfft,2);   % computer first half of fft (INC = frame increment in samples)
0011 %               P(:,2:end-1)=2*P(:,2:end-1);        % double to account for -ve frequencies (except DC and Nyquist)
0012 %
0013 %         (3) frequency domain frame-based processing:
0014 %
0015 %               S=...;                              % input signal
0016 %               OV=2;                               % overlap factor of 2 (4 is also often used)
0017 %               INC=20;                             % set frame increment in samples
0018 %               NW=INC*OV;                          % DFT window length
0019 %               W=sqrt(hamming(NW,'periodic'));     % omit sqrt if OV=4
0020 %               W=W/sqrt(sum(W(1:INC:NW).^2));      % normalize window
0021 %               F=rfft(enframe(S,W,INC),NW,2);      % do STFT: one row per time frame, +ve frequencies only
0022 %               ... process frames ...
0023 %               X=overlapadd(irfft(F,NW,2),W,INC);  % reconstitute the time waveform (omit "X=" to plot waveform)
0024 %
0025 %  Inputs:   x    input signal
0026 %          win    window or window length in samples
0027 %          inc    frame increment in samples
0028 %            m    mode input:
0029 %                  'z'  zero pad to fill up final frame
0030 %                  'r'  reflect last few samples for final frame
0031 %                  'A'  calculate the t output as the centre of mass
0032 %                  'E'  calculate the t output as the centre of energy
0033 %
0034 % Outputs:   f    enframed data - one frame per row
0035 %            t    fractional time in samples at the centre of each frame
0036 %                 with the first sample being 1.
0037 %            w    window function used
0038 %
0039 % By default, the number of frames will be rounded down to the nearest
0040 % integer and the last few samples of x() will be ignored unless its length
0041 % is lw more than a multiple of inc. If the 'z' or 'r' options are given,
0042 % the number of frame will instead be rounded up and no samples will be ignored.
0043 %
0044 % Example of frame-based processing:
0045 %          INC=20                               % set frame increment in samples
0046 %          NW=INC*2                             % oversample by a factor of 2 (4 is also often used)
0047 %          S=cos((0:NW*7)*6*pi/NW);                % example input signal
0048 %          W=sqrt(hamming(NW),'periodic'));      % sqrt hamming window of period NW
0049 %          F=enframe(S,W,INC);                   % split into frames
0050 %          ... process frames ...
0051 %          X=overlapadd(F,W,INC);               % reconstitute the time waveform (omit "X=" to plot waveform)
0052 
0053 % Bugs/Suggestions:
0054 %  (1) Possible additional mode options:
0055 %        'u'  modify window for first and last few frames to ensure WOLA
0056 %        'a'  normalize window to give a mean of unity after overlaps
0057 %        'e'  normalize window to give an energy of unity after overlaps
0058 %        'wm' use Hamming window
0059 %        'wn' use Hanning window
0060 %        'x'  include all frames that include any of the x samples
0061 
0062 %       Copyright (C) Mike Brookes 1997-2014
0063 %      Version: $Id: enframe.m 6490 2015-08-05 12:47:13Z dmb $
0064 %
0065 %   VOICEBOX is a MATLAB toolbox for speech processing.
0066 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0067 %
0068 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0069 %   This program is free software; you can redistribute it and/or modify
0070 %   it under the terms of the GNU General Public License as published by
0071 %   the Free Software Foundation; either version 2 of the License, or
0072 %   (at your option) any later version.
0073 %
0074 %   This program is distributed in the hope that it will be useful,
0075 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0076 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0077 %   GNU General Public License for more details.
0078 %
0079 %   You can obtain a copy of the GNU General Public License from
0080 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0081 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0082 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0083 
0084 nx=length(x(:));
0085 if nargin<2 || isempty(win)
0086     win=nx;
0087 end
0088 if nargin<4 || isempty(m)
0089     m='';
0090 end
0091 nwin=length(win);
0092 if nwin == 1
0093     lw = win;
0094     w = ones(1,lw);
0095 else
0096     lw = nwin;
0097     w = win(:).';
0098 end
0099 if (nargin < 3) || isempty(inc)
0100     inc = lw;
0101 end
0102 nli=nx-lw+inc;
0103 nf = max(fix(nli/inc),0);   % number of full frames
0104 na=nli-inc*nf+(nf==0)*(lw-inc);       % number of samples left over
0105 fx=nargin>3 && (any(m=='z') || any(m=='r')) && na>0; % need an extra row
0106 f=zeros(nf+fx,lw);
0107 indf= inc*(0:(nf-1)).';
0108 inds = (1:lw);
0109 if fx
0110     f(1:nf,:) = x(indf(:,ones(1,lw))+inds(ones(nf,1),:));
0111     if any(m=='r')
0112         ix=1+mod(nf*inc:nf*inc+lw-1,2*nx);
0113         f(nf+1,:)=x(ix+(ix>nx).*(2*nx+1-2*ix));
0114     else
0115         f(nf+1,1:nx-nf*inc)=x(1+nf*inc:nx);
0116     end
0117     nf=size(f,1);
0118 else
0119     f(:) = x(indf(:,ones(1,lw))+inds(ones(nf,1),:));
0120 end
0121 if (nwin > 1)   % if we have a non-unity window
0122     f = f .* w(ones(nf,1),:);
0123 end
0124 if nargout>1
0125     if any(m=='E')
0126         t0=sum((1:lw).*w.^2)/sum(w.^2);
0127     elseif any(m=='A')
0128         t0=sum((1:lw).*w)/sum(w);
0129     else
0130         t0=(1+lw)/2;
0131     end
0132     t=t0+inc*(0:(nf-1)).';
0133 end
0134 
0135