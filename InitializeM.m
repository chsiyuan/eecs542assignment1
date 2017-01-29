global bnum lgrid lrange 
lF = ReadStickmenAnnotationTxt('buffy_s5e2_sticks.txt');
M=cell([1,6]);
seq = 1;
tree = zeros(6,6); 
tree(1,2) = 1; tree(1,3) = 1; tree(1,6) = 1;
tree(2,4) = 1; tree(3,5) = 1;
for node = 2:6
    node
    F = zeros(bnum);
    pnode = find(tree(:,node)~=0);
    for x = 1:bnum(1)
        for y = 1:bnum(2)
            for theta = 1:bnum(3)
                for s = 1:bnum(4)                   
                    l = Tinv([x,y,theta,s],node,pnode);  % lj = T'_ji(wj), l is a vector
                    % lreal<-l
                    if isnan(l)
                        F(x,y,theta,s) = nan;
                    else
                        lreal = (l - ones(1,4)) .* lgrid + lrange(1,:);
                        F(x,y,theta,s) = match_energy_cost(lF,lreal,node,seq);
                    end
                end
            end
        end
    end
    M{node} = F;
end
F = zeros(bnum);
for x = 1:bnum(1)
        for y = 1:bnum(2)
            for theta = 1:bnum(3)
                for s = 1:bnum(4)
                    lreal = ([x,y,theta,s] - ones(1,4)) .* lgrid + lrange(1,:);
                    F(x,y,theta,s) = match_energy_cost(lF,lreal,1,seq);
                end
            end
        end
end
M{1} = F;