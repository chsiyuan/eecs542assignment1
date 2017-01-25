function [B_l,W_l]=Twopass(F,i,j)

%-------------------------------
% Input:
% F, a 50*50*20*10 matrix with initialized number
% i, parent node
% j, child node
%
% Output:
%
% B, a 50*50*20*10 matrix, the minimized generalized distance value 
% at each location of its parent
% w, a 50*50*20*10 matrix, the best location of wj given wi.
% i, the index of the current node
% j, the index of the parent of the current node
%
% Attention: 
% each entry of w is a number instead of a vector of
% [x,y,s,theta], the entry of which is the integer(index) rather than a real value, such as [1,2,3,4] 
% Every time you get a vector, please use the function
% trans2 to get a number.
%-------------------------------

weight_vec = [1,1,1,1]; % TBD
l_scope = [1,   1,   log(0.5),   0;
           405, 720, log(2), 2*pi];
w_scope = [l_scope(1,:)./weight_vec ; l_scope(2,:)./weight_vec];
[m,n,p,q] = size(F);
k_vec = (w_scope(2,:)-w_scope(1,:))./[m,n,p,q];
B = F;
W = zeros(m,n,p,q);

for x = 1:m
    for y = 1:n
        for s = 1:p
            for t = 1:q
                current = trans2([x,y,s,t],m,n,p,q);
                pre(1) = trans2([max(x-1,1),y,s,t],m,n,p,q);
                pre(2) = trans2([x,max(y-1,1),s,t],m,n,p,q);
                pre(3) = trans2([x,y,max(s-1,1),t],m,n,p,q);
                if t == 1
                    pre(4) = trans2([x,y,s,q],m,n,p,q);
                else
                    pre(4) = trans2([x,y,s,t-1],m,n,p,q);
                end
                [B(current), min_idx] = min( [B(current), B(pre)] + [0,k_vec] );
                if(min_idx == 1)
                    W(current) = current;
                else
                    W(current) = pre(min_idx-1);
                end
            end
        end
    end
end

for x = 1:m
    for y = 1:n
        for s = 1:p
            for t = 1:q
                current = trans2([x,y,s,t],m,n,p,q);
                pre(1) = trans2([min(x+1,m),y,s,t],m,n,p,q);
                pre(2) = trans2([x,min(y+1,n),s,t],m,n,p,q);
                pre(3) = trans2([x,y,min(s+1,p),t],m,n,p,q);
                if t == q
                    pre(4) = trans2([x,y,s,1],m,n,p,q);
                else
                    pre(4) = trans2([x,y,s,t+1],m,n,p,q);
                end
                [B(current), min_idx] = min( [B(current), B(pre)] + [0,k_vec] );
                if(min_idx == 1)
                    W(current) = current;
                else
                    W(current) = pre(min_idx-1);
                end
            end
        end
    end
end

% Bj(wi) --> Bj(li)
% Wj(wi) --> Wj(li)
B_l = zeros(m,n,p,q);
W_l = zeros(m,n,p,q);
for x = 1:m
    for y = 1:n
        for s = 1:p
            for t = 1:q
                li = trans2([x,t,s,t]);
                wi = trans(T(li,i,j));   % wi = Tij(li)  do I need to do the interplation here?
                if wi == -1
                    B_l(li) = inf;  % TBD
                    W_l(li) = nan;
                else
                    B_l(li) = B(wi);
                    W_l(li) = W(wi);
                end
            end
        end
    end
end            
