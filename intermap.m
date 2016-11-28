%% clmap.m
clear all
close
load('config.mat')
load('data.mat');
if(size(data,1)>1000)
    ind=randperm(size(data,1));
   data=data(ind(1:1000),:);
end
thetamin=min(data,[],1);
thetamax=max(data,[],1);
xmax=200;
ymax=200;
scale=(thetamax-thetamin)./[xmax ymax 1];

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

img=ones(ymax,xmax,3);
trees=[];


for m=1:mmax
    load(strcat('tree',sprintf('%02d.mat',m)));
    trees=[trees sroot];
end

for i=1:xmax
    for j=1:ymax
        theta=[scale(1)*i+thetamin(1),scale(2)*j+thetamin(1)];
        for m=1:mmax
            parent=trees(m);
            %display(strcat('tree',sprintf('%02d ',m)));
            while 1
                if isempty(parent.par)
                    PQ(m,:)=parent.PQ;
                    break;
                end
                direction = svm_test(theta, parent.par);
                if direction==1
                    next_parent=parent.BL;
                    %display(sprintf('L '));
                elseif direction==2
                    next_parent=parent.BR;
                    %display(sprintf('R '));
                else
                    error('fail to predict');
                end
                parent=next_parent;
            end
        end
        Pout=sum(PQ,1)/mmax;
        %[v index]=max(parent.PQ);
        %img(j,i)=index;
        img(j,i,:)=Pout*colors(1:clmax,:);
    end
end
image(img);
hold on

for i=1:size(data,1)
    plot( (data(i,1)-thetamin(1))/scale(1), (data(i,2)-thetamin(2))/scale(2), strcat(markers(data(i,3)),'k'));
end
axis xy
