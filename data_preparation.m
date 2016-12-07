function data_preparation(n)


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

% do a permutation before use
perm = randperm(n * train_num);
train_x_n = train_x_n(:,perm);
train_y_n = train_y_n(:,perm);

perm_ts = randperm(n * test_num);
test_x_n = test_x_n(:,perm_ts);
test_y_n = test_y_n(:,perm_ts);

data = [train_x_n' train_y_n'];

data_ts = [test_x_n',test_y_n'];

save('data.mat','data')
save('data_ts.mat', 'data_ts')

clmax = n; % number of classes
nmax = 500;  % number of population per class
mmax = 10; % number of trees(default)
depthmax = 20;   % maximum depth(default)

save('config.mat','clmax','mmax','nmax','depthmax');

clmax = n; % number of classes
nmax = 100;  % number of population per class
mmax = 10; % number of trees(default)
depthmax = 20;   % maximum depth(default)
save('config_ts.mat','clmax','mmax','nmax','depthmax');