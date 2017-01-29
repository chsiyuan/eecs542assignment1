function F = Initialize(node,seq,B,child,pnode)
%----------------------------------------------
% Input:
% I: the orginal image
% node: 1=torso, 2=left upper arm, 3=right upper arm, 4=left lower arm, 
% 5=right lower arm, 6= head
% seq: the sequence of the image in the folder. It will be used in the match
% cost function.
% B: a cell contains all the Bi matrix {B1,B2,B3,B4,B5,B6}
% child: a vector containing the indexes of children of this node. If the
% node does not have any child, it will be empty.
% parent: the index of parent node. If the node is the root, it will be empty.
%
% Output: initialization F, a 50*50*20*10 matrix [x,y,scale,theta]
%---------------------------------------------------------------------------------------
global lgrid lrange bnum;

Bc = zeros(bnum);
childnum = length(child);
for idx=1:childnum
    Bc = Bc+B{child(idx)};
end

F = zeros(bnum);
if isempty(pnode)
    for x = 1:bnum(1)
        for y = 1:bnum(2)
            for theta = 1:bnum(3)
                for s = 1:bnum(4)
                    lreal = ([x,y,theta,s] - ones(1,4)) .* lgrid + lrange(1,:);
                    F(x,y,theta,s) = Bc(x,y,theta,s) + match_enery_cost(lreal,node,seq);
                end
            end
        end
    end
else
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
                        F(x,y,theta,s) = Bc(trans2(l)) + match_enery_cost(lreal,node,seq);
                    end
                end
            end
        end
    end
end