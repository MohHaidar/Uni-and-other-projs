P1=flip(P(:,1))';
P1(isnan(P1))=0;

P2=flip(P(:,2))';
P2(isnan(P2))=0;

P3=flip(P(:,3))';
P3(isnan(P3))=0;

P4=flip(P(:,4))';
P4(isnan(P4))=0;

P5=flip(P(:,5))';
P5(isnan(P5))=0;

P6=flip(P(:,6))';
P6(isnan(P6))=0;

P7=flip(P(:,7))';
P7(isnan(P7))=0;

P8=flip(P(:,8))';
P8(isnan(P8))=0;

P9=flip(P(:,9))';
P9(isnan(P9))=0;

r=1:6;
plot(r,[P1;P2;P3;P4;P5;P6;P7;P8;P9])





