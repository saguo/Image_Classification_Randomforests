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

datasize = length(Qx);
func_name = functions(incre_func);
for i = 1: length(sroot)
    % randomly select 30% data
    perm = randperm(datasize);
    perm = perm(1: round(0.3*datasize));
    Qxr = Qx(perm);
    
    root = sroot{i};
    root = subtree_size(root);
    if strcmp(func_name.function, 'RTST')
        root = uniform(root, 1 / root.nNode);
    elseif strcmp(func_name.function, 'RTSTQ')        
        [root, quality_sum]  = quality(root, 0);
        root = normalize_cp(root, quality_sum);
    end
    root.Qx = [root.Qx, Qxr];
    root.magnitude = length(root.Qx);
    [root.PQ, root.entropy] = entropy(data, root.Qx, clmax); % compute the entropy of root
    [sroot{i}, ~] = incre_func(root, data, Qxr, clmax, depthmax, ratio * root.nNode, train_func, test_func);
end