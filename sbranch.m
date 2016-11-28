classdef sbranch    
    properties
        par         %exist only split found
        BL          %exist only split found
        BR          %exist only split found    
        PQ          %should exist only on terminal node
    end
    methods
         function obj=sbranch(par,BL,BR,PQ)
            obj.par=par;
            obj.BL=BL;
            obj.BR=BR;
            obj.PQ=PQ;
         end
    end 
end