function [counts,binlocation] = imhist3(img)

[c1,binlocation] = imhist(img(:,:,1));
[c2,~] = imhist(img(:,:,2));
[c3,~] = imhist(img(:,:,3));

counts = cat(2,c1,c2,c3);
counts(1,:) = [1 1 1];
counts(256,:) = [1 1 1];