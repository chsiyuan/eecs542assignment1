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
global lgrid lrange bnum wx wy ws wt x_ij y_ij s_ij t_ij;
% turple: x,y,theta,scale

lreal = (l - ones(1,4)) .* lgrid + lrange(1,:);
x = lreal(1); y = lreal(2); theta = lreal(3); s = lreal(4);

thetatip = wt(i,j) * (theta - 1/2 * t_ij(i,j));
stip = ws(i,j) * (log(s) - 1/2 * log(s_ij(i,j)));
R = [cos(theta), -sin(theta);
     sin(theta), cos(theta)];
W = [wx(i,j), 0;
     0,wy(i,j)];
xytip = W * ([x, y]' + s * R * [x_ij(i,j), y_ij(i,j)]');
xytip = xytip';
wreal = [xytip' thetatip stip];

weight = [wx(i,j), wy(i,j), wt(i,j), ws(i,j)];
wrange = [lrange(:,1:3) log(lrange(:,4))] .* ([1,1]'*weight);
wgrid = (wrange(1,:)-wrange(2,:)) ./ (bnum-1);
w = (wreal - wrange(1,:)) ./ wgrid + ones(1,4);  % wreal = (wgrid-(1,1,1,1)).*wgrid + wrange(1,:)
w = round(w);
if (w(1:2) >= ones(1,2)) & (w(1:2) <= bnum(1:2))  % If w is out of the range, set it to nan.
    if (w(3) > bnum(3))
        w(3) = w(3) - bnum(3);
    elseif(w(3) < 1)
        w(3) = w(3) + bnum(3);
    end
else
    w = [nan,nan,nan,nan];
end