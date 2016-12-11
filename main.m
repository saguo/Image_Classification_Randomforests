clear
clmax = 5; % number of maximum classes
initsize = 5; % number of initial classes
nmax = 300; % population of each class
trainmax = 500; % max population of each training class; realdata fixed:500
testmax = 100; % max population of each test class; realdata fixed:100
mmax = 10; % number of trees
depthmax = 10; % maximum depth for each tree
ratio = 0.3; 
incre_func = @RTSTQ; % incremental learning method
train_func = @ncm_train; % split_train or ncm_train or svm_train
test_func = @ncm_test;
increment = 0; % increment -1 static - 0
realdata = 1;   % realdata - 1 spiraldata - 0  

if realdata
[data_train, data_test] = prepare_real_data;  
else
[data_train, data_test] = prepare_spiral_data(clmax, nmax, trainmax);
end

% format training data
data_init = data_train(1: initsize * trainmax, :);
data_init = data_init(randperm(size(data_init, 1)), :);
% train
sroot = train(data_init, initsize, mmax, depthmax, train_func);
[~, train_error] = test(sroot, data_init, initsize, test_func);

% format increment data
data_incre = data_train(initsize*trainmax+1: end, :);
data_incre = data_incre(randperm(size(data_incre, 1)), :);
data_combined = [data_init; data_incre];
Qx = [1: size(data_incre ,1)] + size(data_init, 1);

if increment
sroot = increment(sroot, data_combined, Qx, clmax, depthmax, ratio, incre_func, train_func, test_func);
[~, incre_error] = test(sroot, data_combined, clmax, test_func);
else
sroot = static(sroot, data_init, Qx, clmax, depthmax, train_func);
[~, static_error] = test(sroot, data_combined, clmax, test_func);
end

% format testing data
data_init = data_test(1: initsize * testmax, :);
data_test = data_test(randperm(size(data_test, 1)), :);
% test
[pred, test_error] = test(sroot, data_test, clmax, test_func);
