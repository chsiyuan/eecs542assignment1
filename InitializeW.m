global bnum
W_w = zeros(bnum);
for x = 1:bnum(1)
    for y = 1:bnum(2)
        for t = 1:bnum(3)
            for s = 1:bnum(4)
                W_w(x,y,t,s) = trans2([x,y,t,s]);
            end
        end
    end
end