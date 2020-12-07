function pcl = Crop(ptCloud);

mat=ptCloud.Location;

bac=find(mat(:,2)>0);
mat(bac,:)=0;

bac=find(mat(:,2)<-0.3);
mat(bac,:)=0;

bac=find(mat(:,1)>0.2);
mat(bac,:)=0;

bac=find(mat(:,1)<-0.2);
mat(bac,:)=0;

pcl=pointCloud(mat);
