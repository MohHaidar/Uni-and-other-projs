function z=plotGPR(n,t)
%
%<Description>
%
% This function will plot the data in the txt files 
% exported from the simulation in a 2d colored graph
%
%
%<notice>
%
% n is number of samples
% t is the simulation time ( signal duration in CST )
%
% The txt files should be named P1,P2...Pn , in addition to the
% file named 'No target.txt' exported from the simulation without the
% target.
%
% 

%
%<Initializing>
%

% Scale vector , length = 100*t

yq = 0 : 0.01 : t ;

% data for no target 

A0 = importdata('No target.txt');

% interpolation of A0 along the yq vector , we do this to all the
% the following data to normalize and to unify the dimensions

z0 = interp1(A0.data(:,1),A0.data(:,2),yq);

A = importdata('Pos1.txt');

z = interp1(A.data(:,1),A.data(:,2),yq)-z0;

% We did this to initialise the gobal z vector in order to 
% concatinate other vectors (zq) in each iteration

%
%<Loop for all the positions>
%

for i=2:n
    
A = importdata(strcat('Pos',int2str(i),'.txt'));

zq = interp1(A.data(:,1),A.data(:,2),yq);

z = [z;zq-z0];

end;

surf(abs(flipud(z)),'EdgeColor', 'None', 'facecolor', 'interp');
view(2);

%
%
%  Work done by 
%  Student Mohammad Haidar
%  email: mih3_51_m@homail.com
