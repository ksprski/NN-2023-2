function X = myplot(x, l)
    x(isnan(x)) = [];
    
    if (l == 0)    
        plot(x);
    else
        k = ceil(length(x)/l);    
        x(end:k*l) = NaN;
        X = reshape(x, l, k);
        plot(X);
    end
end