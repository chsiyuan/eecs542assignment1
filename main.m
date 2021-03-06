startup;
installmex;

clear all
tic 

I = imread('000063.jpg'); seq=1;

%% Definition
% if node i is the parent of node j,tree(i,j)=1, and otherwise,
% tree(i,j)=0;
% 1=torso, 2=left upper arm, 3=right upper arm, 4=left lower arm, 
% 5=right lower arm, 6= head
tree = zeros(6,6); 
tree(1,2) = 1; tree(1,3) = 1; tree(1,6) = 1;
tree(2,4) = 1; tree(3,5) = 1;

% the depth of each node
depth = [0,1,1,2,2,1];
dmax = max(depth);

% each element of F is a 50*50*20*10 matrix based on the wj gird. F is the output of
% Initialization (leaf->root)
% F{1} is based on the l1 grid.
F = cell([1,6]);

% each element of B is a 50*50*20*10 matrix based on the li grid. B is the minimized value of
% cost function at each location li of the parent node. (leaf->root)
B = cell([1,6]);

% each element of w_opt_table is a 50*50*20*10 matrix based on the li grid. It is the location of
% wj at each location li of the parent node.(leaf->root).
% pay attention here, the location is not a vector, but a number.
% use function trans2 to calculate the number from a row vector [x,y,scale,theta]
w_opt_table = cell([1,6]);

% each element of l_opt_number is a number. It is the optimal location of
% node j, i.e. lj, given the parent location.(root->leaf)
l_opt_number = cell([1,6]);

%% Parameters
% -------
% Note that in the whole program, the order of 4-turple is:
% x, y, theta, scale
% -------
% Number of buckets
global bnum;
bnum = [50, 50, 20, 10]; % m=50; n=50; p=20; q=10;

% Range of l grid
global lrange;   
lrange = [1,         1,         0,    0.5;
          size(I,1), size(I,2), 2*pi, 2 ];
      
% Scale of l grid
global lgrid; 
lgrid = (lrange(2,:)-lrange(1,:)) ./ (bnum-1);

% Weight of x,y,s,theta
global wx wy ws wt;
wx = [0,1,1,0,0,1;
      1,0,0,1,0,0;
      1,0,0,0,1,0;
      0,1,0,0,0,0;
      0,0,1,0,0,0;
      1,0,0,0,0,0];
wx = wx*5;
wy = [0,1,1,0,0,1;
      1,0,0,1,0,0;
      1,0,0,0,1,0;
      0,1,0,0,0,0;
      0,0,1,0,0,0;
      1,0,0,0,0,0];
wy = wy*5;
wt = [0,1,1,0,0,1;
      1,0,0,1,0,0;
      1,0,0,0,1,0;
      0,1,0,0,0,0;
      0,0,1,0,0,0;
      1,0,0,0,0,0];
ws = [0,1,1,0,0,1;
      1,0,0,1,0,0;
      1,0,0,0,1,0;
      0,1,0,0,0,0;
      0,0,1,0,0,0;
      1,0,0,0,0,0];
ws = ws*20;

% Ideal parameters
global ideallen; ideallen=[80, 47.5, 47.5, 32.5, 32.5, 30];
global x_ij; load('x_ij.mat');
global y_ij; load('y_ij.mat');
global t_ij; load('t_ij.mat');
global s_ij; load('s_ij.mat');




%% Optimization 
% leaf->root
for d = dmax:-1:0
    node_d = find(depth==d);
    for idx = 1:length(node_d)
      node = node_d(idx);
      node
      child = find(tree(node,:)~=0);
      pnode = find(tree(:,node)~=0);
      F{node} = Initialize(node,seq,B,child,pnode);  % If node = torso, F(l); otherwiese, F(w)
      if d ~=0
        [B{node},w_opt_table{node}] = Twopass(F{node},pnode,node);
      else
          a = min(min(min(min(F{node}))));
          k = find(F{node}==a);
          k = k(1);
          l_opt_number{node} = k;
      end
    end    
end

% root->leaf
for d = 1:dmax
    node_d = find(depth==d);
    for idx = 1:length(node_d)
        node = node_d(idx);
        pnode = find(tree(:,node)~=0);
        w_opt = w_opt_table{node}(l_opt_number{pnode});
        w_temp = trans(w_opt);
        l_temp = Tinv(w_temp,node,pnode);
        assert(~sum(isnan(l_temp)),'You fail!!! HA HA HA');
        l_opt_number{node} = trans2(l_temp);
    end
end

toc
%% Visualization
figure;
imshow(I); hold on;
for i = 1:6
    Visualize(trans(l_opt_number{i}),i);
end