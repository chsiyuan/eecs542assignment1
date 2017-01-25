function w=T(l,i,j) 
%---------------------------------------
% Input:
%l, a 1*4 row vector, the orignal location of a node, in the form of
%[x,y,scale,theta], the indexes ranther than real value.
% i, the index of node needing to be transformed
% j, the index of node connected to the node i, when doing the
% transformation.
%
% Output:
% w, a 1*4 row vector. And each element is a integer, so you need to
% multiply the scalar of each axis when calculating.
%---------------------------------------
lreal=l.*lgrid+[0,0,0,0.5];
x=lreal(1);y=lreal(2);s=lreal(3);theta=lreal(4);
wreal=zeros(1,4);
wreal(4)=wtheta*(theta-1/2*theta_ij(i,j));
wreal(3)=ws*(log(s)-log(s_ij(i,j))/2);
R=[cos(theta),-sin(theta);sin(theta),cos(theta)];
temp=wx*([x;y]+s*R*[x_ij;y_ij]);
wreal(1)=temp(1);
wreal(2)=temp(2);
w=(wreal-[0,0,0,log(0.5)])./wgrid;