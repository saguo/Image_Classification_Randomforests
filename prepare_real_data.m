load('features/features.mat');

data_train = [train_x; train_y]';
data_valid = [valid_x; valid_y]';
data_test = [test_x;test_y]';

save('features/real', 'data_train', 'data_valid', 'data_test', ...
    'wordmap', 'trainmap', 'validmap', 'testmap', 'class_num', 'train_num', 'valid_num', 'test_num');