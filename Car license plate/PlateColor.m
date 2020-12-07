function col= PlateColor(image)

YCBR=rgb2ycbcr(image);
Cr = YCBR(:,:,3);
figure;
imshow(Cr);
threshold = graythresh(Cr);
BW = im2bw(Cr,threshold);
figure;
imshow(BW);
BW2 = imfill(BW,'holes');
figure;
imshow(BW2);
BW2 = imclearborder(BW2);
figure;
imshow(BW2);
se = strel('diamond',2);
BW3 = imerode(BW2,se);
BW3 = imerode(BW3,se);
figure;
imshow(BW3);
mask = im2uint8(BW3);
mask = mask/255;

plate = image;
plate(:,:,1) = plate(:,:,1).*mask; 
plate(:,:,2) = plate(:,:,2).*mask;
plate(:,:,3) = plate(:,:,3).*mask;
figure;
imshow(plate);

RGB = [mean2(nonzeros(plate(:,:,1))) mean2(nonzeros(plate(:,:,2))) mean2(nonzeros(plate(:,:,3)))];
avg = mean(RGB);
ET = sqrt(var(RGB));
if ET > 25
  RGB = (RGB-avg)>0;
  col = color(RGB);
  display(col)
else
  if avg > 100
  col = color([1 1 1]);
   display(col)
  else
  col = color([0 0  0]);
   display(col)
  end
end

 