function [data_train, data_test] = prepare_spiral_data(clmax, nmax, train_max)
%%
% clmax: number of class
% nmax: population of each class
% train_max: population of each class for training

data = makespiral_f(clmax, nmax);
[~, index] = sort(data(:, 3));
data = data(index, :);

% get training data
aa = 1:train_max;
index = [];
for i = 0: clmax - 1
    index = [index aa + i * nmax];
end
data_train = data(index, :);

% get testing data
aa = train_max+1: nmax;
index = [];
for i = 0: clmax - 1
    index = [index aa + i * nmax];
end
data_test = data(index, :);

