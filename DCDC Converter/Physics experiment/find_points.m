function ABC=find_points(datax,datay)

[y1,i1]=min(datay);
[y2,i2]=max(datay);
x1=datax(i1);
x2=datax(i2);

[c idx]=min(abs(((datay)-((y1+y2)/2))));

x3=datax(idx(1));
y3=datay(idx(1));

ABC=[x1 y1;x2 y2;x3 y3];