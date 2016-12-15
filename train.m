%%% Author: Zhaoming Zhang
function sroot = train(data, Qx, clmax, mmax, depthmax, train_func)
%% initilize a forest
% data: training data
% clmax: number of classes
% mmax: number of trees
% depthmax: max depth of tree
% train_func: specific function for spliting data in a node
% sroot: root of forest

datasize = length(Qx);
sroot = cell(mmax, 1);
for i = 1: mmax
    % randomly select 30% data
    perm = randperm(datasize);
    perm = perm(1: round(0.3*datasize));
    Qxr = Qx(perm);
    
    [PQ, entropyQ] = entropy(data, Qxr, clmax); % compute the entropy of root
    root = branch(Qxr, 0, length(Qxr), entropyQ, PQ);
    sroot{i} = grow(root, data, depthmax, clmax, train_func); 
end


