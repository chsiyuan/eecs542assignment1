function w = T(l,i,j) 
%---------------------------------------
% Input:
% l, a 1*4 row vector, the index of node i in grid l
% i, the index of node needing to be transformed
% j, the index of node connected to the node i, when doing the
% transformation.
%
% Output:
% w, a 1*4 row vector, the index of node i in grid w related with j 
%---------------------------------------
global lgrid lrange wgrid wrange wx wy ws wt x_ij y_ij s_ij t_ij;

lreal = (l - ones(1,4)) .* lgrid + lrange(1,:);
x = lreal(1); y = lreal(2); s = lreal(3); theta = lreal(4);

thetatip = wt(i,j) * (theta - 1/2 * t_ij(i,j));
stip = ws(i,j) * (log(s) - 1/2 * log(s_ij(i,j)));
R = [cos(theta), -sin(theta);
     sin(theta), cos(theta)];
W = [wx(i,j), 0;
     0,wy(i,j)];
xytip = W * ([x, y]' + s * R * [x_ij(i,j), y_ij(i,j)]');
xytip = xytip';
wreal = [xytip' stip thetatip];

w = (wreal - wrange(1,:)) ./ wgrid + ones(1,4);  % wreal = (wgrid-(1,1,1,1)).*wgrid + wrange(1,:)
w = round(w);
if (w>wrange(1,:)) & (w<wrange(2,:))  % If w is out of the range, set it to nan.
    w = w;
else
    w = [nan,nan,nan,nan];
end