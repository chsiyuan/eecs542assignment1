function [B_l,W_l]=Twopass(F,i,j)
%-------------------------------
% Input:
% F, a 50*50*20*10 matrix with initialized number
% i, parent node
% j, child node
%
% Output:
% B_l, a 50*50*20*10 matrix, the minimized generalized distance value 
% at each location li of its parent i
% W_l, a 50*50*20*10 matrix, the optimal location wj given li
% i, the index of the current node
% j, the index of the parent of the current node
%
% Attention: 
% each entry of W_l is a number instead of a vector of
% [x,y,s,theta], the entry of which is the integer(index) rather than a real value, such as [1,2,3,4] 
% Every time you get a vector, please use the function
% trans2 to get a number.
%-------------------------------
global wgrid bnum;

B_w = F;
W_w = zeros(bnum);

for x = 1:bnum(1)
    for y = 1:bnum(2)
        for s = 1:bnum(3)
            for t = 1:bnum(4)
                if(t == 1)
                    [B_w(x,y,s,t), min_idx] = min( [B_w(x,y,s,t),...
                                                B_w(max(x-1,1),y,s,t),...
                                                B_w(x,max(y-1,1),s,t),...
                                                B_w(x,y,max(s-1,1),t),...
                                                B_w(x,y,s,q)]...
                                                + [0,wgrid] );
                     idx_list = [x,y,s,t;
                                 max(x-1,1),y,s,t;
                                 x,max(y-1,1),s,t; 
                                 x,y,max(s-1,1),t;
                                 x,y,s,q];
                else
                    [B_w(x,y,s,t), min_idx] = min( [B_w(x,y,s,t),...
                                                B_w(max(x-1,1),y,s,t),...
                                                B_w(x,max(y-1,1),s,t),...
                                                B_w(x,y,max(s-1,1),t),...
                                                B_w(x,y,s,t-1)]...
                                                + [0,wgrid] );
                    idx_list = [x,y,s,t;
                                max(x-1,1),y,s,t; 
                                x,max(y-1,1),s,t; 
                                x,y,max(s-1,1),t; 
                                x,y,s,t-1];
                end
                W_w(x,y,s,t) = trans2(idx_list(min_idx),bnum);
            end
        end
    end
end

for x = 1:bnum(1)
    for y = 1:bnum(2)
        for s = 1:bnum(3)
            for t = 1:bnum(4)
                if t == q
                    [B_w(x,y,s,t), min_idx] = min( [B_w(x,y,s,t),...
                                                B_w(min(x+1,bnum(1)),y,s,t),...
                                                B_w(x,min(y+1,bnum(2)),s,t),...
                                                B_w(x,y,min(s+1,bnum(3)),t),...
                                                B_w(x,y,s,1)]...
                                                + [0,wgrid] );
                     idx_list = [x,y,s,t;
                                 min(x+1,bnum(1)),y,s,t;
                                 x,min(y+1,bnum(2)),s,t;
                                 x,y,min(s+1,bnum(3)),t;
                                 x,y,s,1];
                else
                    [B_w(x,y,s,t), min_idx] = min( [B_w(x,y,s,t),...
                                                B_w(min(x+1,bnum(1)),y,s,t),...
                                                B_w(x,min(y+1,bnum(2)),s,t),...
                                                B_w(x,y,min(s+1,bnum(3)),t),...
                                                B_w(x,y,s,t+1)]...
                                                + [0,wgrid] );
                     idx_list = [x,y,s,t;
                                 min(x+1,bnum(1)),y,s,t;
                                 x,min(y+1,bnum(2)),s,t;
                                 x,y,min(s+1,bnum(3)),t;
                                 x,y,s,t+1];
                end
                W_w(x,y,s,t) = trans2(idx_list(min_idx),bnum);
            end
        end
    end
end

% Bj(li) <-- Bj(li)
% Wj(li) <-- Wj(li)
B_l = zeros(bnum);
W_l = zeros(bnum);
for x = 1:bnum(1)
    for y = 1:bnum(2)
        for s = 1:bnum(3)
            for t = 1:bnum(4)
                wi = trans2(T([x,y,s,t],i,j),bnum);   % wi = Tij(li)
                if isnan(wi)
                    B_l(x,y,s,t) = inf;  % TBD
                    W_l(x,y,s,t) = nan;
                else
                    B_l(x,y,s,t) = B_w(wi);
                    W_l(x,y,s,t) = W_w(wi);
                end
            end
        end
    end
end            
