function [QLx, QRx] = split_test(data, Qx, par)
    QLx=Qx(data(Qx,par(1))<par(2));
    QRx=Qx(data(Qx,par(1))>=par(2));
end