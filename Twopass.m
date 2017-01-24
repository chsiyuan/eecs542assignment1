function [B,w]=Twopass(F,i,j)
%-------------------------------
% Input:
% F, a 50*50*20*10 matrix with initialized number
%
% Output:
% B, a 50*50*20*10 matrix, the minimized generalized distance value 
% at each location of its parent
% w, a 50*50*20*10 matrix, the best location of wj given wi.
% i, the index of the current node
% j, the index of the parent of the current node
%
% Attention: 
% each entry of w is a number instead of a vector of
% [x,y,s,theta], the entry of which is the integer(index) rather than a real value, such as [1,2,3,4] 
% Every time you get a vector, please use the function
% trans2 to get a number.
%-------------------------------