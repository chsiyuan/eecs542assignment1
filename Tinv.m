function l = Tinv(w,i,j) 
%---------------------------------------
% Input:
% w, a 1*4 row vector, the index of node i in grid w related with j
% i, the index of node needing to be transformed
% j, the index of node connected to the node i, when doing the
% transformation.
%
% Output:
% l, a 1*4 row vector, the index of node i in grid l
%---------------------------------------
global lgrid lrange wgrid wrange wx wy ws wt x_ij y_ij s_ij t_ij;

wreal = (w - ones(1,4)) .* wgrid + wrange(1,:);
xtip = wreal(1); ytip = wreal(2); stip = wreal(3); thetatip = wreal(4);

theta = thetatip / wt(i,j) + t_ij(i,j)/2;
s = exp( stip / ws(i,j) + 1/2 * log(s_ij(i,j)) );
R = [cos(theta), -sin(theta);
     sin(theta), cos(theta)];
Winv = [1/wx(i,j), 0;
        0, 1/wy(i,j)];
xy = Winv * [xtip,ytip]' - s * R * [x_ij(i,j), y_ij(i,j)]';
xy = xy';
lreal = [xy s theta];

l = (lreal - lrange(1,:)) ./ lgrid + ones(1,4);
if (l>lrange(1,:)) & (l<lrange(2,:))  % If l is out of the range, set it to nan.
    l = l;
else
    l = [nan,nan,nan,nan];
end