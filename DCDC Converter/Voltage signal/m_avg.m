avrg=0;
sum=0;
for i=1:5719
    P=yl2(i)*yl2(i)/430;
     sum=sum+P;
     avrg=[avrg sum/i];
end
plot(tl,avrg(2:length(avrg)))