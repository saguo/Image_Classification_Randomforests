% demo_realdata
% this mfile consists of 4 parts
%(1) generate training and test data using makespiral.m
%(2) obtain trees using rt1.m
%(3) classify test data using test.m (flag=0) or another one (flag=1) 
%(4) calculate error

clear all
%% data preparation

nclass = 3; % number of classes
data_preparation(nclass); 



%% generate training and test data
load('data.mat')
load('config.mat')

% % divide data into train and test data
% datasize = size(data,1);
% data_tr = data(1:round(0.7*datasize),:); % training data
% data_ts = data(size(data_tr,1)+1:end,:); % test data
% save('data_tr.mat','data_tr');
% save('data_ts.mat','data_ts');
% 
% %% generate decision tree
% clear
% % load training data and rename it as data
% load data_tr.mat
% data = data_tr;
% save('data.mat','data'); %overwrite data

rt1 % train

% %% classify test data
% clear
% % load test data and rename it as data
% load data_ts.mat
% data = data_ts;
% save('data.mat','data'); %overwrite data

test %test

%% calculate error

[~,label] = max(PQ_out,[],2);
error = sum(label(:,1) ~= data(:,size(data,2))) / size(data,1);