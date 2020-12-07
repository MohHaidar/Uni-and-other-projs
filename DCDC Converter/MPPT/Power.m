function P=Power(x,Wspeed)
global P1
global P2
global P3
global P4
global P5

if Wspeed==1
index = find(round(P1(1,:)*100)/100==round(x*100)/100);
P=P1(2,index(1));
elseif Wspeed==2
index = find(round(P2(1,:)*100)/100==round(x*100)/100);
P=P2(2,index(1));
elseif Wspeed==3
index = find(round(P3(1,:)*100)/100==round(x*100)/100);
P=P3(2,index(1));
elseif Wspeed==4
index = find(round(P4(1,:)*100)/100==round(x*100)/100);
P=P4(2,index(1));
elseif Wspeed==5
index = find(round(P5(1,:)*100)/100==round(x*100)/100);
P=P5(2,index(1));
end
end