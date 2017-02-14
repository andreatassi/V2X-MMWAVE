function [ lin ] = db2Lin( dbIn )
    lin = power(10,(dbIn)./10);
end
