%%% Author: Ruobai Feng, Shuan Guo
function [QLx, QRx] = ncm_test(data, Qx, par)

    test_data = data(Qx,1:(size(data,2)-1)); % test_data = [actual_data class]
    
    distance = dist2(test_data, par(:,1 : size(par,2)-1));
    
    [~, minidx] = min(distance,[],2);
    Pred_class = minidx;
    label = par(Pred_class, size(par,2));% found label for this assigned class from par
    QLx = Qx(label == 1);
    QRx = Qx(label == 0);
end