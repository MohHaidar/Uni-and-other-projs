function ptCloud = UpdatePCloud(ptCloud1,colorDevice,depthDevice,zthreshold,xthreshold,ythreshold)



colorImage = step(colorDevice);
depthImage = step(depthDevice);

ptCloud2 = pcfromkinect(depthDevice, depthImage, colorImage);

ptCloud2 = pcmerge(ptCloud2, ptCloud2, 0.00001);

mat=ptCloud2.Location;
col=ptCloud2.Color;
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
ptCloud2 = pointCloud(mat,'Color',col); 

gridSize = 0.1;
fixed = pcdownsample(ptCloud1, 'gridAverage', gridSize);
moving = pcdownsample(ptCloud2, 'gridAverage', gridSize);

tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);

ptCloudAligned = pctransform(ptCloud2,tform);

mergeSize = 0.0001;
ptCloud = pcmerge(ptCloud1, ptCloudAligned, mergeSize);


player = pcplayer(ptCloud.XLimits, ptCloud.YLimits, ptCloud.ZLimits,'VerticalAxis', 'y', 'VerticalAxisDir', 'down')

view(player, ptCloud)