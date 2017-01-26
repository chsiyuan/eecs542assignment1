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
global lgrid lrange bnum wx wy ws wt x_ij y_ij s_ij t_ij;
% turple: x,y,theta,scale

weight = [wx(i,j), wy(i,j), wt(i,j), ws(i,j)];
wrange = [lrange(:,1) lrange(:,2) log(lrange(:,3)) lrange(:,4)] .* ([1,1]'*weight);
wgrid = (wrange(1,:)-wrange(2,:)) ./ (bnum-1);
wreal = (w - ones(1,4)) .* wgrid + wrange(1,:);
xtip = wreal(1); ytip = wreal(2); thetatip = wreal(3); stip = wreal(4);

theta = thetatip / wt(i,j) + t_ij(i,j)/2;
s = exp( stip / ws(i,j) + 1/2 * log(s_ij(i,j)) );
R = [cos(theta), -sin(theta);
     sin(theta), cos(theta)];
Winv = [1/wx(i,j), 0;
        0, 1/wy(i,j)];
xy = Winv * [xtip,ytip]' - s * R * [x_ij(i,j), y_ij(i,j)]';
xy = xy';
lreal = [xy theta s];

l = (lreal - lrange(1,:)) ./ lgrid + ones(1,4);
if (l(1:2) >= ones(1,2)) & (l(1:2) <= bnum(1:2))  % If l is out of the range, set it to nan.
    if (l(3) > bnum(3))
        l(3) = l(3) - bnum(3);
    elseif(w(4) < 1)
        l(3) = l(3) + bnum(3);
    end
else
    l = [nan,nan,nan,nan];
end