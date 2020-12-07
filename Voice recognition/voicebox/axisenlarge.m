0001 function axisenlarge(f,h)
0002 %AXISENLARGE - enlarge the axes of a figure (f,h)
0003 %
0004 % Usage:  (1) axisenlarge(1.05)    % enlarge axes by 5% in each direction
0005 %         (2) axisenlarge(-1.05)   % shrink to fit content before enlarging
0006 %
0007 % Inputs:
0008 %    f      enlarge axis by a factor f relative to current size or
0009 %           by -f relative to the graph content. For separate factors
0010 %           in each direction use [fx fy] or [fleft fright fbottom ftop]
0011 %    h      axis handle [default = gca]
0012 
0013 %       Copyright (C) Mike Brookes 2012
0014 %      Version: $Id: axisenlarge.m 2454 2012-10-26 10:36:10Z dmb $
0015 %
0016 %   VOICEBOX is a MATLAB toolbox for speech processing.
0017 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0018 %
0019 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0020 %   This program is free software; you can redistribute it and/or modify
0021 %   it under the terms of the GNU General Public License as published by
0022 %   the Free Software Foundation; either version 2 of the License, or
0023 %   (at your option) any later version.
0024 %
0025 %   This program is distributed in the hope that it will be useful,
0026 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0027 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0028 %   GNU General Public License for more details.
0029 %
0030 %   You can obtain a copy of the GNU General Public License from
0031 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0032 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0033 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0034 fix=[1 1 1 1; 1 1 2 2; 1 2 3 3; 1 2 3 4];
0035 if nargin<2 || ~numel(h)
0036     h=gca;
0037 end
0038 if nargin<1 || ~numel(f)
0039     f=-1.02;
0040 end
0041 nf=min(numel(f),4);
0042 f=f(fix(nf,:));  % expand f to dimension 4
0043 if any(f>=0)
0044     ax0=[get(h,'XLim') get(h,'YLim')];
0045 else
0046     ax0=zeros(1,4);
0047 end
0048 if any(f<0)
0049     axis(h,'tight');
0050     ax1=[get(h,'XLim') get(h,'YLim')];
0051     ax0(f<0)=ax1(f<0);
0052     f=abs(f);
0053 end
0054 ax1=ax0.*f+ax0([2 1 4 3]).*(1-f);
0055 set(h,'XLim',ax1(1:2),'YLim',ax1(3:4));