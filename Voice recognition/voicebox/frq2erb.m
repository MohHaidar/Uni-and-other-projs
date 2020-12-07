function [erb,bnd] = frq2erb(frq)
0002 %FRQ2ERB  Convert Hertz to ERB frequency scale ERB=(FRQ)
0003 %    erb = frq2erb(frq) converts a vector of frequencies (in Hz)
0004 %    to the corresponding values on the ERB-rate scale on which
0005 %      the human ear has roughly constant resolution as judged by
0006 %      psychophysical measurements of the cochlear filters. The
0007 %   inverse function is erb2frq.
0008 
0009 %   The erb scale is measured using the notched-noise method [3].
0010 %
0011 %    We have df/de = 6.23*f^2 + 93.39*f + 28.52
0012 %    where the above expression gives the Equivalent Rectangular
0013 %    Bandwidth (ERB)in Hz  of a human auditory filter with a centre
0014 %    frequency of f kHz.
0015 %
0016 %    By integrating the reciprocal of the above expression, we
0017 %    get:
0018 %        e = a ln((f/p-1)/(f/q-1))
0019 %
0020 %    where p and q are the roots of the equation: -0.312 and -14.7
0021 %      and a = 1000/(6.23*(p-q)) = 11.17268
0022 %
0023 %    We actually implement e as
0024 %
0025 %        e = a ln (h - k/(f+c))
0026 %
0027 %    where k = 1000(q - q^2/p) = 676170.42
0028 %         h = q/p = 47.065
0029 %          c = -1000q = 14678.49
0030 %    and f is in Hz
0031 %
0032 %    References:
0033 %
0034 %      [1] B.C.J.Moore & B.R.Glasberg "Suggested formula for
0035 %          calculating auditory-filter bandwidth and excitation
0036 %          patterns", J Acoust Soc America V74, pp 750-753, 1983
0037 %      [2] O. Ghitza, "Auditory Models & Human Performance in Tasks
0038 %          related to Speech Coding & Speech Recognition",
0039 %          IEEE Trans on Speech & Audio Processing, Vol 2,
0040 %          pp 115-132, Jan 1994
0041 %     [3] R. D. Patterson. Auditory filter shapes derived with noise
0042 %         stimuli. J. Acoust. Soc. Amer., 59: 640–654, 1976.
0043 
0044 %      Copyright (C) Mike Brookes 1998-2015
0045 %      Version: $Id: frq2erb.m 5749 2015-03-01 16:01:14Z dmb $
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
0065 persistent u a h k c
0066 if ~numel(u)
0067     u=[6.23e-6 93.39e-3 28.52];
0068     p=sort(roots(u));               % p=[-14678.5 -311.9]
0069     a=1e6/(6.23*(p(2)-p(1)));       % a=11.17
0070     c=p(1);                         % c=-14678.5
0071     k = p(1) - p(1)^2/p(2);         % k=676170.42
0072     h=p(1)/p(2);                    % h=47.065
0073 end
0074 g=abs(frq);
0075 % erb=11.17268*sign(frq).*log(1+46.06538*g./(g+14678.49));
0076 erb=a*sign(frq).*log(h-k./(g-c));
0077 bnd=polyval(u,g);
0078 if ~nargout
0079     plot(frq,erb,'-x');
0080     xlabel(['Frequency (' xticksi 'Hz)']);
0081     ylabel(['Frequency (' yticksi 'Erb-rate)']);
0082 end