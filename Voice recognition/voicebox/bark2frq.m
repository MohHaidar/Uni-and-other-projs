 function [f,c] = bark2frq(b,m)
0002 %BARK2FRQ  Convert the BARK frequency scale to Hertz FRQ=(BARK)
0003 %
0004 % Inputs: b  matrix of frequencies in Bark
0005 %         m  mode options
0006 %            'h'   use high frequency correction from [1]
0007 %            'l'   use low frequency correction from [1]
0008 %            'H'   do not apply any high frequency correction
0009 %            'L'   do not apply any low frequency correction
0010 %            'u'   unipolar version: do not force b to be an odd function
0011 %                  This has no effect on the default function which is odd anyway
0012 %            's'   use the expression from Schroeder et al. (1979)
0013 %            'g'   plot a graph
0014 %
0015 % Outputs: f  frequency values in Hz
0016 %          c  Critical bandwidth: d(freq)/d(bark)
0017 
0018 %   The Bark scale was defined by an ISO committee and published in [2]. It
0019 %   was based on a varienty of experiments on the thresholds for complex
0020 %   sounds, masking, perception of phase and the loudness of complex
0021 %   sounds. The Bark scale is named in honour of Barkhausen, the creator
0022 %   of the unit of loudness level [2]. Critical band k extends
0023 %   from bark2frq(k-1) to bark2frq(k). The inverse function is frq2bark.
0024 %
0025 %   There are many published formulae approximating the Bark scale.
0026 %   The default is the one from [1] but with a correction at high and
0027 %   low frequencies to give a better fit to [2] with a continuous derivative
0028 %   and ensure that 0 Hz = 0 Bark.
0029 %   The h and l mode options apply the corrections from [1] which are
0030 %   not as good and do not give a continuous derivative. The H and L
0031 %   mode options suppress the correction entirely to give a simple formula.
0032 %   The 's' option uses the less accurate formulae from [3] which have been
0033 %   widely used in the lterature.
0034 %
0035 %   [1] H. Traunmuller, Analytical Expressions for the
0036 %       Tonotopic Sensory Scale”, J. Acoust. Soc. Am. 88,
0037 %       1990, pp. 97-100.
0038 %   [2] E. Zwicker, Subdivision of the audible frequency range into
0039 %       critical bands, J Accoust Soc Am 33, 1961, p248.
0040 %   [3] M. R. Schroeder, B. S. Atal, and J. L. Hall. Optimizing digital
0041 %       speech coders by exploiting masking properties of the human ear.
0042 %       J. Acoust Soc Amer, 66 (6): 1647–1652, 1979. doi: 10.1121/1.383662.
0043 
0044 %      Copyright (C) Mike Brookes 2006-2010
0045 %      Version: $Id: bark2frq.m 4501 2014-04-24 06:28:21Z dmb $
0046 %
0047 %   VOICEBOX is a MATLAB toolbox for speech processing.
0048 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0049 %
0050 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0051 %   This program is free software; you can redistribute it and/or modify
0052 %   it under the terms of the GNU General Public License as published by
0053 %   the Free Software Foundation; either version 2 of the License, or
0054 %   (at your option) any later version.
0055 %
0056 %   This program is distributed in the hope that it will be useful,
0057 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0058 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0059 %   GNU General Public License for more details.
0060 %
0061 %   You can obtain a copy of the GNU General Public License from
0062 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0063 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0064 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 persistent A B C E D P Q R S T U V W X Y Z
 if isempty(P)
     A=26.81;
     B=1960;
     C=-0.53;
     E = A+C;
     D=A*B;
     P=(0.53/(3.53)^2);
     V=3-0.5/P;
     W=V^2-9;
     Q=0.25;
     R=20.4;
     xy=2;
     S=0.5*Q/xy;
     T=R+0.5*xy;
     U=T-xy;
     X = T*(1+Q)-Q*R;
     Y = U-0.5/S;
     Z=Y^2-U^2;
 end
 if nargin<2
     m=' ';
 end
 if any(m=='u')
     a=b;
 else
     a=abs(b);
 end
 if any(m=='s')
     f=650*sinh(a/7);
 else
     if any(m=='l')
         m1=(a<2);
         a(m1)=(a(m1)-0.3)/0.85;
     elseif ~any(m=='L')
         m1=(a<3);
         a(m1)=V+sqrt(W+a(m1)/P);
     end
     if any(m=='h')
         m1=(a>20.1);
         a(m1)=(a(m1)+4.422)/1.22;
     elseif ~any(m=='H')
         m2=(a>X);
         m1=(a>U) & ~m2;
         a(m2)=(a(m2)+Q*R)/(1+Q);
         a(m1)=Y+sqrt(Z+a(m1)/S);
     end
     f=(D*(E-a).^(-1)-B);
 end
 if ~any(m=='u')
     f=f.*sign(b);          % force to be odd
 end
 if nargout>1
     [bx,c] = frq2bark(f,m);
 end
 if ~nargout || any(m=='g')
     [bx,c] = frq2bark(f,m);
     subplot(212)
     semilogy(b,c,'-r');
     ha=gca;
     xlabel('Bark');
     ylabel(['Critical BW (' yticksi 'Hz)']);
     subplot(211)
     plot(b,f,'x-b');
     hb=gca;
     xlabel('Bark');
     ylabel(['Frequency (' yticksi 'Hz)']);
     linkaxes([ha hb],'x');
 end