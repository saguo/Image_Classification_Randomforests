% demo_realdata
% this mfile consists of 3 parts
%(1) obtain trees using rt1.m
%(2) classify test data using test.m (flag=0) or another one (flag=1) 
%(3) calculate error

clear all
%% data preparation

nclass = 5; % number of classes
data_preparation(nclass); 


%% training and test

rt1 % train

test %test
