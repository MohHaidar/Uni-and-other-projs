function [TargetRowIndices, TargetColIndices] = FindRect(center,sz) 

radius = floor([sz(1)/2 sz(2)/2]);
corner = center-radius;
TargetRowIndices = uint8(corner(2)-1:corner(2)+sz(2)-2);
TargetColIndices = uint8(corner(1)-1:corner(1)+sz(1)-2);
