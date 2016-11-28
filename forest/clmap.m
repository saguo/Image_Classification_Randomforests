%% clmap.m
clear all
close
load('config.mat')
%number of classes
clmax
%number of trees
mmax
%number of population per class
nmax
%max depth
depthmax

markers=['x','o','.','s','*','d','^','v','>','<'];
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


PQ=zeros(mmax,clmax);
xmax=40;
ymax=40;
%img=ones(ymax,xmax);
img=ones(ymax,xmax,3);
trees=[];
for m=1:mmax
    load(strcat('tree',sprintf('%02d.mat',m)));
    trees=[trees sroot];
end

for i=1:xmax
    for j=1:ymax
        theta=[i/xmax,j/ymax];
        for m=1:mmax
            parent=trees(m);
            %display(strcat('tree',sprintf('%02d ',m)));
            while 1
                if theta(parent.theta) < parent.tau
                    next_parent=parent.BL;
                    %display(sprintf('L '));
                else
                    next_parent=parent.BR;
                    %display(sprintf('R '));
                end
                if isempty(next_parent)
                    PQ(m,:)=parent.PQ;
                    break;
                else
                    parent=next_parent;
                end
            end
        end
        Pout=sum(PQ,1)/mmax;
        %[v index]=max(parent.PQ);
        %img(j,i)=index;
        img(j,i,:)=Pout*colors(1:clmax,:);
    end    
end
%imshow(img,colors,'Border','tight');
imshow(img,'Border','tight');
hold on
load('data.mat');
for i=1:size(data,1)
    plot(data(i,1)*xmax,data(i,2)*ymax, strcat(markers(data(i,3)),'k'));
end
axis xy