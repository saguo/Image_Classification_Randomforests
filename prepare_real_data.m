function [data_train, data_test] = prepare_real_data(n)

addpath('features')

load 'features.mat'


  % get first n classes of images
  class_num = 100;
  train_num = 500;
  valid_num = 50;
  test_num = 100;
  
  train_x_n = train_x(:, 1: n * train_num);
  train_y_n = train_y(:, 1: n * train_num);
 
  test_x_n = test_x(:, 1: n * test_num);
  test_y_n = test_y(:, 1: n * test_num);
 
  
  % normalize starting training features
  train_x_mean = mean(train_x_n, 2);
  train_x_std = std(train_x_n, 1, 2);
  train_x_normalized = (train_x_n - repmat(train_x_mean, 1,  size(train_x_n,2)))...
  ./ repmat(train_x_std, 1, size(train_x_n,2));

  test_x_mean = mean(test_x_n, 2);
  test_x_std = std(test_x_n, 1, 2);
  test_x_normalized = (test_x_n - repmat(test_x_mean, 1,  size(test_x_n,2)))...
  ./ repmat(test_x_std, 1, size(test_x_n,2));


  % do a permutation before use
  perm = randperm(n * train_num);
  train_x_m = train_x_normalized(:,perm);
  train_y_m = train_y(:,perm);
 
  perm_ts = randperm(n * test_num);
  test_x_m = test_x_normalized(:,perm_ts);
  test_y_m = test_y_n(:,perm_ts);
  
  data_train = [train_x_m',train_y_m'];

  data_test = [test_x_m',test_y_m'];

end
