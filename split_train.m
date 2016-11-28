function [QLx_, QRx_, par_, entropyQL_, entropyQR_, PQL_, PQR_, split_found] = ...
    split_train(data, Qx, entropy, clmax)

    % a simple function to perform the random split for decision trees
    % the all possible split number is too large and here we only randomly 
    % split for O(n) times and choose the one with best Gain

    % data      % the original labelled data of n*(d+1)
    % Qx        % input indexing for data
    % clmax     % maximum class number
    % entropy   % parent entropy

    % initialization
    th=0.0001;               % threshold for Gain and stopping criteria.
    BestGain=th;
    d = size(data,2)-1; % first examine the size of data
    n = size(data,1);
    par_ = zeros(1,2);
    QLx_ = zeros(1);
    QRx_ = zeros(1);
    entropyQL_ = 0;
    entropyQR_ = 0;
    PQL_ = zeros(1);
    PQR_ = zeros(1);
    % O(n) iterations   
    for i=1:length(Qx)
        % random splitting parameters
        new_theta = randi(d); % from all the features select one to split
        new_tau   = data(Qx(i),new_theta);    %random the threshold
        QLx=Qx(data(Qx,new_theta)<new_tau);
        QRx=Qx(data(Qx,new_theta)>=new_tau);

        % compute entropy the left node
        PQL=hist(data(QLx,3),1:clmax)+1e-6;
        PQL=PQL/sum(PQL);
        entropyQL=-1*sum(PQL.*log2(PQL));
        magnitudeQL=length(QLx);

        % compute entropy the right node
        PQR=hist(data(QRx,3),1:clmax)+1e-6;
        PQR=PQR/sum(PQR);
        entropyQR=-1*sum(PQR.*log2(PQR));
        magnitudeQR=length(QRx);
        % compute gain
        Gain=entropy-(magnitudeQL*entropyQL + magnitudeQR*entropyQR)/n;

        if(BestGain<Gain)
            % update Gain and store the new optimizing parameters
            BestGain = Gain;
            par_(1) = new_theta;
            par_(2) = new_tau;
            QLx_ = QLx;
            QRx_ = QRx;
            entropyQL_ = entropyQL;
            entropyQR_ = entropyQR;
            PQL_ = PQL;
            PQR_ = PQR;
        end 
    end
    
    if(BestGain==th)
        split_found = 0;
    else
        split_found = 1;
    end
end


