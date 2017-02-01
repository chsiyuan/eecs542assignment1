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
global lrange bnum wx wy ws wt;

weight = [wx(i,j), wy(i,j), wt(i,j), ws(i,j)];
wrange = [lrange(:,1:3) log(lrange(:,4))] .* ([1,1]'*weight);
%wgrid = (wrange(2,:)-wrange(1,:)) ./ (bnum-1);
wgrid = [0,0,0,0];

load('W_w.mat');
B_w = F;

for x = 1:bnum(1)
    for y = 1:bnum(2)
        for t = 1:bnum(3)
            for s = 1:bnum(4)
                if isnan(B_w(x,y,t,s))
                        continue;
                end
                if(t == 1)
                    [B_w(x,y,t,s), min_idx] = min( [B_w(x,y,t,s),...
                                                B_w(max(x-1,1),y,t,s),...
                                                B_w(x,max(y-1,1),t,s),...
                                                B_w(x,y,bnum(3),s),...
                                                B_w(x,y,t,max(s-1,1))]...
                                                + [0,wgrid] );
                     idx_list = [x,y,t,s;
                                 max(x-1,1),y,t,s;
                                 x,max(y-1,1),t,s; 
                                 x,y,bnum(3),s;
                                 x,y,t,max(s-1,1)];
                else
                    [B_w(x,y,t,s), min_idx] = min( [B_w(x,y,t,s),...
                                                B_w(max(x-1,1),y,t,s),...
                                                B_w(x,max(y-1,1),t,s),...
                                                B_w(x,y,max(t-1,1),s),...
                                                B_w(x,y,t,max(s-1,1))]...
                                                + [0,wgrid] );
                    idx_list = [x,y,t,s;
                                max(x-1,1),y,t,s; 
                                x,max(y-1,1),t,s; 
                                x,y,max(t-1,1),s; 
                                x,y,t,max(s-1,1)];
                end
                W_w(x,y,t,s) = W_w(trans2(idx_list(min_idx,:)));
            end
        end
    end
end

for x = bnum(1):-1:1
    for y = bnum(2):-1:1
        for t = bnum(3):-1:1
            for s = bnum(4):-1:1
                if isnan(B_w(x,y,t,s))
                        continue;
                end
                if t == bnum(3)
                    [B_w(x,y,t,s), min_idx] = min( [B_w(x,y,t,s),...
                                                    B_w(min(x+1,bnum(1)),y,t,s),...
                                                    B_w(x,min(y+1,bnum(2)),t,s),...
                                                    B_w(x,y,1,s),...
                                                    B_w(x,y,t,min(s+1,bnum(4)))]...
                                                + [0,wgrid] );
                     idx_list = [x,y,t,s;
                                 min(x+1,bnum(1)),y,t,s;
                                 x,min(y+1,bnum(2)),t,s;
                                 x,y,1,s;
                                 x,y,t,min(s+1,bnum(4))];
                else
                    [B_w(x,y,t,s), min_idx] = min( [B_w(x,y,t,s),...
                                                    B_w(min(x+1,bnum(1)),y,t,s),...
                                                    B_w(x,min(y+1,bnum(2)),t,s),...
                                                    B_w(x,y,min(t+1,bnum(3)),s),...
                                                    B_w(x,y,t,min(s+1,bnum(4)))]...
                                                + [0,wgrid] );
                     idx_list = [x,y,t,s;
                                 min(x+1,bnum(1)),y,t,s;
                                 x,min(y+1,bnum(2)),t,s;
                                 x,y,min(t+1,bnum(3)),s;
                                 x,y,t,min(s+1,bnum(4))];
                end
                W_w(x,y,t,s) = W_w(trans2(idx_list(min_idx,:)));
            end
        end
    end
end

% Bj(li) <-- Bj(wi)
% Wj(li) <-- Wj(wi)
B_l = zeros(bnum);
W_l = zeros(bnum);
for x = 1:bnum(1)
    for y = 1:bnum(2)
        for t = 1:bnum(3)
            for s = 1:bnum(4)
                wi = trans2(T([x,y,t,s],i,j));   % wi = Tij(li)
                if isnan(wi)
                    B_l(x,y,t,s) = nan;  % TBD
                    W_l(x,y,t,s) = nan;
                else
                    B_l(x,y,t,s) = B_w(wi);
                    W_l(x,y,t,s) = W_w(wi);
                end
            end
        end
    end
end            

% function b = ifdefine(a)
% if isnan(a)
%     b = inf;
% else
%     b = a;
% end
