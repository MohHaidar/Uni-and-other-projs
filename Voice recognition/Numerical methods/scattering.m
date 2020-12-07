function [S,R,T,Kx,Ky] = scattering(lambda,theta,phy,N,ER,UR,L)

%      theta and phy given in radians


%  Initialization.

K0 = 2*pi/lambda;
Kx = K0*sin(theta)*cos(phy);
Ky = K0*sin(theta)*sin(phy);
Kz0 = sqrt(1 - Kx^2 - Ky^2);


Q0 = [  Kx*Ky  (1 - Kx^2)  ; 

        (Ky^2 - 1) -Kx*Ky  ];

Omega0 = i*Kz0*eye(2);
V0 = Q0*inv(Omega0);

Sg = [zeros(2) eye(2) ;  eye(2) zeros(2)];

for(n=1:N)
  Kz = sqrt(ER(n)*UR(n) - Kx^2 - Ky^2)
  Q = (1/UR(n))*[  Kx*Ky  (ER(n)*UR(n)-Kx^2) ; (Ky^2 - ER(n)*UR(n))  -Kx*Ky  ]
  
  Omega = i*Kz*eye(2)

  V = Q*inv(Omega)

  A = eye(2) + inv(V)*V0;
  B = eye(2) - inv(V)*V0;
  X = expm(-i*Kz*K0*L(n)*eye(2));
  
  S11 = inv(A - X*B*inv(A)*B)*(X*B*inv(A)*A - B);
  S12 = inv(A - X*B*inv(A)*B)*X*(A - B*inv(A)*B);

  S = [  S11 S12  ;

         S12 S11  ];
  
  Sg = StarProduct(Sg,S);

end

S = Sg;

R = 0;

T = 0;

