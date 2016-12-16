%%% Author: Ruobai Feng
function direction = svm_test(datapoint, par)
% 1 for left, 2 for right

    Pred = predict(par,datapoint);
    
    if Pred == 1
        direction = 1;
    elseif Pred == 0
        direction = 2;
    end
     
end