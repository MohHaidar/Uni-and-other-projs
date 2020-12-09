function code = BCHencode (n,k,msg)

% the degree m of GF(2^m)

m = ceil(log2(n+1));

% nb of parity bits

p = n-k;

% nb of detectable errors

t = ceil(p/m);

% minimun distance 

d = 2*t+1;

% initializing g(x)

pol=1;

% findind minimal 2t-1 polynomials and their lcm

for (i=1:t)
phi= fliplr(gfminpol(2*i-1,m));
pol=gfconv(pol,phi);
end

% encoding the msg

inf = [zeros([1 k-length(msg)]) msg];

block = [inf zeros([1 length(pol)-1])];

[~,r] = gfdeconv(fliplr(block),fliplr(pol));

code = [inf fliplr(r)];

poly2sym(pol)