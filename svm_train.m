function[QLx_, QRx_, par_, entropyQL_,entropyQR_,PQL_,PQR_, split_found] = ...
    svm_train(data, QX, entropy, clmax)

th = 0.001;
BestGain = th;

for i=1:length(QX)

    X = data(QX,1:(size(data,2) - 1));
    magnitude = length(QX);

    % randomly assign the labels of data from each class to 0,1
    label = ones(magnitude,1);
    rand_idx = randperm(magnitude, round(magnitude * 0.5));
    label(rand_idx) = 0;

    new_Par = fitcsvm(X,label);
    Pred_label = predict(new_Par,X);

    QLX = QX(:,find(Pred_label == 1));
    QRX = QX(:,find(Pred_label == 0));

    % compute entropy the left node
    PQL = hist(data(QLx,size(data,2)),1:clmax)+1e-6;
    PQL = PQL / sum(PQL);
    entropyQL = -1*sum(PQL .*log2(PQL));
    magnitudeQL = length(QLx);

    % compute entropy the right node
    PQR = hist(data(QRx,size(data,2)),1:clmax)+1e-6;
    PQR = PQR / sum(PQR);
    entropyQR = -1*sum(PQR.*log2(PQR));
    magnitudeQR = length(QRx);

    Gain = entropy - (magnitudeQL * entropyQL + magnitudeQR * entropyQR) / magnitude;

    if(BestGain < Gain)

            QLx_ = QLx;
            QRx_ = QRx;
            par_ = new_Par;
            entropyQL_ = entropyQL;
            entropyQR_ = entropyQR;
            PQL_ = PQL;
            PQR_ = PQR;
            BestGain = Gain;
    end

end

% Determine if split found
if (BestGain == th)
    split_found = 0;
else
    split_found = 1;
end


