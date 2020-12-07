figure
plot(P1(1,:),P1(2,:))
hold
plot(P2(1,:),P2(2,:))
plot(P3(1,:),P3(2,:))
for i=1:length(power)
  plot(x(1:i),power(1:i),'r-o')
  pause(0.5);
end