function[QLx_, QRx_, par_, entropyQL_,entropyQR_,PQL_,PQR_, split_found] = ...
    ncm_train(data, QX, entropy, clmax)

%% NCM Train
% Combining NCM and Random Forest
% INPUT : data: whole data  QX: sampled data 
%         entropy: entropy of parent tree
%         clmax : number of total classes
% OUTPUT : par_ : parameters of the best NCM classifier for each node
%          (include assigned class & assigned label (1 or 0))
%          QLx_, QRx_ : index of data for left and right child nodes
%          entropyQL_, entropyQR_ : entropy of left and right child nodes
%          PQL_, PQR_ : distributions of posterior probabilities for left and right
%          child nodes

  th = 0.001; % threshold
  BestGain = th;
  %mahalDistance = 1; % 1-yes 0-no
  
  QLx_ = 0; % left node
  QRx_ = 0; % right node
  par_ = 0; % parameter(c_means)
  entropyQL_ = 0; % left node - entropy
  entropyQR_ = 0; % right node - entropy
  PQL_ = 0; % left node - distribution
  PQR_ = 0; % right node - distribution


  % Initialization
  X = data(QX,1:(size(data,2) - 1));
  class_label = data(QX,size(data,2));
  magnitude = length(QX);

  
  % Calculation of centroids : c_means
  
  c_mean = zeros(clmax,size(X,2));
    
  for j = 1:clmax
      c_data = X(class_label == j,:);
      c_mean(j,:) = sum(c_data,1)/size(c_data,1);
  end
   
  
  % predict classes for each datapoint
  Pred_class = zeros(magnitude,1);
  distance = zeros(clmax,1);
  for m =1: magnitude
      for n = 1:clmax
          %if mahalDistance
          %  distance(n) = mean(mahal(X(m,:)', c_mean(n,:)'));
          %else
            distance(n) = mean(dist2(X(m,:), c_mean(n,:)));
          %end
      end
      [minvalue, minidx] = min(distance);
      Pred_class(m) = minidx;
      
  end
    
  for i=1:length(QX)
        
    Pred_label = zeros(magnitude,1);
    
    
    assign_label = ones(clmax,1);
    rand_idx = randperm(clmax, round(clmax * 0.5));
    assign_label(rand_idx) = 0;  
    
    for m =1: magnitude
        Pred_label(m) = assign_label(Pred_class(m));
    end
      
    new_Par = [c_mean assign_label];
    QLx = QX(:,(Pred_label == 1));
    QRx = QX(:,(Pred_label == 0));

    [Gain,PQL,PQR,entropyQL,entropyQR] = gain_entropy(entropy,QLx,QRx,data,clmax);

    
    % Determine if it is the best gain
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
