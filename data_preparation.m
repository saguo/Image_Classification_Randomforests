function [data_train, data_test] = data_preparation(clmax)

addpath('features')

load 'features.mat'

% get first n classes of images

train_num = 500;
test_num = 100;

train_x_n = train_x(:, 1: clmax * train_num);
train_y_n = train_y(:, 1: clmax * train_num);

test_x_n = test_x(:, 1: clmax * test_num);
test_y_n = test_y(:, 1: clmax * test_num);


data_train = [train_x_n' train_y_n'];

data_test = [test_x_n',test_y_n'];
