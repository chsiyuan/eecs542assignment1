function Visualize(l,i)
% Visualize part i by drawing a line segment
% l: the real coordinates of the centroid
% i: the index of part
global ideallen lgrid lrange
color = [1,0,0;0,1,0;0,1,0;1,1,0;1,1,0;1,0,1];

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
X = [xy1(2),xy2(2)];
Y = [xy1(1),xy2(1)];
hl = line(X,Y); 
set(hl, 'color', color(i,:));
set(hl, 'LineWidth', 2);
ht = text(double(5+mean(X)), double(5+mean(Y)), num2str(i));
set(ht, 'color', color(i,:));
set(ht , 'FontWeight', 'bold');
hold on;