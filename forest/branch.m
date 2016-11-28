classdef branch    
    properties
        Qx 
        depth       
        theta       %exist only split found
        tau         %exist only split found
        magnitude
        entropy
        BL          %exist only split found
        BR          %exist only split found    
        PQ          %should exist only on terminal node
    end
    methods
        function obj=branch(Qx,depth,magnitude,entropy,PQ)
           obj.Qx=Qx;
           obj.depth=depth;
           obj.magnitude=magnitude;
           obj.entropy=entropy;
           obj.PQ=PQ;
        end
        function parent=grow(parent,data,maxdepth,clmax)
            th=0;%-2.321928;
            display(sprintf('Growth Depth: %d',parent.depth));
            BestGain=th;
            for i=1:length(parent.Qx)
                % 2. random splitting parameters phi=[theta,tau]
                % theta1=x, theta2=y
                new_theta=randi(2); %maximum dimension is 2
                new_tau=data(parent.Qx(i),new_theta);    %random the threshold
                QLx=parent.Qx(data(parent.Qx,new_theta)<new_tau);
                QRx=parent.Qx(data(parent.Qx,new_theta)>=new_tau);

                % compute entropy the left node
                PQL=hist(data(QLx,3),1:clmax)+1e-6;
                PQL=PQL/sum(PQL);
                entropyQL=-1*sum(PQL.*log2(PQL));
                magnitudeQL=length(QLx);

                % compute entropy the right node
                PQR=hist(data(QRx,3),1:clmax)+1e-6;
                PQR=PQR/sum(PQR);
                entropyQR=-1*sum(PQR.*log2(PQR));
                magnitudeQR=length(QRx);

                Gain=parent.entropy-(magnitudeQL*entropyQL + magnitudeQR*entropyQR)/parent.magnitude;
                
                if(BestGain<Gain)
                   parent.theta=new_theta;
                   parent.tau=new_tau;
                   parent.BL=branch(QLx,parent.depth+1,magnitudeQL,entropyQL,PQL);
                   parent.BR=branch(QRx,parent.depth+1,magnitudeQR,entropyQR,PQR);
                   BestGain=Gain;
                end
            end
            if(th<BestGain && parent.depth<=maxdepth)
               display(sprintf('BestGain: %f',BestGain));
               display(parent)
               parent.BL=grow(parent.BL,data,maxdepth,clmax); 
               parent.BR=grow(parent.BR,data,maxdepth,clmax);               
            end
        end
    end    
end

