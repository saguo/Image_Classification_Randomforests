% demo_tk
% this mfile consists of 4 parts
%(1) generate train and test data using makespiral.m
%(2) obtaine trees using rt1.m
%(3) classify test data using test.m (flag=0) or another one (flag=1) 
%(4) calculate error

clear all
%% generate training and test data
makespiral % save (i) training data in data.mat and (ii)clmax, mmax, nmax, depthmax in config.mat
% use default values, which are following
% clmax=5;
% nmax=100;
% depthmax=20;
% mmax = 10;

% devide data into train and test data
datasize = size(data,1);
data_tr = data(1:round(0.7*datasize),:); % training data
data_ts = data(size(data_tr,1)+1:end,:); % test data
save('data_tr.mat','data_tr');
save('data_ts.mat','data_ts');
clear

%% generate decision tree
clear
% load training data and rename it as data
load data_tr.mat
data = data_tr;
save('data.mat','data'); %overwrite data

rt1 % use data.m and config.mat to generate and save root in tree01, tree02, etc.

%% classify test data
clear
% load test data and rename it as data
load data_ts.mat
data = data_ts;
save('data.mat','data'); %overwrite data

flag = 0; % 0 or 1
if flag == 0
    test
    % it does not work...
elseif flag == 1
% split_test_k.m is used
load('data.mat');
load('config.mat') % clmax, (nmax), (depthmax), mmax
index = [1:size(data,1)]';

pred = zeros(size(data,1),mmax); %each collumn is predicted classes using each tree
for m = 1:mmax;
   output = cell(clmax,1); %initialization
   % output consists of mmax cells. each cell corresponds to class. each cell
   % containes the index of data, which are classified into that class.
   
   load(strcat('tree',sprintf('%02d.mat',m)),'root');
   output = split_test_k(root, data, index, output);
   
   % make tmp (1st collumn:sorted index, 2nd collumn:predicted class)
   tmp = [output{1} ones(size(output{1}))]; %1st collumn:index, 2nd collumn:predicted class
   for i = 2:clmax
       tmp = [tmp; output{i} i*ones(size(output{i}))];
   end
   [~, I] = sort(tmp(:, 1));
   stmp = tmp(I, :); %1st collumn:sorted index, 2nd collumn:predicted class
   pred(:,m) = stmp(:,2);
end
% majority vote
tmp0 = histc(pred,1:mmax,2);
[~,cpred] = max(tmp0,[],2); % final predicted class
end

%% calculate error

[~,label] = max(PQ_out,[],2);
error = sum(label(:,1) ~= data(:,size(data,2))) / size(data,1);
 

