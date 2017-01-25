function l=Tinv(w,i,j) 
%---------------------------------------
% Input:
% w, a 1*4 row vector. And each element is a integer, so you need to
% multiply the scalar of each axis when calculating.
% i, the index of node needing to be transformed
% j, the index of node connected to the node i, when doing the
% transformation.
%
% Output:
%l, a 1*4 row vector, the orignal location of a node, in the form of
%[x,y,scale,theta], the indexes ranther than real value.
%---------------------------------------

%wreal<-w;
wreal=w.*wgrid+[0,0,0,log(0.5)];
xtip=wreal(1); ytip=wreal(2); stip=wreal(3); thetatip=wreal(4);
theta=thetatip/wtheta+theta_ij(i,j)/2;
s=exp(stip/ws+1/2*log(s_ij(i,j)));
a=[xtip;ytip];
R=[cos(theta),-sin(theta);sin(theta),cos(theta)];
temp=a/wx-s*R*[x_ij(i,j);y_ij(i,j)];
lreal=[temp(1),temp(2),s,theta];
l=(lreal-[0,0,0,0.5])./lgrid;