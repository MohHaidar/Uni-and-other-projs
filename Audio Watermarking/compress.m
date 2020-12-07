function C = compress(A,n)
w = 'db3'; 
[c,l] = wavedec(A,n,w);
thr=35;
keepapp = 1;
[C,~,~,~,~] = wdencmp('gbl',c,l,w,n,thr,'h',keepapp);