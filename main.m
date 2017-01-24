startup;
installmex;
% if node i is the parent of node j,tree(i,j)=1, and otherwise,
% tree(i,j)=0;
% 1=torso, 2=left upper arm, 3=right upper arm, 4=left lower arm, 
% 5=right lower arm, 6= head
I=imread('000063.jpg'); seq=1;
tree=zeros(6,6); 
tree(1,2)=1; tree(1,3)=1; tree(1,6)=1;
tree(2,4)=1; tree(3,5)=1;
% the depth of each node
depth=[0,1,1,2,2,1];
% each element of F is a 50*50*20*10 matrix. F is the output of
% Initialization (leaf->root)
F=cell([1,6]);
% each element of B is a 50*50*20*10 matrix. B is the minimized value of
% cost function at each location wi of the parent node. (leaf->root)
B=cell([1,6]);
% each element of w_opt_table is a 50*50*20*10 matrix. It is the location of
% wj at each location wi of the parent node.(leaf->root).
% pay attention here, the location is not a vector, but a number.
% use function trans2 to calculate the number from a row vector [x,y,scale,theta]
w_opt_table=cell([1,6]);
% each element of w_opt is a number. It is the location of
% node j,i.e. wj, given the parent location.(root->leaf)
w_opt=cell([1,6]);
% each element of l_opt is a 1*4 row_vector. It is the actual location of
% node j computed by Tinv.(root->leaf)
l_opt=cell([1,6]);
dmax=max(depth);

% calculate the loaction and B for all nodes  
% leaf->root
for d=dmax:-1:0
    node_d=find(depth==d);
    for idx=1:length(node_d)
      node=node_d(idx);
      child=find(tree(node,:)~=0);
      parent=find(tree(:,node)~=0);
      F{node}=Initialize(I,node,seq,B,child);
      if d ~=0
        [B{node},w_opt_table{node}]=Twopass(F{node},node,parent);
      else
          a=min(min(min(min(F{1}))));
          [m,n,p,q]=size(F{1});
          k=find(F{1}==a);
          w_opt{node}=k;
          temp=trans(k,m,n,p,q);
          l_opt{node}=Tinv(temp,node,); % every entry of temp is a integer, do not forget scale in Tinv
      end
    end    
end

%root->leaf
for d=1:dmax
    node_d=find(depth==d);
    for idx=1:length(node_d)
        node=node_d(idx);
        parent=find(tree(:,node)~=0);
        w_opt{node}=w_opt_table{node}(w_opt{parent});
        temp=trans(w_opt{node},m,n,p,q);
        l_opt{node}=Tinv(temp);
    end
end

% visualize
figure;
imshow(I); hold on;
for i=1:6
    l=l_opt(node);
    x1til=l(1)+l(4)*cos(l(3));
    y1til=l(2)+l(4)*sin(l(3));
    x2til=l(1)-l(4)*cos(l(3));
    y2til=l(2)-l(4)*sin(l(3));
    line([y1til,x1til],[y2til,x2til]); hold on;
end