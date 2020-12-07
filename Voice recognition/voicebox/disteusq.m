function d=disteusq(x,y,mode,w)
0002 %DISTEUSQ calculate euclidean, squared euclidean or mahanalobis distance D=(X,Y,MODE,W)
0003 %
0004 % Inputs: X,Y         Vector sets to be compared. Each row contains a data vector.
0005 %                     X and Y must have the same number of columns.
0006 %
0007 %         MODE        Character string selecting the following options:
0008 %                         'x'  Calculate the full distance matrix from every row of X to every row of Y
0009 %                         'd'  Calculate only the distance between corresponding rows of X and Y
0010 %                              The default is 'd' if X and Y have the same number of rows otherwise 'x'.
0011 %                         's'  take the square-root of the result to give the euclidean distance.
0012 %
0013 %         W           Optional weighting matrix: the distance calculated is (x-y)*W*(x-y)'
0014 %                     If W is a vector, then the matrix diag(W) is used.
0015 %
0016 % Output: D           If MODE='d' then D is a column vector with the same number of rows as the shorter of X and Y.
0017 %                     If MODE='x' then D is a matrix with the same number of rows as X and the same number of columns as Y'.
0018 %
0019 
0020 %      Copyright (C) Mike Brookes 1998
0021 %      Version: $Id: disteusq.m 713 2011-10-16 14:45:43Z dmb $
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
 
 [nx,p]=size(x); ny=size(y,1);
 if nargin<3 | isempty(mode) mode='0'; end
 if any(mode=='d') | (mode~='x' & nx==ny)
 
     % Do pairwise distance calculation
 
     nx=min(nx,ny);
     z=double(x(1:nx,:))-double(y(1:nx,:));
     if nargin<4
         d=sum(z.*conj(z),2);
     elseif min(size(w))==1
         wv=w(:).';
         d=sum(z.*wv(ones(size(z,1),1),:).*conj(z),2);
     else
         d=sum(z*w.*conj(z),2);
     end
 else
     
     % Calculate full distance matrix
     
     if p>1
         
         % x and y are matrices
         
         if nargin<4
             z=permute(double(x(:,:,ones(1,ny))),[1 3 2])-permute(double(y(:,:,ones(1,nx))),[3 1 2]);
             d=sum(z.*conj(z),3);
         else
             nxy=nx*ny;
             z=reshape(permute(double(x(:,:,ones(1,ny))),[1 3 2])-permute(double(y(:,:,ones(1,nx))),[3 1 2]),nxy,p);
             if min(size(w))==1
                 wv=w(:).';
                 d=reshape(sum(z.*wv(ones(nxy,1),:).*conj(z),2),nx,ny);
             else
                 d=reshape(sum(z*w.*conj(z),2),nx,ny);
             end
         end
     else
         
         % x and y are vectors
         
         z=double(x(:,ones(1,ny)))-double(y(:,ones(1,nx))).';
         if nargin<4
             d=z.*conj(z);
         else
             d=w*z.*conj(z);
         end
     end
 end
 if any(mode=='s')
     d=sqrt(d);
 end
