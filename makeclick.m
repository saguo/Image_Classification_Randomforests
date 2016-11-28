close all
clear all

clmax=input('Enter number of classes: ');
if isempty(clmax)
    clmax=3;
end
nmax=input('Enter number of population per class: ');
if isempty(nmax)
    nmax=30;
end
depthmax=input('Enter maximum depth: ');
if isempty(depthmax)
    depthmax=5;
end
mmax=input('Enter number of tree: ');
if isempty(mmax)
    mmax = 10;
end
save('config.mat','clmax','mmax','nmax','depthmax');


axis([0 1 0 1])
grid on
x=[];
data=[];
markers=['x','o','*','.','s','d','^','v','>','<'];
hold on;
for class=1:clmax
    display(class);
   for i=1:nmax
       i
       data=[data; ginput(1) class];
       plot(data((class-1)*nmax+i,1),data((class-1)*nmax+i,2),markers(class));
   end
end
save('data.mat','data')
