function DrawTrajectory(Cidx,Kidx)

if size(Cidx,2)==2
if size(Kidx,2)==2
figure
 for i=1:size(Cidx,1)
  plot(Cidx(1:i,1),-Cidx(1:i,2),'r-o','Color','b')
  hold;
  plot(Kidx(1:i,1),-Kidx(1:i,2),'r-o','Color','r')
  hold;
  axis([0 256 -144 0])
  %axis([0 480 0 270])
  pause(0.05);
 end
end
end