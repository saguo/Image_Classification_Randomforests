function [data_train, data_test] = prepare_spiral_data(clmax, train_num, test_num)
%%
% clmax: number of class
% train_num: population of each class for training
% test_num: population of each class for test

nmax = train_num + test_num;
data = makespiral_f(clmax, nmax);
[~, index] = sort(data(:, 3));
data = data(index, :);

% get training data
aa = 1:train_num;
index = [];
for i = 0: clmax - 1
    index = [index aa + i * nmax];
end
data_train = data(index, :);

% get testing data
aa = train_num+1: nmax;
index = [];
for i = 0: clmax - 1
    index = [index aa + i * nmax];
end
data_test = data(index, :);

