function F=Initialize(I,node,seq,B,child,pnode)
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
% parent: the index of parent node. If the node is the root, it will be empty.
%
% Output: initialization F, a 50*50*20*10 matrix [x,y,scale,theta]
%---------------------------------------------------------------------------------------
Bc=zeros(50,50,20,10);
childnum=length(child);
[xrange,yrange,~]=size(I);
lgrid=[xrange/50,yrange/50,2*pi/20,1.5/10];
wgrid=[wx,wy,wtheta,0].*lgrid+ws*[0,0,0,(log(2)-log(0.5))/10];
for idx=1:childnum
    Bc=Bc+B{child(idx)};
end
F=zeros(50,50,20,10);
if isempty(pnode)
    for x=1:50
        for y=1:20
            for theta=1:20
                for s=1:10
                    lreal=[x,y,theta,s].*lgrid+[0,0,0,0.5];
                    F(x,y,theta,s)=Bc(x,y,theta,s)+match_enery_cost(lreal,node,seq);
                end
            end
        end
    end
else
    for x=1:50
        for y=1:50
            for theta=1:20
                for s=1:10
%                     wreal=[x,y,theta,s].*wgrid+[0,0,0,log(0.5)];
%                     lreal=Tinv(wreal,node,pnode);
%                     l=(lreal-[0,0,0,0.5])./lgrid;
                    l=Tinv(w,node,pnode);
                    l=round(l);
                    %lreal<-l
                    lreal=[x,y,theta,s].*lgrid+[0,0,0,0.5];
                    F(x,y,theta,s)=Bc(trans(l))+match_enery_cost(lreal,node,seq);
                end
            end
        end
    end
end