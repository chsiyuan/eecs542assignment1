function w = Tji(l) 
%---------------------------------------
% Input:
% w, a 1*4 row vector. And each element is a integer, so you need to
% multiply the scalar of each axis when calculating.
%
% Output:
% l, a 1*4 row vector, the orignal location of a node, in the form of [x,y,scale,theta]
%---------------------------------------

theta_ij = 0;
s_ij = 1;
x_ij = 0;
y_ij = 0;
x_ji = 0;
y_ji = 0;
w_theta_ij = 1;
w_s_ij = 1;
w_x_ij = 1;
w_y_ij = 1;

[theta, s, x, y] = l;

theta_ = w_theta_ij * (theta + theta_ij/2);
s_ = w_s_ij * (log(s) + log(s_ij)/2);
[x_;y_] = diag(w_x_ij, w_y_ij) * ([x;y] + s*[cos(theta), -sin(theta); sin(theta), cos(theta)]*[x_ji,y_ji]');
w = [theta_, s_, x_, y_];