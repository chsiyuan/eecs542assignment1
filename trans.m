function temp=trans(k,m,n,p,q)
% number->vector
k=k-1;
temp=zeros(1,4);
temp(4)=floor(k/(m*n*p))+1;
k=k-(temp(4)-1)*m*n*p;
temp(3)=floor(k/(m*n))+1;
k=k-(temp(3)-1)*m*n;
temp(2)=floor(k/(m))+1;
k=k-(temp(2)-1)*m;
temp(1)=k+1;
end