function [a] = pvetcor(theta,phi,k0,n,mode)



nv =[0 0 -1];

k = k0*n*[sin(theta)*cos(phi) sin(theta)*sin(phi) cos(theta)];

if theta == 0
   ate = [0 1 0];
else
   ate = cross(k,nv)/norm(cross(k,nv));
end 
if mode == 'te'
   a = ate;
else if mode == 'tm'
        a = cross(ate,k)/norm(cross(ate,k));
    end
end