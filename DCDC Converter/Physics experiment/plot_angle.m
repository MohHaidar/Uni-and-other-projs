function plot_angle(datax,datay) 
ABC = find_points(datax,datay);

[radius,center]=fit_circle_through_3_points(ABC);

plot_circle(center(1),center(2),radius);

plot([center(1) ABC(1,1)],[center(2) ABC(1,2)]);
plot([center(1) ABC(2,1)],[center(2) ABC(2,2)]);
angle = atan2(ABC(2,2)-center(2),ABC(2,1)-center(1))-atan2(ABC(1,2)-center(2),ABC(1,1)-center(1)); % arctan((Ymax-Yc)/(Xmax-Xc))-arctan((Ymin-yc)/(Xmin-Xc))
text(5,-35,num2str(angle*180/pi));