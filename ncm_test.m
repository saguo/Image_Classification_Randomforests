function [QLx, QRx] = ncm_test(data, Qx, par)
    test_data = data(Qx,:);
    
    Pred_class = 0;
    label = 0;
    distance = zeros(size(par,1),1);
    for n = 1:length(par)
        distance(n) = mean(dist2(test_data, par(n,1 : size(par,2)-1)));
    end
    [minvalue, minidx] = min(distance);
    Pred_class = minidx;
    label = par(Pred_class, size(par,2));
    QLx = Qx(label == 1);
    QRx = Qx(label == 0);
end