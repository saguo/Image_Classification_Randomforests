function [Gain,PQL,PQR,entropyQL,entropyQR] = gain_entropy(entropy,QLx,QRx,data,clmax)

    % compute entropy the left node
    PQL=hist(data(QLx,size(data,2)),1:clmax)+1e-6;
    PQL=PQL/sum(PQL);
    entropyQL=-1*sum(PQL.*log2(PQL));
    magnitudeQL=length(QLx);

    % compute entropy the right node
    PQR=hist(data(QRx,size(data,2)),1:clmax)+1e-6;
    PQR=PQR/sum(PQR);
    entropyQR=-1*sum(PQR.*log2(PQR));
    magnitudeQR=length(QRx);

    % compute gain
    Gain = entropy-(magnitudeQL*entropyQL + magnitudeQR*entropyQR)/(magnitudeQL+magnitudeQR);
end