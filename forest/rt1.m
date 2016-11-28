clear all
load('data.mat')
load('config.mat')
%number of classes
clmax
%number of trees
mmax
%number of population per class
nmax
%max depth
depthmax
%% Randomforest based on [Shotton2011]
% 1. sample test set Q
% 2. random splitting parameters phi=[theta,tau]
% 3. partitioning to create QL and QR
% 4. calculate the largest gain in information
%gain (G) = entropy(Q)-( norm(QL)*entropy(QL) + norm(QR)*entropy(QR) )/norm(Q)
% 5. If the gain is sufficient and depth below a maximum, the recurse.

datasize=size(data,1);

for m=1:mmax
    % 1. sample test set Q
    
    Qx=randperm(datasize);
    Qx=Qx(1:round(0.3*datasize));

    % compute entropy the root node
    PQ=hist(data(Qx,3),1:clmax)+1e-6;
    PQ=PQ/sum(PQ);
    entropyQ=-1*sum(PQ.*log2(PQ));
    magnitudeQ=length(Qx);

    root=branch(Qx,0,magnitudeQ,entropyQ,PQ);
    root=grow(root,data,depthmax,clmax); 
    
    sroot=sbranch(root.theta,root.tau,root.BL,root.BR,root.PQ);
    save(strcat('tree',sprintf('%02d.mat',m)),'sroot');
end