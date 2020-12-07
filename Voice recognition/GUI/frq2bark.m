function [b,c] = frq2bark(f,m)
0002 %FRQ2BARK  Convert Hertz to BARK frequency scale BARK=(FRQ)
0003 %       bark = frq2bark(frq) converts a vector of frequencies (in Hz)
0004 %       to the corresponding values on the BARK scale.
0005 % Inputs: f  matrix of frequencies in Hz
0006 %         m  mode options
0007 %            'h'   use high frequency correction from [1]
0008 %            'l'   use low frequency correction from [1]
0009 %            'H'   do not apply any high frequency correction
0010 %            'L'   do not apply any low frequency correction
0011 %            'z'   use the expressions from Zwicker et al. (1980) for b and c
0012 %            's'   use the expression from Schroeder et al. (1979)
0013 %            'u'   unipolar version: do not force b to be an odd function
0014 %                  This has no effect on the default function which is odd anyway
0015 %            'g'   plot a graph
0016 %
0017 % Outputs: b  bark values
0018 %          c  Critical bandwidth: d(freq)/d(bark)
0019 
0020 %   The Bark scale was defined by in ISO532 and published in [2]. It
0021 %   was based on a varienty of experiments on the thresholds for complex
0022 %   sounds, masking, perception of phase and the loudness of complex
0023 %   sounds. The Bark scale is named in honour of Barkhausen, the creator
0024 %   of the unit of loudness level [2]. Frequency f lies in critical
0025 %   band ceil(frq2bark(f)). The inverse function is bark2frq.
0026 %
0027 %   There are many published formulae approximating the Bark scale.
0028 %   The default is the one from [1] but with a correction at high and
0029 %   low frequencies to give a better fit to [2] with a continuous derivative
0030 %   and ensure that 0 Hz = 0 Bark.
0031 %   The h and l mode options apply the corrections from [1] which are
0032 %   not as good and do not give a continuous derivative. The H and L
0033 %   mode options suppress the correction entirely to give a simple formula.
0034 %   The 's' option uses the less accurate formulae from [3] which have been
0035 %   widely used in the lterature.
0036 %   The 'z' option uses the formulae from [4] in which the c output
0037 %   is not exactly the reciprocal of the derivative of the bark function.
0038 %
0039 %   [1] H. Traunmuller, Analytical Expressions for the
0040 %       Tonotopic Sensory Scale”, J. Acoust. Soc. Am. 88,
0041 %       1990, pp. 97-100.
0042 %   [2] E. Zwicker, Subdivision of the audible frequency range into
0043 %       critical bands, J Accoust Soc Am 33, 1961, p248.
0044 %   [3] M. R. Schroeder, B. S. Atal, and J. L. Hall. Optimizing digital
0045 %       speech coders by exploiting masking properties of the human ear.
0046 %       J. Acoust Soc Amer, 66 (6): 1647–1652, 1979. doi: 10.1121/1.383662.
0047 %   [4] E. Zwicker and E. Terhardt.  Analytical expressions for
0048 %       critical-band rate and critical bandwidth as a function of frequency.
0049 %       J. Acoust Soc Amer, 68 (5): 1523–1525, Nov. 1980.
0050 
0051 %   The following code reproduces the graphs 3(c) and 3(d) from [1].
0052 %       b0=(0:0.5:24)';
0053 %       f0=[[2 5 10 15 20 25 30 35 40 45 51 57 63 70 77 ...
0054 %           84 92 100 108 117 127 137 148 160 172 185 200 ...
0055 %           215 232 250 270 290 315]*10 [34 37 40 44 48 53 ...
0056 %           58 64 70 77 85 95 105 120 135 155]*100]';
0057 %       b1=frq2bark(f0);      b2=frq2bark(f0,'lh');
0058 %       b3=frq2bark(f0,'LH'); b4=frq2bark(f0,'z');
0059 %       plot(b0,[b0 b1 b2 b3 b4]-repmat(b0,1,5));
0060 %       xlabel('Frequency (Bark)'); ylabel('Error (Bark)');
0061 %       legend('Exact','voicebox','Traunmuller1990', ...
0062 %              'Traunmuller1983','Zwicker1980','Location','South');
0063 
0064 %      Copyright (C) Mike Brookes 2006-2010
0065 %      Version: $Id: frq2bark.m 4501 2014-04-24 06:28:21Z dmb $
0066 %
0067 %   VOICEBOX is a MATLAB toolbox for speech processing.
0068 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0069 %
0070 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0071 %   This program is free software; you can redistribute it and/or modify
0072 %   it under the terms of the GNU General Public License as published by
0073 %   the Free Software Foundation; either version 2 of the License, or
0074 %   (at your option) any later version.
0075 %
0076 %   This program is distributed in the hope that it will be useful,
0077 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0078 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0079 %   GNU General Public License for more details.
0080 %
0081 %   You can obtain a copy of the GNU General Public License from
0082 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0083 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0084 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0085 persistent A B C D P Q R S T U
0086 if isempty(P)
0087     A=26.81;
0088     B=1960;
0089     C=-0.53;
0090     D=A*B;
0091     P=(0.53/(3.53)^2);
0092     Q=0.25;
0093     R=20.4;
0094     xy=2;
0095     S=0.5*Q/xy;
0096     T=R+0.5*xy;
0097     U=T-xy;
0098 end
0099 if nargin<2
0100     m=' ';
0101 end
0102 if any(m=='u')
0103     g=f;
0104 else
0105     g=abs(f);
0106 end
0107 if any(m=='z')
0108     b=13*atan(0.00076*g)+3.5*atan((f/7500).^2);
0109     c=25+75*(1+1.4e-6*f.^2).^0.69;
0110 elseif any(m=='s')
0111     b=7*log(g/650+sqrt(1+(g/650).^2));
0112     c=cosh(b/7)*650/7;
0113 else
0114     b=A*g./(B+g)+C;
0115     d=D*(B+g).^(-2);
0116     if any(m=='l')
0117         m1=(b<2);
0118         d(m1)=d(m1)*0.85;
0119         b(m1)=0.3+0.85*b(m1);
0120     elseif ~any(m=='L')
0121         m1=(b<3);
0122         b(m1)=b(m1)+P*(3-b(m1)).^2;
0123         d(m1)=d(m1).*(1-2*P*(3-b(m1)));
0124     end
0125     if any(m=='h')
0126         m1=(b>20.1);
0127         d(m1)=d(m1)*1.22;
0128         b(m1)=1.22*b(m1)-4.422;
0129     elseif ~any(m=='H')
0130         m2=(b>T);
0131         m1=(b>U) & ~m2;
0132         b(m1)=b(m1)+S*(b(m1)-U).^2;
0133         b(m2)=(1+Q)*b(m2)-Q*R;
0134         d(m2)=d(m2).*(1+Q);
0135         d(m1)=d(m1).*(1+2*S*(b(m1)-U));
0136     end
0137     c=d.^(-1);
0138 end
0139 if ~any(m=='u')
0140     b=b.*sign(f);          % force to be odd
0141 end
0142 
0143 if ~nargout || any(m=='g')
0144     subplot(212)
0145     semilogy(f,c,'-r');
0146     ha=gca;
0147     ylabel(['Critical BW (' yticksi 'Hz)']);
0148     xlabel(['Frequency (' xticksi 'Hz)']);
0149     subplot(211)
0150     plot(f,b,'x-b');
0151     hb=gca;
0152     ylabel('Bark');
0153     xlabel(['Frequency (' xticksi 'Hz)']);
0154     linkaxes([ha hb],'x');
0155 end