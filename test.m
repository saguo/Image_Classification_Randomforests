function [pred, error] = test(sroot, data, clmax, test_func)
%% test in a given forest
% sroot: root of forest
% data: test data
% clmax: number of classes
% test_func: specific function for testing data in a node
% pred: prediction of data

data_size = size(data, 1);
Qx = 1: data_size;
PQ_out = zeros(data_size, clmax);
for i = 1: length(sroot)
    root = sroot{i};
    PQ_out = prediction(root, data, Qx, PQ_out, test_func);
end
[~, pred] = max(PQ_out, [], 2);
error = sum(data(:, end) ~= pred) / data_size;
