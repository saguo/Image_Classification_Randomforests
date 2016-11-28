classdef sbranch    
    properties
        theta       %exist only split found
        tau         %exist only split found
        BL          %exist only split found
        BR          %exist only split found    
        PQ          %should exist only on terminal node
    end
    methods
         function obj=sbranch(theta,tau,BL,BR,PQ)
            obj.theta=theta;
            obj.tau=tau;
            obj.BL=BL;
            obj.BR=BR;
            obj.PQ=PQ;
         end
    end 
end