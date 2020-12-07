function m = rnsubset(k,n)
0002 %RNSUBSET choose k distinct random integers from 1:n M=(K,N)
0003 %
0004 %  Inputs:
0005 %
0006 %    K is number of disinct integers required from the range 1:N
0007 %    N specifies the range - we must have K<=N
0008 %
0009 %  Outputs:
0010 %
0011 %    M(1,K) contains the output numbers
0012 
0013 %      Copyright (C) Mike Brookes 2006
0014 %      Version: $Id: rnsubset.m 713 2011-10-16 14:45:43Z dmb $
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
 if k>n
     error('rnsubset: k must be <= n');
 end
 % We use two algorithms according to the values of k and n
 [f,e]=log2(n);
 if k>0.03*n*(e-1)
 [v,m]=sort(rand(1,n)); % for large k, just do a random permutation
 else
     v=ceil(rand(1,k).*(n:-1:n-k+1));
     m=1:n;
     for i=1:k
         j=v(i)+i-1;
         x=m(i);
         m(i)=m(j);
         m(j)=x;
     end
 end
 m=m(1:k);