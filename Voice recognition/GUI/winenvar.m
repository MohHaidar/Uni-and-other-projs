 function d=winenvar(n)
0002 %WINENVAR get windows environment variable [D]=(N)
0003 %
0004 % Inputs: N  name of environment variable (e.g. 'temp')
0005 %
0006 % Outputs: D  value of variable or [] is non-existant
0007 %
0008 % Notes: (1) This is WINDOWS specific and needs to be fixed to work on UNIX
0009 %        (2) The search is case insensitive (like most of WINDOWS).
0010 %
0011 % Examples: (1) Open a temporary text file:
0012 %               d=winenar('temp'); fid=fopen(fullfile(d,'temp.txt'),'wt');
0013 
0014 %   Copyright (c) 2005 Mike Brookes,  mike.brookes@ic.ac.uk
0015 %      Version: $Id: winenvar.m 713 2011-10-16 14:45:43Z dmb $
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
 p=['%',n,'%'];
 [s,d]=system(['echo ',p]);
 while d(end)<=' ';
     d(end)=[];
 end
 if strcmp(d,p)
     d=[];
 end