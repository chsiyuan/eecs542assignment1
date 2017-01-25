startup;
installmex;
% if node i is the parent of node j,tree(i,j)=1, and otherwise,
% tree(i,j)=0;
% 1=torso, 2=left upper arm, 3=right upper arm, 4=left lower arm, 
% 5=right lower arm, 6= head
I=imread('000063.jpg'); seq=1;
global xrange;
global yrange;
[xrange,yrange,~]=size(I);
% si \in (0.5,2)
global Ideallen; Ideallen=[80,40,40,40,40,45];
global lgrid; lgrid=[xrange/50,yrange/50,2*pi/20,1.5/10];
% weight of x,y,s,theta
global wx; wx=1;
global wy; wy=1; %wx=wy
global ws; ws=1;
global wtheta;wtheta=1;
global wgrid; wgrid=[wx,wy,wtheta,0].*lgrid+ws*[0,0,0,(log(2)-log(0.5))/10];
global x_ij; load('x_ij.mat');
global y_ij; load('y_ij.mat');
global s_ij; load('s_ij.mat');
global theta_ij; load('theta_ij.mat');
tree=zeros(6,6); 
tree(1,2)=1; tree(1,3)=1; tree(1,6)=1;
tree(2,4)=1; tree(3,5)=1;
% the depth of each node
depth=[0,1,1,2,2,1];
% each element of F is a 50*50*20*10 matrix based on the wj gird. F is the output of
% Initialization (leaf->root)
% F{1} is based on the l1 grid.
F=cell([1,6]);
% each element of B is a 50*50*20*10 matrix based on the li grid. B is the minimized value of
% cost function at each location li of the parent node. (leaf->root)
B=cell([1,6]);
% each element of w_opt_table is a 50*50*20*10 matrix based on the li grid. It is the location of
% wj at each location li of the parent node.(leaf->root).
% pay attention here, the location is not a vector, but a number.
% use function trans2 to calculate the number from a row vector [x,y,scale,theta]
w_opt_table=cell([1,6]);
% each element of l_opt_number is a number. It is the location of
% node j,i.e. wj, given the parent location.(root->leaf)
l_opt_number=cell([1,6]);
% each element of l_opt is a 1*4 row_vector. It is the actual location of
% node j computed by Tinv.(root->leaf)
l_opt=cell([1,6]);
dmax=max(depth);

m=50; n=50; p=20; q=10;

% calculate the loaction and B for all nodes  
% leaf->root
for d=dmax:-1:0
    node_d=find(depth==d);
    for idx=1:length(node_d)
      node=node_d(idx);
      child=find(tree(node,:)~=0);
      pnode=find(tree(:,node)~=0);
      F{node}=Initialize(I,node,seq,B,child,pnode);
      if d ~=0
        [B{node},w_opt_table{node}]=Twopass(F{node},node,pnode);
      else
          a=min(min(min(min(F{node}))));
          k=find(F{1}==a);
          l_opt_table{node}=k;
          l_opt{node}=trans(k,m,n,p,q);
      end
    end    
end

%root->leaf
for d=1:dmax
    node_d=find(depth==d);
    for idx=1:length(node_d)
        node=node_d(idx);
        pnode=find(tree(:,node)~=0);
        w_opt=w_opt_table{node}(l_opt_number{pnode});
        temp=trans(w_opt,m,n,p,q);
        l_opt{node}=Tinv(temp,node,pnode);
        l_opt_number{node} = trans2 (l_opt{node},m,n,p,q);
    end
end

% visualize
figure;
imshow(I); hold on;
for i=1:6
    l=l_opt(node).*lgrid+[0,0,0,0.5];
    x1til=l(1)+Ideallen(i)*l(4)*cos(l(3));
    y1til=l(2)+Ideallen(i)*l(4)*sin(l(3));
    x2til=l(1)-Ideallen(i)*l(4)*cos(l(3));
    y2til=l(2)-Ideallen(i)*l(4)*sin(l(3));
    line([y1til,x1til],[y2til,x2til]); hold on;
end