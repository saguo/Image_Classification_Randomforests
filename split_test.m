function direction = split_test(theta, par)
% 1 for left, 2 for right.
    direction = 0;
    if theta(par(1)) < par(2)
        direction = 1;
    elseif theta(par(1)) >= par(2)
        direction = 2;
    end
end