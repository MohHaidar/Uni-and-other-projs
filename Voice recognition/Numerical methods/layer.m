function [Kz,A,B,X] = layer(Kx,Ky,ER,UR,L,V0,K0,pos)



Kz = sqrt(ER*UR - Kx^2 - Ky^2);

Q = (1/UR)*[  Kx*Ky  (ER*UR-Kx^2) ; (Ky^2 - ER*UR)  -Kx*Ky  ];

Omega = i*Kz*eye(2);

V = Q*inv(Omega);

if pos == 'in'

A = eye(2) + inv(V)*V0;
  
B = eye(2) - inv(V)*V0;
  
X = expm(-i*Kz*K0*L*eye(2));
end
if pos == 'ot'
        
A = eye(2) + inv(V0)*V;
  
B = eye(2) - inv(V0)*V;
  
X = expm(-i*Kz*K0*L*eye(2));  
end

