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
    end
end

