clear
clmax = 5; % number of maximum classes
initsize = 2 ; % number of initial classes
nmax = 60; % population of each class
trainmax = 50; % max population of each training class; realdata fixed:500
testmax = 10; % max population of each test class; realdata fixed:100
mmax = 10; % number of trees
depthmax = 10; % maximum depth for each tree
ratio = 0.3; 
incre_func = @RTSTQ; % incremental learning method
train_func = @svm_train; % split_train or ncm_train or svm_train
test_func = @svm_test;
increment_m = 1; % increment -1 static - 0
realdata = 0;   % realdata - 1 spiraldata - 0  

if realdata
    [data_train, data_test] = prepare_real_data(initsize);
     data_init = data_train;
    
else
    [data_train, data_test] = prepare_spiral_data(clmax, nmax, trainmax);
    
    % format training data
    data_init = data_train(1: initsize * trainmax, :);
    data_init = data_init(randperm(size(data_init, 1)), :);
    
    % format testing data
    data_test = data_test(1: initsize * testmax, :);
    data_test = data_test(randperm(size(data_test, 1)), :);
    
end

if increment_m
    % format increment data
    data_incre = data_train(initsize*trainmax+1: end, :);
    data_incre = data_incre(randperm(size(data_incre, 1)), :);
    data_combined = [data_init; data_incre];
    Qx = [1: size(data_incre ,1)] + size(data_init, 1);
    
    
    %train
    sroot = train(data_train, initsize, mmax, depthmax, train_func);
    sroot = increment(sroot, data_combined, Qx, clmax, depthmax, ratio, incre_func, train_func, test_func);
    [~, incre_error] = test(sroot, data_combined, clmax, test_func);
else
    
    %train
    t1 = 0; t2 = 0;
    tic;
    sroot = train(data_train, initsize, mmax, depthmax, train_func);
    t1 = toc;
    [~, train_error] = test(sroot, data_init, initsize, test_func);
    t2 = toc;
end


% test
[pred, test_error] = test(sroot, data_test, clmax, test_func);
