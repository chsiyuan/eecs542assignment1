function Visualize(l,i)
% Visualize part i by drawing a line segment
% l: the real coordinates of the centroid
% i: the index of part
global ideallen lgrid lrange

l = (l - ones(1,4)) .* lgrid + lrange(1,:);
x = l(1); y = l(2); theta = l(3); scale = l(4);
R = [cos(theta), -sin(theta);
     sin(theta), cos(theta)];
if i > 1 && i < 6 
    xy1 = [x, y]' + scale * R * [0,ideallen(i)]';
    xy2 = [x, y]' + scale * R * [0,-ideallen(i)]';
else
    xy1 = [x, y]' + scale * R * [ideallen(i),0]';
    xy2 = [x, y]' + scale * R * [-ideallen(i),0]';
end
line([xy1(2),xy2(2)],[xy1(1),xy2(1)]); hold on;