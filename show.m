%% show.m
close
clear all
load('data.mat');
if(size(data,1)>1000)
    ind=randperm(size(data,1));
   data=data(ind(1:1000),:);
end
load('config.mat')
markers=['x','o','*','.','s','d','^','v','>','<'];
colors=[    hex2dec('1f')/255 hex2dec('77')/255 hex2dec('b4')/255;
            hex2dec('ff')/255 hex2dec('7f')/255 hex2dec('0e')/255;
            hex2dec('2c')/255 hex2dec('a0')/255 hex2dec('2c')/255;
            hex2dec('d6')/255 hex2dec('27')/255 hex2dec('28')/255;
            hex2dec('94')/255 hex2dec('67')/255 hex2dec('bd')/255;
            hex2dec('8c')/255 hex2dec('56')/255 hex2dec('4b')/255;
            hex2dec('e3')/255 hex2dec('77')/255 hex2dec('c2')/255;
            hex2dec('7f')/255 hex2dec('7f')/255 hex2dec('7f')/255;
            hex2dec('bc')/255 hex2dec('bd')/255 hex2dec('22')/255;
            hex2dec('17')/255 hex2dec('be')/255 hex2dec('cf')/255];
        
class=zeros(size(data,1),1);

trees=[];
for m=1:mmax
    load(strcat('tree',sprintf('%02d.mat',m)));
    trees=[trees sroot];
end

for i=1:size(data,1)
    theta=data(i,1:2);
    P=zeros(1,clmax);
    for m=1:mmax
        parent=trees(m);
        while 1
            if theta(parent.theta) < parent.tau
                next_parent=parent.BL;
            else
                next_parent=parent.BR;
            end
            if isempty(next_parent)
                P=P+parent.PQ;
                break;
            else
                parent=next_parent;
            end
        end
    end
    
    [v index]=max(P);
    class(i,1)=index;
    
    plot(theta(1),theta(2), markers(data(i,3)), 'MarkerEdgeColor', colors(class(i),:), 'MarkerSize',10);
    hold on
end
