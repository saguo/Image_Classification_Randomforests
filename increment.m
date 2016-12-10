function sroot = increment(sroot, data, Qx, clmax, depthmax, ratio, incre_func, train_func, test_func)
%% increment a given forest
% sroot: root of forest
% data: combined data of previously used data and increment data in ascending order
% Qx: index of increment data
% clmax: number of classes
% depthmax: maximum depth of tree
% ratio: maximum cut ratio, only used in RTST
% incre_fuc: specific function for tree increment
% train_func: specific function for spliting data in a node
% test_func: specific function for testing data in a node

for i = 1: length(sroot)
    root = sroot{i};
    root = subtree_size(root);
    root.Qx = [root.Qx, Qx];
    root.magnitude = length(root.Qx);
    [root.PQ, root.entropy] = entropy(data, root.Qx, clmax); % compute the entropy of root
    [sroot{i}, ~] = incre_func(root, data, Qx, clmax, depthmax, ratio * root.nNode, train_func, test_func);
end