clear
source = 0; % 0 for spiral data, else for real data

if source == 0
    % prepare spiral data using previously defined "train_num, test_num, class_num"
    train_num = 100; % train_num: polpulation of each class for training
    test_num = 20; % polpulation of each class for testing
    class_num = 10; % class_num: class number of all data
    [data_train, data_test] = prepare_spiral_data(class_num, train_num, test_num); % spiral data
else
    % load real data, it is already formated and includes "train_num, test_num, class_num", 
    % so if you define these three variables before, they will be overwritten by mine, just in case 
    % some careless assign invalid values. But it's fine that you redefine "class_num" after loading data.
    load('features/real.mat'); 
%     class_num = 6; % just for short time test
end

init_size = 5; % init_size: class number of initial training data
incre_size = 5; % incre_size: class number of each increment
forest_size = 10; % forest_size: number of trees
depthmax = 10; % depthmax: maximum tree depth
cut_ratio = 0.3; % cut_ratio: only used in RTST and RTSTQ
incre_func = @RTSTQ; % incre_fuc: specific function for tree increment: baseline, ULS, IGT, RTST, RTSTQ
train_func = @ncm_train; % train_func: specific function for spliting data in a node: split_train, ncm_train, svm_train
test_func = @ncm_test; % test_func: specific function for testing data in a node: split_test, ncm_test, svm_test

[train_error, test_error, train_time, test_time, sroot] = oneclickresult(data_train, data_test, train_num, test_num...
    , class_num, init_size, incre_size, forest_size, depthmax, cut_ratio, incre_func, train_func, test_func);