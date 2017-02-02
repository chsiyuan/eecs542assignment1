global bnum lgrid lrange 
lF = ReadStickmenAnnotationTxt('buffy_s5e2_sticks.txt');
M=cell([1,6]);
seq = 1;
tree = zeros(6,6); 
tree(1,2) = 1; tree(1,3) = 1; tree(1,6) = 1;
tree(2,4) = 1; tree(3,5) = 1;

lreal = ([39,15,10,2] - ones(1,4)) .* lgrid + lrange(1,:);
lmatch = coor_fix(lreal);
temp = match_energy_cost(lF,lmatch,1,seq);

function lmatch = coor_fix(lreal)
lmatch = zeros(1,4);
lmatch(1) = lreal(2);
lmatch(2) = lreal(1);
if lreal(3) <= pi/2
    lmatch(3) = lreal(3);
elseif lreal(3) >= 3*pi/2
    lmatch(3) = lreal(3) - 2*pi;
else
    lmatch(3) = lreal(3) - pi;
end
lmatch(4) = lreal(4);
end