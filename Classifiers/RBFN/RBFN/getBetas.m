function [ betas ] = getBetas( x )
%GETBETAS Summary of this function goes here
%   Detailed explanation goes here

len = size(x,1);
betas = zeros(len,1);


sqrdist = inf(len,len);

for i=1:len
    for j=1:len
        if i~=j
            sqrdist(i,j) = sum((x(i,:)-x(j,:)).^2);
        end
    end
    betas(i) = 8/min(sqrdist(i,:));
end


end

