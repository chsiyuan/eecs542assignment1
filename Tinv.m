function l=Tinv(w,i,j) 
%---------------------------------------
% Input:
% w, a 1*4 row vector. And each element is a integer, so you need to
% multiply the scalar of each axis when calculating.
% i, the index of node needing to be transformed
% j, the index of node connected to the node i, when doing the
% transformation.
% Output:
% l, a 1*4 row vector, the orignal location of a node, in the form of [x,y,scale,theta]
%---------------------------------------