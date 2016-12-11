function [data_train, data_test] = prepare_real_data

addpath('features')

load 'features.mat'

data_train = [train_x' train_y'];

data_test = [test_x',test_y'];


end
