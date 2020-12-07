function [x,y] = FindCenter(img)

sz = size(img);

x = round(sz(1)/2);
y = round(sz(2)/2);
