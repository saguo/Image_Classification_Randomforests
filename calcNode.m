% This function calculates the number of nodes in a tree
% itinital nNode = 1
function nNode = calcNode(parent,nNode)
   if isempty(parent.par)
       return;
   end
   nNode = nNode + 2; %If par exist, there are 2 more nodes(children).
   nNode = calcNode(parent.BL,nNode);
   nNode = calcNode(parent.BR,nNode);   
end



