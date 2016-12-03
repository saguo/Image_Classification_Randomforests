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

PQ_out = zeros(datasize, clmax);
for m=1:mmax
    root = trees(m);
    % 1. sample test set Q
    Qx = randperm(datasize);
    PQ_out = test(root,data,Qx,PQ_out);
end
PQ_out = round(PQ_out./mmax,4);