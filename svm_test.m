function [QLx, QRx] = svm_test(data, Qx, par)
    test_data = data(Qx,:);
    label = predict(par,test_data);
    QLx = Qx(label == 1);
    QRx = Qx(label == 0);
end