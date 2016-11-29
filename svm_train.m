function[QLx_, QRx_, par_, entropyQL_,entropyQR_,PQL_,PQR_, split_found] = ...
    svm_train(data, QX, entropy, clmax)

  th = 0.001;
  BestGain = th;

  QLx_ = 0;
  QRx_ = 0;
  par_ = 0;
  entropyQL_ = 0;
  entropyQR_ = 0 ;
  PQL_ = 0;
  PQR_ = 0;

for i=1:length(QX)

    X = data(QX,1:(size(data,2) - 1));
    magnitude = length(QX);

    % randomly assign the labels of data from each class to 0,1
    label = ones(magnitude,1);
    rand_idx = randperm(magnitude, round(magnitude * 0.5));
    label(rand_idx) = 0;

    new_Par = fitcsvm(X,label);
    Pred_label = predict(new_Par,X);

    QLx = QX(:,(Pred_label == 1));
    QRx = QX(:,(Pred_label == 0));

    [Gain,PQL,PQR,entropyQL,entropyQR] = gain_entropy(entropy,QLx,QRx,data,clmax);

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

% Determine if split is found
if (BestGain == th)
    split_found = 0;
    else
    split_found = 1;
end

end
