clear
clmax = 10;
initsize = 5;
nmax = 300;
trainmax = 70;
mmax = 10;
depthmax = 10;
ratio = 0.3;
incre_func = @IGT;
train_func = @split_train;
test_func = @split_test;

[data_train, data_test] = prepare_spiral_data(clmax, nmax, trainmax);

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
% increment
sroot = increment(sroot, data_combined, Qx, clmax, depthmax, ratio, incre_func, train_func, test_func);
[~, incre_error] = test(sroot, data_combined, clmax, test_func);

% format testing data
data_test = data_test(randperm(size(data_test, 1)), :);
% test
[pred, test_error] = test(sroot, data_test, clmax, test_func);