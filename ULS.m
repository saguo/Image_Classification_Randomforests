clear all
load('data.mat')
load('config.mat')
trees = [];
for m=1:mmax
    load(strcat('tree',sprintf('%02d.mat',m)));
    trees=[trees root];
end

datasize=size(data,1);

for m=1:mmax
    root = trees(m);
    % 1. sample test set Q
    Qx=randperm(datasize);
    Qx=Qx(1:round(datasize*0.7));

    % compute entropy the root node
    PQ=hist(data(Qx,3),1:clmax)+1e-6;
    PQ=PQ/sum(PQ);
    entropyQ=-1*sum(PQ.*log2(PQ));
    magnitudeQ=length(Qx);
    
    root.PQ = PQ;
    root.Qx = Qx;
    root.magnitude = magnitudeQ;
    root.entropy = entropyQ;
    
    root=ULS(root,data, clmax);

    save(strcat('tree',sprintf('%02d.mat',m)),'root');
end
