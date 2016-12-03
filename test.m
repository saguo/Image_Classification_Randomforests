% test all datas
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
    % 1. sample test set Q
    Qx = randperm(datasize);
    PQ_out = zeros(datasize, clmax);
    
    PQ_out = test(root,data,Qx,PQ_out);
    PQ_out = round(PQ_out,4);
end