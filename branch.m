classdef branch
    properties
        Qx
        depth
        par         %exist only split found
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

            [QLx_, QRx_, par_, entropyQL_, entropyQR_, PQL_, PQR_, split_found] = ...
                split_train(data, parent.Qx, parent.entropy, clmax);
            % if no split is found, stop at current node. else
            if(split_found==1 && parent.depth<=maxdepth)
                parent.par = par_;
                parent.BL=branch(QLx_,parent.depth+1,length(QLx_),entropyQL_,PQL_);
                parent.BR=branch(QRx_,parent.depth+1,length(QRx_),entropyQR_,PQR_);

                display(parent)

                parent.BL=grow(parent.BL,data,maxdepth,clmax);
                parent.BR=grow(parent.BR,data,maxdepth,clmax);
            end
        end
        
        function parent = ULS(parent, data, clmax)
            if isempty(parent.par)
                return;
            end
            [QLx, QRx] = split_test(data, parent.Qx, parent.par);
            [~,PQL,PQR,entropyQL,entropyQR] = gain_entropy(parent.entropy,QLx,QRx,data,clmax);
            
            parent.BL.PQ = PQL;
            parent.BL.Qx = QLx;
            parent.BL.magnitude = length(QLx);
            parent.BL.entropy = entropyQL;
            parent.BL.PQ = PQR;
            parent.BL.Qx = QRx;
            parent.BL.magnitude = length(QRx);
            parent.BL.entropy = entropyQR;
        end
        
        function PQ_out = test(parent, data, Qx_in, PQ_out)
            if isempty(parent.par)
                for i = 1:length(parent.PQ);
                    PQ_out(Qx_in,i) = PQ_out(Qx_in,i)+parent.PQ(i);
                end
                return;
            end
            [QLx, QRx] = split_test(data, Qx_in, parent.par);
            PQ_out = test(parent.BL, data, QLx, PQ_out);
            PQ_out = test(parent.BR, data, QRx, PQ_out);
        end
    end
end

