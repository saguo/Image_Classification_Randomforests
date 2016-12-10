classdef branch
    properties
        Qx
        depth
        nNode       %size of subtree
        par         %exist only split found
        magnitude
        entropy
        BL          %exist only split found
        BR          %exist only split found
        PQ          %probability distribution
    end
    methods
        function obj=branch(Qx,depth,magnitude,entropy,PQ)
           obj.Qx=Qx;
           obj.depth=depth;
           obj.magnitude=magnitude;
           obj.entropy=entropy;
           obj.PQ=PQ;
        end
        function parent=grow(parent,data,maxdepth,clmax,train_function)
            [QLx_, QRx_, par_, entropyQL_, entropyQR_, PQL_, PQR_, split_found] = ...
                train_function(data, parent.Qx, parent.entropy, clmax);
            
            % if no split is found, stop at current node. else
            if(split_found==1 && parent.depth<=maxdepth)
                parent.par = par_;
                parent.BL=branch(QLx_,parent.depth+1,length(QLx_),entropyQL_,PQL_);
                parent.BR=branch(QRx_,parent.depth+1,length(QRx_),entropyQR_,PQR_);

%                 display(parent)

                parent.BL=grow(parent.BL,data,maxdepth,clmax,train_function);
                parent.BR=grow(parent.BR,data,maxdepth,clmax,train_function);
            end
        end
        
        function [parent, cut_max] = ULS(parent, data, Qx, clmax, maxdepth, cut_max, train_func, test_func)
            if isempty(parent.par)
                return;
            end
            [QLx, QRx] = test_func(data, Qx, parent.par);            
            parent.BL.Qx = [parent.BL.Qx, QLx];
            parent.BL.magnitude = length(parent.BL.Qx);
            parent.BR.Qx = [parent.BR.Qx, QRx];
            parent.BR.magnitude = length(parent.BR.Qx);            
            [~, parent.BL.PQ, parent.BR.PQ, parent.BL.entropy, parent.BR.entropy] = ... 
                gain_entropy(parent.entropy, parent.BL.Qx, parent.BR.Qx, data, clmax);
            
            [parent.BL, ~] = ULS(parent.BL, data, QLx, clmax, maxdepth, cut_max, train_func, test_func);
            [parent.BR, ~] = ULS(parent.BR, data, QRx, clmax, maxdepth, cut_max, train_func, test_func);
            
        end
        
        function [parent, cut_max] = IGT(parent, data, Qx, clmax, maxdepth, cut_max, train_func, test_func)
            if isempty(parent.par)
                parent = grow(parent,data,maxdepth,clmax,train_func);
                return;
            end
            [QLx, QRx] = test_func(data, Qx, parent.par);            
            parent.BL.Qx = [parent.BL.Qx, QLx];
            parent.BL.magnitude = length(parent.BL.Qx);
            parent.BR.Qx = [parent.BR.Qx, QRx];
            parent.BR.magnitude = length(parent.BR.Qx);            
            [~, parent.BL.PQ, parent.BR.PQ, parent.BL.entropy, parent.BR.entropy] = ... 
                gain_entropy(parent.entropy, parent.BL.Qx, parent.BR.Qx, data, clmax);
            
            [parent.BL, ~] = IGT(parent.BL, data, QLx, clmax, maxdepth, cut_max, train_func, test_func);
            [parent.BR, ~] = IGT(parent.BR, data, QRx, clmax, maxdepth, cut_max, train_func, test_func);
            
        end
        
        function [parent,cut_max] = RTST(parent, data, Qx, clmax, maxdepth, cut_max, train_func, test_func)
           % nNode is the number of node in a tree
           % cut_max is the maximum number of nodes which will be retrained
           nNode_sub = calcNode(parent,1); % the number of nodes in a subtree
           if nNode_sub <= cut_max
               wnNode = calcwNode(parent,parent.depth,1); %the 'weighted' number of nodes in a subtree
               if rand(1) <= 1/parent.nNode*wnNode; 
                   cut_max = cut_max - nNode_sub;
                   parent = grow(parent,data,maxdepth,clmax,train_func);
                   return;
               end
           end
           
           if isempty(parent.par)
                parent = grow(parent,data,maxdepth,clmax,train_func);
                return;
           end
            
            [QLx, QRx] = test_func(data, Qx, parent.par);            
            parent.BL.Qx = [parent.BL.Qx, QLx];
            parent.BL.magnitude = length(parent.BL.Qx);
            parent.BR.Qx = [parent.BR.Qx, QRx];
            parent.BR.magnitude = length(parent.BR.Qx);            
            [~, parent.BL.PQ, parent.BR.PQ, parent.BL.entropy, parent.BR.entropy] = ... 
                gain_entropy(parent.entropy, parent.BL.Qx, parent.BR.Qx, data, clmax);
            
            [parent.BL,cut_max] = RTST(parent.BL, data, QLx, clmax, maxdepth, cut_max, train_func, test_func);
            [parent.BR,cut_max] = RTST(parent.BR, data, QRx, clmax, maxdepth, cut_max, train_func, test_func);           
           
        end
        
        function parent = subtree_size(parent)
            if isempty(parent.par)
                parent.nNode = 1;
                return
            end            
            parent.BL = subtree_size(parent.BL);
            parent.BR = subtree_size(parent.BR);
            parent.nNode = parent.BL.nNode + parent.BR.nNode;
        end
        
        function PQ_out = prediction(parent, data, Qx_in, PQ_out, test_func)
            if isempty(parent.par)
                for i = 1:length(parent.PQ);
                    PQ_out(Qx_in,i) = PQ_out(Qx_in,i)+parent.PQ(i);
                end
                return;
            end
            [QLx, QRx] = test_func(data, Qx_in, parent.par);
            PQ_out = prediction(parent.BL, data, QLx, PQ_out, test_func);
            PQ_out = prediction(parent.BR, data, QRx, PQ_out, test_func);
        end
        
    end
end

