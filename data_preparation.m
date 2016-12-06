%function data_preparation(n)


load 'features.mat'
n =3;
% get first n classes of images
class_num = 100;
train_num = 500;
valid_num = 50;
test_num = 100;

train_x_n = train_x(:, 1: n * train_num);
train_y_n = train_y(:, 1: n * train_num);
% do a permutation before use
perm = randperm(n * train_num);
train_x_n = train_x_n(:,perm);
train_y_n = train_y_n(:,perm);

data = [train_x_n' train_y_n'];

save('data.mat','data') 

clmax = n; % number of classes
nmax = 500;  % number of population per class
mmax = 10; % number of trees(default)
depthmax = 20;   % maximum depth(default)

save('config.mat','clmax','mmax','nmax','depthmax');