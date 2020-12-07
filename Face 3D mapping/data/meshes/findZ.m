function xyz = findZ(pt,ptc)

%pt = [x y];
points = ptc.Location(:,[1 2]);
N = length(points);
dist = zeros(N,1);
for i=1:N;
dist(i) = sqrt(sum((points(i,:) - pt ) .^ 2));
end
[~,index]=min(dist);
xyz = ptc.Location(index,:);