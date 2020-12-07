function compare(img1,img2)

image22=img1-mean2(img1);
Nimage=img2-mean2(img2);  
corr=sum(sum(Nimage.*image22,2))
M1=corr/sqrt(sum(sum(Nimage.^2)))
M2=corr2(img1,img2)