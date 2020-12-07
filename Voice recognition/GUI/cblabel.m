0001 function c=cblabel(l,h)
0002 % h is the handle of the colorbar, axis or figure
0003 %CBLABEL add a label to a colorbar c=(l,h)
0004 %
0005 % Inputs:
0006 %
0007 %     L        Label string for colorbar
0008 %     H        Handle of the colorbar, axis or figure [default = current figure]
0009 %
0010 % Outputs:
0011 %
0012 %     C        Handle of the colorbar
0013 
0014 %      Copyright (C) Mike Brookes 2000-2009
0015 %      Version: $Id: cblabel.m 713 2011-10-16 14:45:43Z dmb $
0016 %
0017 %   VOICEBOX is a MATLAB toolbox for speech processing.
0018 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0019 %
0020 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0021 %   This program is free software; you can redistribute it and/or modify
0022 %   it under the terms of the GNU General Public License as published by
0023 %   the Free Software Foundation; either version 2 of the License, or
0024 %   (at your option) any later version.
0025 %
0026 %   This program is distributed in the hope that it will be useful,
0027 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0028 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0029 %   GNU General Public License for more details.
0030 %
0031 %   You can obtain a copy of the GNU General Public License from
0032 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0033 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0034 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0035 
0036 if nargin<2
0037     h=gcf;
0038 end
0039 switch get(h,'Type')
0040     case 'axes'
0041         if get(h,'Tag')=='Colorbar'
0042             c=h;
0043         else
0044             while get(h,'Type')~='figure'
0045                 h=get(h,'Parent');      % find parent figure
0046                 if h==0
0047                     error('cannot find parent figure');
0048                 end
0049             end
0050             c=findobj(h,'tag','Colorbar');
0051             if isempty(c)
0052                 error('There is no colour bar on this figure')
0053             end
0054             % we could look for the nearest colorbar to the selected axes
0055             c=c(1);      % for now use the most recently added colorbar
0056         end
0057     case 'figure'
0058         c=findobj(h,'tag','Colorbar');
0059         if isempty(c)
0060             error('There is no colour bar on this figure')
0061         end
0062         c=c(1);      % use the most recently added colorbar
0063     otherwise
0064         error('h argument must be colorbar, axis or figure handle');
0065 end
0066 set(get(c,'ylabel'),'string',l);