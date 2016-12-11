function sroot = train(data, clmax, mmax, depthmax, train_func)
%% initilize a forest
% data: training data
% clmax: number of classes
% mmax: number of trees
% depthmax: max depth of tree
% train_func: specific function for spliting data in a node
% sroot: root of forest

Qx = 1: size(data, 1);
sroot = cell(mmax, 1);
for i = 1: mmax
    [PQ, entropyQ] = entropy(data, Qx, clmax); % compute the entropy of root
    root = branch(Qx, 0, length(Qx), entropyQ, PQ);
    sroot{i} = grow(root, data, depthmax, clmax, train_func); 
end


