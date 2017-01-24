function F = Initialize(I,node,seq,B,child)
%----------------------------------------------
% Input:
% I, the orginal image
% node: the part num: 1=torso, 2=left upper arm, 3=right upper arm, 4=left lower arm, 
% 5=right lower arm, 6= head
% seq: the sequence of the image in the folder. It will be used in the match
% cost function.
% B: a cell contains all the Bi matrix {B1,B2,B3,B4,B5,B6}
% child: a vector containing the indexes of children of this node. If the
% node does not have any child, it will be empty.
%
% Output: initialization F, a 50*50*20*10 matrix [x,y,scale,theta]
%---------------------------------------------------------------------------------------

F = zeros(size(B{node}));
for i = 1:size(child)
    F = F + B{child(i)};
end

for L = {}
    cost= match_energy_cost(L,node,seq);
    F(L) = F(L) + cost;
end

end