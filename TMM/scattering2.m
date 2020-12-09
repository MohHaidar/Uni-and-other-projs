function [Sg,R,T] = scattering2(lambda,theta,phi,N,ER,UR,ERref,URref,ERtrn,URtrn,L,mode)


%      theta and phi given in radians
%      ER,UR,L are vectors of length L


%  Initialising

K0 = 2*pi/lambda;
Kx = sin(theta)*cos(phi);
Ky = sin(theta)*sin(phi);

Kz0 = sqrt(1 - Kx^2 - Ky^2);


Q0 = [  Kx*Ky  (1 - Kx^2)  ; (Ky^2 - 1) -Kx*Ky  ];
Omega0 = i*Kz0*eye(2);
V0 = Q0*inv(Omega0);

Sg11 = zeros(2);
Sg12 = eye(2);
Sg21 = Sg12;
Sg22 = Sg11;

%   Loop for all layers

for(n=1:N)
  [Kz,A,B,X] = layer(Kx,Ky,ER(n),UR(n),L(n),V0,K0,'in')
    
  S11 = inv(A - X*B*inv(A)*X*B)*(X*B*inv(A)*X*A - B)
  S12 = inv(A - X*B*inv(A)*X*B)*X*(A - B*inv(A)*B)
  

  [Sg11,Sg12,Sg21,Sg22] = StarProduct2(Sg11,Sg12,Sg21,Sg22,S11,S12,S12,S11);
end

[Kzref,Aref,Bref,Xref] = layer(Kx,Ky,ERref,URref,0,V0,K0,'ot');
[Kztrn,Atrn,Btrn,Xtrn] = layer(Kx,Ky,ERtrn,URtrn,0,V0,K0,'ot');

S11ref = -inv(Aref)*Bref
S12ref = 2*inv(Aref)
S21ref = 0.5*(Aref - Bref*inv(Aref)*Bref)
S22ref = Bref*inv(Aref)

S11trn = Btrn*inv(Atrn)
S12trn = 0.5*(Atrn - Btrn*inv(Atrn)*Btrn)
S21trn = 2*inv(Atrn)
S22trn = -inv(Atrn)*Btrn

[Sg11,Sg12,Sg21,Sg22] = StarProduct2(S11ref,S12ref,S21ref,S22ref,Sg11,Sg12,Sg21,Sg22);
[Sg11,Sg12,Sg21,Sg22] = StarProduct2(Sg11,Sg12,Sg21,Sg22,S11trn,S12trn,S21trn,S22trn);

Sg = [Sg11 Sg12; Sg21 Sg22];
a = pvector(theta,phi,K0,1,mode)
 Eref = Sg11*[a(1) a(2)]' 
 Etrn = Sg21*[a(1) a(2)]' 
 Eref = [Eref' 0]
 Etrn = [Etrn' 0]

Eref(3) = -(Kx*Eref(1)+Ky*Eref(2))/Kzref
Etrn(3) = -(Kx*Etrn(1)+Ky*Etrn(2))/Kztrn


R = norm(Eref)^2;
T = norm(Etrn)^2*real(URref*Kztrn/(URtrn*Kzref));


 