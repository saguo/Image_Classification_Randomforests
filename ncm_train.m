function[QLx_, QRx_, par_, entropyQL_,entropyQR_,PQL_,PQR_, split_found] = ...
    ncm_train(data, QX, entropy, clmax)

  th = 0.001;
  BestGain = th;

  QLx_ = 0;
  QRx_ = 0;
  par_ = 0;
  entropyQL_ = 0;
  entropyQR_ = 0;
  PQL_ = 0;
  PQR_ = 0;

for i=1:length(QX)

    X = data(QX,1:(size(data,2) - 1));
    class_label = data(QX,size(data,2));
    magnitude = length(QX);

    c_mean = zeros(clmax,size(X,2));
    
    for j = 1:clmax
        c_data = X(class_label == j,:);
        c_mean(j,:) = sum(c_data,1)/size(c_data,1);
    end
    
    assign_label = ones(clmax,1);
    rand_idx = randperm(clmax, round(clmax * 0.5));
    assign_label(rand_idx) = 0;
    
    
    Pred_class = zeros(magnitude,1);
    Pred_label = zeros(magnitude,1);
    distance = zeros(clmax,1);
    
    
    for m =1: magnitude
        for n = 1:clmax
            distance(n) = mean(mahal(X(m,:)', c_mean(n,:)'));
        end
        [minvalue, minidx] = min(distance);
        Pred_class(m) = minidx;
        Pred_label(m) = assign_label(Pred_class(m));
    end
    
    new_Par = c_mean;
    
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
