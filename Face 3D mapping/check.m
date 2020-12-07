function c = check(ptc1,ptc2)

gridSize = 0.1;
fixed = pcdownsample(ptc1, 'gridAverage', gridSize);
moving = pcdownsample(ptc2, 'gridAverage', gridSize);
fixed = pcdenoise(fixed);
moving = pcdenoise(moving);
tform = pcregrigid(moving, fixed, 'Metric','pointToPoint','Extrapolate', false);

ptc2 = pctransform(ptc2,tform);

mat1 = ptc1.Location;
mat2 = ptc2.Location;

N1 = length(mat1);
N2 = length(mat2);

N = min(N1,N2);

%Update

mat1 = mat1(1:N,:);
mat2 = mat2(1:N,:);

c = corr2(mat1,mat2);
