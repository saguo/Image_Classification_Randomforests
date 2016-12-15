%%% Author: Zhaoming Zhang
function data = makespiral_f(clmax, nmax)
%% make spiral data
% clmax: number of classes
% nmax: number of population per class 

% grid on
x=[];
data=zeros(nmax*clmax,3);
% markers=['x','o','*','.','s','d','^','v','>','<'];
% hold on;
for i=1:nmax*clmax
    r=(randn(1)+3)*2;
    class=randi(clmax);
    angle=2*pi/clmax*class+randn()*2*pi/clmax/10+0.5*r;
    data(i,:)=[r*cos(angle), r*sin(angle), class];
%     plot(data(i,1),data(i,2),markers(class));
%     hold on
end
% axis equal
