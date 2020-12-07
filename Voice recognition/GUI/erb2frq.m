function [frq,bnd] = erb2frq(erb)
0002 %ERB2FRQ  Convert ERB frequency scale to Hertz FRQ=(ERB)
0003 %    frq = erb2frq(erb) converts a vector of ERB-rate values
0004 %    to the corresponding frequencies in Hz.
0005 %   [frq,bnd] =  erb2frq(erb) also calculates the ERB bandwidths
0006 %
0007 %    Note that erb values will be clipped to 43.032 which corresponds to infinite frequency.
0008 %    The inverse function is frq2erb.
0009 
0010 %   The erb scale is measured using the notched-noise method [3].
0011 %
0012 %    We have df/de = 6.23*f^2 + 93.39*f + 28.52
0013 %    where the above expression gives the Equivalent Rectangular
0014 %    Bandwidth (ERB)in Hz  of a human auditory filter with a centre
0015 %    frequency of f kHz.
0016 %
0017 %    By integrating the reciprocal of the above expression, we
0018 %    get:
0019 %        e = k ln((f/p-1)/(f/q-1))/d
0020 %
0021 %    where p and q are the roots of the equation: -0.312 and -14.7
0022 %      and d = (6.23*(p-q))/1000 = 0.08950404
0023 %
0024 %    from this we can derive:
0025 %
0026 %    f = k/(h-exp(d*e)) + c
0027 %
0028 %    where k = 1000 q (1 - q/p) = 676170.4
0029 %          h = q/p = 47.06538
0030 %          c = 1000q = -14678.49
0031 %    and f is in Hz
0032 %
0033 % Note that the maximum permissible value of e is log(b)/c=43.032 since this gives f=inf
0034 %
0035 %    References:
0036 %
0037 %      [1] B.C.J.Moore & B.R.Glasberg "Suggested formula for
0038 %          calculating auditory-filter bandwidth and excitation
0039 %          patterns", J Acoust Soc America V74, pp 750-753, 1983
0040 %      [2] O. Ghitza, "Auditory Models & Human Performance in Tasks
0041 %          related to Speech Coding & Speech Recognition",
0042 %          IEEE Trans on Speech & Audio Processing, Vol 2,
0043 %          pp 115-132, Jan 1994
0044 %     [3] R. D. Patterson. Auditory filter shapes derived with noise
0045 %         stimuli. J. Acoust. Soc. Amer., 59: 640–654, 1976.
0046 %
0047 
0048 %      Copyright (C) Mike Brookes 1998
0049 %      Version: $Id: erb2frq.m 5749 2015-03-01 16:01:14Z dmb $
0050 %
0051 %   VOICEBOX is a MATLAB toolbox for speech processing.
0052 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0053 %
0054 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0055 %   This program is free software; you can redistribute it and/or modify
0056 %   it under the terms of the GNU General Public License as published by
0057 %   the Free Software Foundation; either version 2 of the License, or
0058 %   (at your option) any later version.
0059 %
0060 %   This program is distributed in the hope that it will be useful,
0061 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0062 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0063 %   GNU General Public License for more details.
0064 %
0065 %   You can obtain a copy of the GNU General Public License from
0066 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0067 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0068 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0069 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0070 persistent u h k c d
0071 if ~numel(u)
0072     u=[6.23e-6 93.39e-3 28.52];
0073     p=sort(roots(u));           % p=[-14678.5 -311.9]
0074     d=1e-6*(6.23*(p(2)-p(1)));  % d=0.0895
0075     c=p(1);                     % c=-14678.5
0076     k = p(1) - p(1)^2/p(2);     % k=676170.4
0077     h=p(1)/p(2);                % h=47.06538
0078 end
0079 frq = sign(erb).*(k./max(h-exp(d*abs(erb)),0)+c);
0080 bnd=polyval(u,abs(frq));
0081 if ~nargout
0082     plot(erb,frq,'-x');
0083     xlabel(['Frequency (' xticksi 'Erb-rate)']);
0084     ylabel(['Frequency (' yticksi 'Hz)']);
0085 end