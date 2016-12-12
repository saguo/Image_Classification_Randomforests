function [train_error, test_error, train_time, test_time, sroot] = oneclickresult...
    (data_train, data_test, train_num, test_num, class_num, init_size, incre_size...
    , forest_size, depthmax, cut_ratio, incre_func, train_func, test_func)
%%
% data_train: training data
% data_test: test data
% train_num: polpulation of each class for training
% test_num: polpulation of each class for testing
% class_num: class number of all data
% init_size: class number of initial training data
% incre_size: class number of each increment
% forest_size: number of trees
% depthmax: maximum tree depth
% cut_ratio: only used in RTST and RTSTQ
% incre_fuc: specific function for tree increment: baseline, ULS, IGT, RTST, RTSTQ
% train_func: specific function for spliting data in a node: split_train, ncm_train, svm_train
% test_func: specific function for testing data in a node: split_test, ncm_test, svm_test
% train_error: training error of [initial training, first increment, ...]
% test_error: test error of [initial training, first increment, ...]
% train_time: training time of [initial training, first increment, ...]

% train
Qx = 1: init_size * train_num;
Qx = Qx(randperm(length(Qx)));
tic;
sroot = train(data_train, Qx, init_size, forest_size, depthmax, train_func);
train_time = toc;
% error
Qx = 1: init_size * train_num;
[~, train_error] = test(sroot, data_train, Qx, init_size, test_func);
Qx = 1: init_size * test_num;
tic
[~, test_error] = test(sroot, data_test, Qx, init_size, test_func);
test_time = toc;

% increment and test
func_name = functions(incre_func);
iter = 1;
while (init_size+incre_size*(iter-1)) < class_num
    cx = [init_size+incre_size*(iter-1), min(init_size+incre_size*iter, class_num)];
    if strcmp(func_name.function, 'baseline')
        % retrain
        Qx = 1: cx(2)*train_num;
        tic;
        sroot = train(data_train, Qx, cx(2), forest_size, depthmax, train_func);
        train_time = [train_time toc];
    else
        % increment
        Qx = cx(1)*train_num+1: cx(2)*train_num;
        Qx = Qx(randperm(length(Qx)));
        tic;
        sroot = increment(sroot, data_train, Qx, cx(2), depthmax, cut_ratio, incre_func, train_func, test_func);
        train_time = [train_time toc];
    end
    % error
    Qx = 1: cx(2)*train_num;
    [~, error] = test(sroot, data_train, Qx, cx(2), test_func);
    train_error = [train_error, error];
    Qx = 1: cx(2)*test_num;
    tic
    [~, error] = test(sroot, data_test, Qx, cx(2), test_func);
    test_time = [test_time toc];
    test_error = [test_error, error];
    iter = iter + 1;
end
