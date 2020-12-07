function [ptCloud,ptCloud2,colorImage,depthImage] = CreatePCloud(colorDevice,depthDevice,zthreshold,xthreshold,ythreshold);




colorImage = step(colorDevice);
depthImage = step(depthDevice);

ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);
ptCloud = pcmerge(ptCloud, ptCloud, 0.00001);

mat=ptCloud.Location;
col=ptCloud.Color;
bac=find(mat(:,3)>zthreshold);
mat(bac,:)=0;
col(bac,:)=0;

bac=find(mat(:,2)>ythreshold);
mat(bac,:)=0;
col(bac,:)=0;

bac=find(mat(:,2)<-ythreshold);
mat(bac,:)=0;
col(bac,:)=0;

bac=find(mat(:,1)>xthreshold);
mat(bac,:)=0;
col(bac,:)=0;

bac=find(mat(:,1)<-xthreshold);
mat(bac,:)=0;
col(bac,:)=0;
ptCloud = pointCloud(mat,'Color',col);
ptCloud2 = pointCloud(mat);
player = pcplayer(ptCloud.XLimits, ptCloud.YLimits, ptCloud.ZLimits,'VerticalAxis', 'y', 'VerticalAxisDir', 'down')

view(player, ptCloud)