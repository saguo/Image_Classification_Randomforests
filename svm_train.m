%%% Author: Ruobai Feng, Shuan Guo
function[QLx_, QRx_, par_, entropyQL_,entropyQR_,PQL_,PQR_, split_found] = ...
    svm_train(data, QX, entropy, clmax)

%% SVM Train
% Combining SVM and Random Forest
% INPUT : data: whole data  QX: sampled data 
%         entropy: entropy of parent tree
%         clmax : number of total classes
% OUTPUT : par_ : parameters of the best SVM classifier for each node        
%          QLx_, QRx_ : index of data for left and right child nodes
%          entropyQL_, entropyQR_ : entropy of left and right child nodes
%          PQL_, PQR_ : distributions of posterior probabilities for left and right
%          child nodes


  th = 0.001; % threshold
  BestGain = th;
  
  QLx_ = 0; % left node
  QRx_ = 0; % right node
  par_ = 0; % parameter(c_means)
  entropyQL_ = 0; % left node - entropy
  entropyQR_ = 0; % right node - entropy
  PQL_ = 0; % left node - distribution
  PQR_ = 0; % right node - distribution


for i=1:20
%     fprintf('iteration = %d\n',i)
    X = data(QX,1:(size(data,2) - 1));
    magnitude = length(QX);

    % randomly assign the labels of data from each class to 0,1
    label = ones(magnitude,1);
    rand_idx = randperm(clmax, round(clmax * 0.5));
    label(ismember(data(QX,size(data,2)),rand_idx)) = 0;
    
    % train svm & predict labels

    new_Par = fitcsvm(X,label);
    Pred_label = predict(new_Par,X);
     

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
