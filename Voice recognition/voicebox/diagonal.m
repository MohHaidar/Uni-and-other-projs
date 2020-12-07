function d = diagonal (v)
[x,y,z]=size(v);
d = zeros (y,y,z);
for i=1:z
  d(:,:,i)=diag(v(:,:,i));
end  