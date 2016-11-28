close all
clear all

clmax=input('Enter number of classes: ');
if isempty(clmax)
    clmax=5;
end
nmax=input('Enter number of population per class: ');
if isempty(nmax)
    nmax=100;
end
depthmax=input('Enter maximum depth: ');
if isempty(depthmax)
    depthmax=20;
end
mmax=input('Enter number of tree: ');
if isempty(mmax)
    mmax = 10;
end
save('config.mat','clmax','mmax','nmax','depthmax');

grid on
x=[];
data=zeros(nmax*clmax,3);
markers=['x','o','*','.','s','d','^','v','>','<'];
hold on;
for i=1:nmax*clmax
    r=(randn(1)+3)*2;
    class=randi(clmax);
    angle=2*pi/clmax*class+randn()*2*pi/clmax/10+0.5*r;
    data(i,:)=[r*cos(angle), r*sin(angle), class];
    plot(data(i,1),data(i,2),markers(class));
    hold on
end
axis equal
save('data.mat','data')