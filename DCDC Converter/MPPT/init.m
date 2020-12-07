global P1
global P2
global P3
global P4
global P5
global x
global power

fileID = fopen('Graph 2.txt','r');
[P1,~] = fscanf(fileID,['%f' ',' '%f'],sizeA);
fclose(fileID);
I1=interp1(P1(1,:),P1(2,:),z);
P1=[z;I1];

fileID = fopen('Graph 2-2.txt','r');
[P2,~] = fscanf(fileID,['%f' ',' '%f'],sizeA);
fclose(fileID);
I2=interp1(P2(1,:),P2(2,:),z);
P2=[z;I2];

fileID = fopen('Graph 2-3.txt','r');
[P3,~] = fscanf(fileID,['%f' ',' '%f'],sizeA);
fclose(fileID);
I3=interp1(P3(1,:),P3(2,:),z);
P3=[z;I3];

fileID = fopen('Graph 2-4.txt','r');
[P4,~] = fscanf(fileID,['%f' ',' '%f'],sizeA);
fclose(fileID);
I4=interp1(P4(1,:),P4(2,:),z);
P4=[z;I4];

fileID = fopen('Graph 2-5.txt','r');
[P5,~] = fscanf(fileID,['%f' ',' '%f'],sizeA);
fclose(fileID);
I5=interp1(P5(1,:),P5(2,:),z);
P5=[z;I5];