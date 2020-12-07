function s=xticksi(ah)
0002 %XTIXKSI labels the x-axis of a plot using SI multipliers S=(AH)
0003 %
0004 %  Inputs:  AH       axis handle [default: current axes]
0005 %
0006 % Outputs:  S        optional global SI multiplier (see usage below)
0007 %
0008 % Usage:   (1) plot(...);
0009 %              xticksi;
0010 %
0011 %          (2) plot(...);
0012 %              xlabel(['Frequency (' xticksi 'Hz)']);
0013 %
0014 % The first form will label the tick marks on the x-axis of the current plot
0015 % using SI multipliers where appropriate. This is particularly useful for log
0016 % plots which MATLAB does not label very well.
0017 % The second form will, if possible, use a single SI multiplier for all the tick
0018 % marks; this global multiplier can be incorporated into the axis label as shown.
0019 
0020 %       Copyright (C) Mike Brookes 2009
0021 %      Version: $Id: xticksi.m 713 2011-10-16 14:45:43Z dmb $
0022 %
0023 %   VOICEBOX is a MATLAB toolbox for speech processing.
0024 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0025 %
0026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0027 %   This program is free software; you can redistribute it and/or modify
0028 %   it under the terms of the GNU General Public License as published by
0029 %   the Free Software Foundation; either version 2 of the License, or
0030 %   (at your option) any later version.
0031 %
0032 %   This program is distributed in the hope that it will be useful,
0033 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0034 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0035 %   GNU General Public License for more details.
0036 %
0037 %   You can obtain a copy of the GNU General Public License from
0038 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0039 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0040 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0041 if ~nargin
0042     ah=gca;
0043 end
0044 if nargout
0045 s=xyzticksi(1,ah);
0046 else
0047     xyzticksi(1,ah);
0048 end