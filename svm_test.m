%%% Author: Ruobai Feng
function [QLx, QRx] = svm_test(data, Qx, par)
    test_data = data(Qx, 1 : (size(data,2) -1));
    label = predict(par,test_data);
    QLx = Qx(label == 1);
    QRx = Qx(label == 0);
end